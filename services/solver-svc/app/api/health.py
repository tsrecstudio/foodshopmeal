import importlib.util

import ortools
import psycopg
from fastapi import APIRouter, Response, status
from ortools.sat.python import cp_model

from app.config import get_settings
from app.schemas.contracts import LivenessResponse, ReadinessResponse

router = APIRouter(tags=["health"])


def _check_cpsat_engine() -> bool:
    model = cp_model.CpModel()
    x = model.new_int_var(0, 2, "x")
    model.add(x == 1)
    solver = cp_model.CpSolver()
    solver.parameters.max_time_in_seconds = 0.2
    outcome = solver.solve(model)
    return outcome in (cp_model.OPTIMAL, cp_model.FEASIBLE) and solver.value(x) == 1


def _check_database(database_url: str) -> bool:
    try:
        with psycopg.connect(database_url, connect_timeout=2) as conn:
            with conn.cursor() as cur:
                cur.execute(
                    "SELECT COUNT(*) FROM pg_extension WHERE extname = 'vector'"
                )
                row = cur.fetchone()
                return bool(row and row[0] >= 1)
    except Exception:
        return False


@router.get("/health/live", response_model=LivenessResponse)
def health_live() -> LivenessResponse:
    return LivenessResponse(status="ok", service="solver-svc")


@router.get("/health/ready", response_model=ReadinessResponse)
def health_ready(response: Response) -> ReadinessResponse:
    settings = get_settings()
    cpsat_ok = _check_cpsat_engine()
    pgvector_ok = importlib.util.find_spec("pgvector") is not None

    db_ok: bool | None = None
    if settings.check_db_on_readiness:
        db_ok = _check_database(settings.database_url)

    all_ready = cpsat_ok and pgvector_ok and (db_ok is not False)
    if not all_ready:
        response.status_code = status.HTTP_503_SERVICE_UNAVAILABLE

    return ReadinessResponse(
        status="ready" if all_ready else "degraded",
        service=settings.service_name,
        ortools_version=getattr(ortools, "__version__", "unknown"),
        cpsat_ready=cpsat_ok,
        pgvector_module=pgvector_ok,
        database_connected=db_ok,
    )
