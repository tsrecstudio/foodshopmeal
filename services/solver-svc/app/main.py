import uuid

from fastapi import FastAPI, Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse

from app import __version__
from app.api.health import router as health_router
from app.api.internal import router as internal_router
from app.schemas.contracts import ProblemDetail

HTTP_422_STATUS = 422


def create_app() -> FastAPI:
    application = FastAPI(
        title="FoodShopMeal Solver Service",
        version=__version__,
        description="Internal CP-SAT Meal/Basket Optimizer & SKU Matcher",
    )

    @application.exception_handler(RequestValidationError)
    async def validation_exception_handler(
        request: Request, exc: RequestValidationError
    ) -> JSONResponse:
        trace_id = request.headers.get("traceparent") or uuid.uuid4().hex
        problem = ProblemDetail(
            type="https://errors.foodshopmeal.ru/domain/validation-error",
            title="Validation Failed",
            status=HTTP_422_STATUS,
            detail=str(exc.errors()),
            trace_id=trace_id,
        )
        return JSONResponse(
            status_code=HTTP_422_STATUS,
            media_type="application/problem+json",
            content=problem.model_dump(by_alias=True, exclude_none=True),
        )

    application.include_router(health_router)
    application.include_router(internal_router)
    return application


app = create_app()
