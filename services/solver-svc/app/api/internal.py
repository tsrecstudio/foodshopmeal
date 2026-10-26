from fastapi import APIRouter, status
from fastapi.responses import JSONResponse

from app.schemas.contracts import (
    MatchSkusRequest,
    MatchSkusResponse,
    OptimizePlanRequest,
    OptimizePlanResponse,
    ProblemDetail,
)

router = APIRouter(prefix="/internal/v1", tags=["internal"])


@router.post(
    "/match-skus",
    response_model=MatchSkusResponse,
    responses={501: {"model": ProblemDetail}},
)
def match_skus_stub(payload: MatchSkusRequest) -> JSONResponse:
    problem = ProblemDetail(
        type="https://errors.foodshopmeal.ru/internal/not-implemented",
        title="Not Implemented Yet",
        status=status.HTTP_501_NOT_IMPLEMENTED,
        detail=(
            f"SKU matching pipeline ({len(payload.skus)} items) is scheduled "
            "for implementation in Stage M2."
        ),
    )
    return JSONResponse(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        media_type="application/problem+json",
        content=problem.model_dump(by_alias=True, exclude_none=True),
    )


@router.post(
    "/optimize-plan",
    response_model=OptimizePlanResponse,
    responses={501: {"model": ProblemDetail}},
)
def optimize_plan_stub(payload: OptimizePlanRequest) -> JSONResponse:
    problem = ProblemDetail(
        type="https://errors.foodshopmeal.ru/internal/not-implemented",
        title="Not Implemented Yet",
        status=status.HTTP_501_NOT_IMPLEMENTED,
        detail=(
            f"CP-SAT meal/basket optimizer for user {payload.user_id} is scheduled "
            "for implementation in Stage M3."
        ),
    )
    return JSONResponse(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        media_type="application/problem+json",
        content=problem.model_dump(by_alias=True, exclude_none=True),
    )
