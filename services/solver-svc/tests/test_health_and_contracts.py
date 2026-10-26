from pathlib import Path
from uuid import uuid4

import pytest
import yaml
from fastapi.testclient import TestClient

from app.main import create_app

REPO_ROOT = Path(__file__).resolve().parents[3]


@pytest.fixture()
def client(monkeypatch: pytest.MonkeyPatch) -> TestClient:
    monkeypatch.setenv("CHECK_DB_ON_READINESS", "false")
    return TestClient(create_app())


def test_liveness_probe(client: TestClient) -> None:
    resp = client.get("/health/live")
    assert resp.status_code == 200
    assert resp.json() == {"status": "ok", "service": "solver-svc"}


def test_readiness_probe_verifies_cpsat_and_pgvector(client: TestClient) -> None:
    resp = client.get("/health/ready")
    assert resp.status_code == 200
    body = resp.json()
    assert body["status"] == "ready"
    assert body["cpsat_ready"] is True
    assert body["pgvector_module"] is True
    assert body["ortools_version"] != "unknown"


def test_readiness_probe_returns_503_when_db_required_and_unreachable(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    monkeypatch.setenv("CHECK_DB_ON_READINESS", "true")
    monkeypatch.setenv("DATABASE_URL", "postgresql://nobody:bad@127.0.0.1:59999/none")
    local_client = TestClient(create_app())

    resp = local_client.get("/health/ready")
    assert resp.status_code == 503
    body = resp.json()
    assert body["status"] == "degraded"
    assert body["database_connected"] is False


def test_match_skus_contract_stub_and_validation(client: TestClient) -> None:
    valid_payload = {
        "skus": [
            {
                "sku_id": str(uuid4()),
                "name": "Творог Простоквашино 5% 200 г",
                "brand": "Простоквашино",
                "pack_size": "200",
                "unit": "g",
                "category": "Молочные продукты",
            }
        ],
        "auto_accept_threshold": 0.9,
    }
    resp = client.post("/internal/v1/match-skus", json=valid_payload)
    assert resp.status_code == 501
    assert resp.headers["content-type"].startswith("application/problem+json")
    assert "Stage M2" in resp.json()["detail"]

    invalid_resp = client.post("/internal/v1/match-skus", json={"skus": []})
    assert invalid_resp.status_code == 422
    assert invalid_resp.headers["content-type"].startswith("application/problem+json")


def test_optimize_plan_contract_stub_and_validation(client: TestClient) -> None:
    valid_payload = {
        "user_id": str(uuid4()),
        "goals": {"kcal": 1800, "protein_g": "150", "fat_g": "50", "carb_g": "180"},
        "budget_week_rub": "6000.00",
        "cooking_time_max_min": 35,
        "household_size": 1,
    }
    resp = client.post("/internal/v1/optimize-plan", json=valid_payload)
    assert resp.status_code == 501
    assert resp.headers["content-type"].startswith("application/problem+json")
    assert "Stage M3" in resp.json()["detail"]

    unsafe_kcal_payload = {
        **valid_payload,
        "goals": {"kcal": 400, "protein_g": "50", "fat_g": "20", "carb_g": "30"},
    }
    invalid_resp = client.post("/internal/v1/optimize-plan", json=unsafe_kcal_payload)
    assert invalid_resp.status_code == 422
    assert invalid_resp.json()["title"] == "Validation Failed"


def test_m0_compose_and_openapi_and_migration_artifacts() -> None:
    compose = yaml.safe_load((REPO_ROOT / "docker-compose.yml").read_text("utf-8"))
    services = set(compose["services"].keys())
    expected_services = {
        "postgres",
        "flyway",
        "redis",
        "minio",
        "minio-init",
        "kafka",
        "clickhouse",
        "otel-collector",
        "solver-svc",
        "core-api",
    }
    assert expected_services.issubset(services)

    for svc_name in ("postgres", "redis", "minio", "kafka", "clickhouse", "solver-svc", "core-api"):
        assert "healthcheck" in compose["services"][svc_name], f"Missing healthcheck on {svc_name}"

    for spec_name in ("bff-v1.yaml", "solver-internal-v1.yaml"):
        spec = yaml.safe_load((REPO_ROOT / "contracts/openapi" / spec_name).read_text("utf-8"))
        assert spec["openapi"] == "3.1.0"

    ci_cfg = yaml.safe_load((REPO_ROOT / ".github/workflows/ci.yml").read_text("utf-8"))
    assert {"migrations-and-compose", "solver-svc", "core-api"} == set(ci_cfg["jobs"].keys())

    v001_sql = (
        REPO_ROOT / "db/migrations/V001__init_schemas_extensions_and_system.sql"
    ).read_text("utf-8")
    for required_token in (
        'CREATE EXTENSION IF NOT EXISTS "vector"',
        "CREATE SCHEMA IF NOT EXISTS identity_pii",
        "CREATE SCHEMA IF NOT EXISTS core",
        "CREATE SCHEMA IF NOT EXISTS catalog",
        "CREATE SCHEMA IF NOT EXISTS fulfillment",
        "'retailer.local_list.enabled', TRUE",
        "'retailer.kuper.enabled',      FALSE",
        "pdn_health_152fz",
    ):
        assert required_token in v001_sql
