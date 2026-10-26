-- ============================================================================
-- V006__orders_delivery_pantry_diary.sql
-- Stage M6: Orders, Delivery Facts, Pantry, Diary.
-- Anti-corruption: fulfillment schema isolated from core domain.
-- ============================================================================

CREATE TABLE fulfillment.orders (
    id                UUID PRIMARY KEY,
    user_id           UUID          NOT NULL REFERENCES identity_pii.users(id) ON DELETE CASCADE,
    external_order_id TEXT          NOT NULL,
    state             TEXT          NOT NULL CHECK (state IN ('created','accepted','in_progress','delivered','cancelled','failed')),
    slot              TEXT,
    total_rub         NUMERIC(12, 2) NOT NULL CHECK (total_rub >= 0),
    idempotency_key   TEXT          NOT NULL UNIQUE,
    created_at        TIMESTAMPTZ   NOT NULL DEFAULT now(),
    updated_at        TIMESTAMPTZ   NOT NULL DEFAULT now(),
    UNIQUE (user_id, external_order_id)
);
CREATE INDEX idx_orders_user ON fulfillment.orders (user_id);
CREATE INDEX idx_orders_state ON fulfillment.orders (state);

CREATE TABLE fulfillment.delivery_facts (
    order_id         UUID         NOT NULL REFERENCES fulfillment.orders(id) ON DELETE CASCADE,
    sku_id           UUID         NOT NULL REFERENCES catalog.skus(id) ON DELETE RESTRICT,
    actual_sku_id    UUID,
    actual_weight_g  NUMERIC(8, 2),
    confirmed_at     TIMESTAMPTZ  NOT NULL DEFAULT now(),
    PRIMARY KEY (order_id, sku_id)
);
CREATE INDEX idx_delivery_order ON fulfillment.delivery_facts (order_id);

CREATE TABLE fulfillment.webhook_events (
    id               UUID PRIMARY KEY,
    order_id         UUID         NOT NULL REFERENCES fulfillment.orders(id) ON DELETE CASCADE,
    payload          JSONB        NOT NULL,
    processed        BOOLEAN      NOT NULL DEFAULT FALSE,
    received_at      TIMESTAMPTZ  NOT NULL DEFAULT now(),
    processed_at     TIMESTAMPTZ
);
CREATE INDEX idx_webhook_order ON fulfillment.webhook_events (order_id);
CREATE INDEX idx_webhook_processed ON fulfillment.webhook_events (processed);

CREATE TABLE core.pantry_items (
    id            UUID PRIMARY KEY,
    user_id       UUID         NOT NULL REFERENCES identity_pii.users(id) ON DELETE CASCADE,
    ingredient_id UUID         NOT NULL REFERENCES core.ingredients(id) ON DELETE RESTRICT,
    grams         NUMERIC(8, 2) NOT NULL CHECK (grams >= 0),
    expires_at    TIMESTAMPTZ,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT now(),
    UNIQUE (user_id, ingredient_id)
);
CREATE INDEX idx_pantry_user ON core.pantry_items (user_id);

CREATE TABLE core.diary_entries (
    id            UUID PRIMARY KEY,
    user_id       UUID         NOT NULL REFERENCES identity_pii.users(id) ON DELETE CASCADE,
    date          DATE         NOT NULL,
    meal          TEXT         NOT NULL CHECK (meal IN ('breakfast','lunch','dinner','snack')),
    source        TEXT         NOT NULL CHECK (source IN ('plan','manual')),
    kcal          NUMERIC(7, 2) NOT NULL CHECK (kcal >= 0),
    protein       NUMERIC(6, 2) NOT NULL CHECK (protein >= 0),
    fat           NUMERIC(6, 2) NOT NULL CHECK (fat >= 0),
    carb          NUMERIC(6, 2) NOT NULL CHECK (carb >= 0),
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT now(),
    UNIQUE (user_id, date, meal, source)
);
CREATE INDEX idx_diary_user_date ON core.diary_entries (user_id, date);

-- Reconciliation summary per week
CREATE TABLE core.reconciliation_summaries (
    id            UUID PRIMARY KEY,
    user_id       UUID         NOT NULL REFERENCES identity_pii.users(id) ON DELETE CASCADE,
    week_start    DATE         NOT NULL,
    planned_kcal  NUMERIC(7, 2),
    actual_kcal   NUMERIC(7, 2),
    planned_protein NUMERIC(6, 2),
    actual_protein NUMERIC(6, 2),
    deviation_pct NUMERIC(5, 2),
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT now(),
    UNIQUE (user_id, week_start)
);
CREATE INDEX idx_recon_user_week ON core.reconciliation_summaries (user_id, week_start);
