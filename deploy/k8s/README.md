# Kubernetes Deployment Skeleton (RF Cloud / 152-ФЗ)

Базовый контур развёртывания в управляемом Kubernetes-кластере в РФ-юрисдикции
(Yandex Cloud Managed Kubernetes / Selectel / Cloud.ru):

- Все узлы и управляемые БД (`PostgreSQL 16 + pgvector`, `Redis`, `S3`, `ClickHouse`, `Kafka`) размещаются строго в ЦОД на территории РФ (152-ФЗ, ст. 18 ч. 5).
- Схема `identity_pii` использует отдельные учётные данные БД с минимальными правами доступа только из модуля `compliance` / `bff`.
- `core-api` и `solver-svc` настраиваются с `livenessProbe` и `readinessProbe`:
  - `core-api`: `/actuator/health/liveness`, `/actuator/health/readiness`
  - `solver-svc`: `/health/live`, `/health/ready`
