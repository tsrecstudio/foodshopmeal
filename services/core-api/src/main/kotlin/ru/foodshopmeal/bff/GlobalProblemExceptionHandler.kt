package ru.foodshopmeal.bff

import jakarta.validation.ConstraintViolationException
import org.springframework.core.Ordered
import org.springframework.core.annotation.Order
import org.springframework.http.HttpStatus
import org.springframework.http.ProblemDetail
import org.springframework.web.bind.MethodArgumentNotValidException
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.bind.annotation.RestControllerAdvice
import org.springframework.web.method.annotation.HandlerMethodValidationException
import ru.foodshopmeal.compliance.MedicalStopListException
import java.net.URI
import java.util.UUID

@Order(Ordered.HIGHEST_PRECEDENCE)
@RestControllerAdvice
class GlobalProblemExceptionHandler {
    @ExceptionHandler(MedicalStopListException::class)
    fun handleMedicalStopList(ex: MedicalStopListException): ProblemDetail =
        ProblemDetail.forStatusAndDetail(HttpStatus.UNPROCESSABLE_ENTITY, ex.message ?: "Medical stop-list triggered")
            .apply {
                type = URI.create("https://errors.foodshopmeal.ru/domain/medical-stoplist")
                title = "Medical Stop-List Triggered"
                setProperty("traceId", newTraceId())
            }

    @ExceptionHandler(
        ConstraintViolationException::class,
        HandlerMethodValidationException::class,
        MethodArgumentNotValidException::class,
    )
    fun handleValidationErrors(ex: Exception): ProblemDetail =
        ProblemDetail.forStatusAndDetail(HttpStatus.UNPROCESSABLE_ENTITY, ex.message ?: "Validation failed")
            .apply {
                type = URI.create("https://errors.foodshopmeal.ru/domain/validation-error")
                title = "Validation Failed"
                setProperty("traceId", newTraceId())
            }

    private fun newTraceId(): String = UUID.randomUUID().toString().replace("-", "")
}
