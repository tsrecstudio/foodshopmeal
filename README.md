# foodshopmeal

**North Star:** «Не думать о еде — но полностью её контролировать».  
**Базовый принцип:** Купер — это руки. Мы — мозг.

Система планирования недельного рациона и продуктовой корзины под макросы и бюджет с бесшовной деградацией:
- **L1 (`LocalListAdapter`)** — умный список покупок с ценами и КБЖУ, работает всегда без единого партнёрского договора.
- **L2** — наполнение корзины ритейлера.
- **L3 (`KuperAdapter`, за фича-флагом)** — полный checkout через Fulfillment API Купера и сверка план vs факт доставки.

## Структура монорепо

- `services/core-api/` — модульный монолит Kotlin 2.0 + Spring Boot 3.3 (BFF, Compliance 152-ФЗ, Domain Core, CatalogSource, Anti-Corruption Layer `RetailerAdapter`).
- `services/solver-svc/` — Python 3.11 + FastAPI + OR-Tools CP-SAT + `pgvector` (оптимизатор меню/корзины и пайплайн матчинга SKU).
- `db/migrations/` — версионированные SQL-миграции Flyway (`PostgreSQL 16 + pgvector`) с изоляцией схем `identity_pii`, `core`, `catalog`, `fulfillment`.
- `apps/mobile/` — Flutter-клиент (iOS / Android / Web).
- `apps/admin-matching/` — админка очереди ручной верификации SKU.
- `contracts/openapi/` — спецификации OpenAPI 3.1.
- `deploy/` — инфраструктурные конфиги Docker (OTel, ClickHouse) и скелет K8s для РФ-облака.

## Быстрый старт (Stage M0)

```bash
docker compose up -d --build --wait
```

Проверка готовности и активного уровня деградации (`L1` по умолчанию):

```bash
curl -fsS http://localhost:8080/actuator/health/readiness
curl -fsS http://localhost:8000/health/ready
curl -fsS "http://localhost:8080/api/v1/system/capabilities?lat=55.7558&lon=37.6173"
```

## Статус этапов

- [x] **M0** — Скелет монорепо, `docker-compose.yml`, базовые миграции (152-ФЗ изоляция + `pgvector`), CI, health-checks и L1/L3 capabilities.
- [ ] **M1** — Nutrition Core + Recipes (граф 300 ингредиентов РФ, коэффициенты ужарки/отхода, 50 рецептов).
- [ ] **M2** — Catalog + Matching (`FileFeedSource`, `pgvector` + LLM + очередь разметки).
- [ ] **M3** — Optimizer (`OR-Tools CP-SAT`, меню + корзина под макросы ±7% и бюджет < 5 сек).
- [ ] **M4** — Substitution Engine (светофор замен + дельта КБЖУ).
- [ ] **M5** — Kuper Adapter (ACL, OAuth2, идемпотентность, ревалидация цен, мок).
- [ ] **M6** — Reconciliation + Pantry + Diary (вебхук факта → пересчёт недели → кладовая).
- [ ] **M7** — Flutter-приложение по UX-карте (< 3 минут до первого плана).
- [ ] **M8** — Billing, аналитика, A/B.
