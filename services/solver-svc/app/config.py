from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    service_name: str = "solver-svc"
    environment: str = "local"
    database_url: str = "postgresql://foodshop:foodshop_dev_pwd@localhost:5432/foodshop"
    check_db_on_readiness: bool = False
    otlp_endpoint: str | None = None

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )


def get_settings() -> Settings:
    return Settings()
