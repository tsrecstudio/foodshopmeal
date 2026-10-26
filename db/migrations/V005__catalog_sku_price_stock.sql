-- ============================================================================
-- V005__catalog_sku_price_stock.sql
-- Stage M2: Catalog model, SKU matching tables.
-- Anti-corruption: catalog data lives in `catalog` schema, isolated from core domain.
-- ============================================================================

CREATE TABLE catalog.retailers (
    id          UUID PRIMARY KEY,
    name        TEXT        NOT NULL UNIQUE,
    type        TEXT        NOT NULL CHECK (type IN ('pharmacy','grocery','market','online')),
    external_id TEXT        NOT NULL UNIQUE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE catalog.stores (
    id         UUID PRIMARY KEY,
    retailer_id UUID       NOT NULL REFERENCES catalog.retailers(id) ON DELETE CASCADE,
    external_id TEXT       NOT NULL UNIQUE,
    geo         TEXT       NOT NULL, -- e.g. "RU-MOW"
    address     TEXT       NOT NULL,
    latitude    NUMERIC(9, 6),
    longitude   NUMERIC(9, 6),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_stores_retailer ON catalog.stores (retailer_id);
CREATE INDEX idx_stores_geo ON catalog.stores (geo);

CREATE TABLE catalog.skus (
    id          UUID PRIMARY KEY,
    retailer_id UUID       NOT NULL REFERENCES catalog.retailers(id) ON DELETE CASCADE,
    external_id TEXT       NOT NULL,
    name        TEXT       NOT NULL,
    brand       TEXT,
    gtin        TEXT,
    pack_size   NUMERIC(8, 2),
    unit        TEXT       NOT NULL, -- 'g', 'ml', 'pcs', 'kg', ...
    category    TEXT       NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (retailer_id, external_id)
);
CREATE INDEX idx_skus_retailer ON catalog.skus (retailer_id);
CREATE INDEX idx_skus_category ON catalog.skus (category);

-- SKU-to-ingredient links (matching pipeline output)
CREATE TABLE catalog.sku_ingredient_links (
    sku_id           UUID          NOT NULL REFERENCES catalog.skus(id) ON DELETE CASCADE,
    ingredient_id    UUID          NOT NULL REFERENCES core.ingredients(id) ON DELETE RESTRICT,
    net_weight_g     NUMERIC(8, 2) NOT NULL CHECK (net_weight_g > 0),
    confidence       NUMERIC(5, 4) NOT NULL CHECK (confidence >= 0 AND confidence <= 1),
    verified_by      TEXT          NOT NULL DEFAULT 'auto', -- 'auto' | 'manual' | 'admin'
    created_at       TIMESTAMPTZ   NOT NULL DEFAULT now(),
    updated_at       TIMESTAMPTZ   NOT NULL DEFAULT now(),
    PRIMARY KEY (sku_id, ingredient_id)
);
CREATE INDEX idx_sku_links_ingredient ON catalog.sku_ingredient_links (ingredient_id);
CREATE INDEX idx_sku_links_confidence ON catalog.sku_ingredient_links (confidence);

-- Prices per store
CREATE TABLE catalog.prices (
    sku_id     UUID          NOT NULL REFERENCES catalog.skus(id) ON DELETE CASCADE,
    store_id   UUID          NOT NULL REFERENCES catalog.stores(id) ON DELETE CASCADE,
    value      NUMERIC(12, 2) NOT NULL CHECK (value >= 0),
    valid_from TIMESTAMPTZ   NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ   NOT NULL DEFAULT now(),
    PRIMARY KEY (sku_id, store_id)
);
CREATE INDEX idx_prices_store ON catalog.prices (store_id);

-- Stock per store
CREATE TABLE catalog.stock (
    sku_id     UUID         NOT NULL REFERENCES catalog.skus(id) ON DELETE CASCADE,
    store_id   UUID         NOT NULL REFERENCES catalog.stores(id) ON DELETE CASCADE,
    available  BOOLEAN      NOT NULL DEFAULT TRUE,
    updated_at TIMESTAMPTZ  NOT NULL DEFAULT now(),
    PRIMARY KEY (sku_id, store_id)
);
CREATE INDEX idx_stock_store ON catalog.stock (store_id);

-- Matching review queue (low-confidence auto-accepts go here)
CREATE TABLE catalog.match_review_queue (
    id               UUID PRIMARY KEY,
    sku_id           UUID          NOT NULL REFERENCES catalog.skus(id) ON DELETE CASCADE,
    ingredient_id    UUID          NOT NULL REFERENCES core.ingredients(id) ON DELETE RESTRICT,
    net_weight_g     NUMERIC(8, 2),
    confidence       NUMERIC(5, 4) NOT NULL,
    status           TEXT          NOT NULL DEFAULT 'pending', -- 'pending' | 'approved' | 'rejected'
    reviewer_id      UUID,
    created_at       TIMESTAMPTZ   NOT NULL DEFAULT now(),
    resolved_at      TIMESTAMPTZ
);
CREATE INDEX idx_review_status ON catalog.match_review_queue (status);
