from decimal import Decimal
from typing import Literal
from uuid import UUID

from pydantic import BaseModel, Field


class ProblemDetail(BaseModel):
    type: str = "about:blank"
    title: str
    status: int
    detail: str
    trace_id: str | None = Field(default=None, serialization_alias="traceId")


class LivenessResponse(BaseModel):
    status: Literal["ok"] = "ok"
    service: str = "solver-svc"


class ReadinessResponse(BaseModel):
    status: Literal["ready", "degraded"]
    service: str = "solver-svc"
    ortools_version: str
    cpsat_ready: bool
    pgvector_module: bool
    database_connected: bool | None = None


class RawSkuCandidateInput(BaseModel):
    sku_id: UUID
    name: str = Field(min_length=1)
    brand: str | None = None
    pack_size: Decimal = Field(gt=0)
    unit: Literal["g", "kg", "ml", "l", "pcs"]
    category: str | None = None


class MatchSkusRequest(BaseModel):
    skus: list[RawSkuCandidateInput] = Field(min_length=1, max_length=1000)
    auto_accept_threshold: float = Field(default=0.90, ge=0.0, le=1.0)


class MatchedSkuResult(BaseModel):
    sku_id: UUID
    ingredient_id: UUID | None
    net_weight_g: Decimal
    confidence: float = Field(ge=0.0, le=1.0)
    decision: Literal["auto_approved", "manual_review"]


class MatchSkusResponse(BaseModel):
    results: list[MatchedSkuResult]


class MacroGoalsInput(BaseModel):
    kcal: int = Field(ge=800, le=6000)
    protein_g: Decimal = Field(ge=0)
    fat_g: Decimal = Field(ge=0)
    carb_g: Decimal = Field(ge=0)


class OptimizePlanRequest(BaseModel):
    user_id: UUID
    goals: MacroGoalsInput
    budget_week_rub: Decimal = Field(gt=0)
    cooking_time_max_min: int = Field(default=45, gt=0)
    household_size: int = Field(default=1, ge=1)
    restrictions: list[str] = Field(default_factory=list)
    disliked_ingredient_ids: list[UUID] = Field(default_factory=list)
    days_count: int = Field(default=7, ge=1, le=7)


class OptimizePlanResponse(BaseModel):
    status: Literal["optimal", "feasible", "infeasible"]
    solve_time_ms: int
    total_cost_rub: Decimal
