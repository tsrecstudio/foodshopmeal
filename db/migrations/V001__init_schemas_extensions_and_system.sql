-- ============================================================================
-- V001__init_schemas_extensions_and_system.sql
-- Stage M0: Extensions (pgcrypto, pgvector), schema boundaries (152-FZ),
--           feature flags (L1/L2/L3 degradation), and isolated PII/consents.
-- ============================================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "vector";

-- Architectural & 152-FZ schema isolation:
-- 1. identity_pii : contacts, delivery addresses, explicit 152-FZ consents, medical stop-list.
--                   Payment card data is NEVER stored anywhere.
-- 2. core         : pure domain model (goals, nutrition graph, recipes, plans, baskets, pantry, diary)
--                   keyed only by pseudonymized user_id (UUID).
-- 3. catalog      : retailers, stores, SKUs, prices, stock, pgvector embeddings, matching links.
-- 4. fulfillment  : Anti-Corruption Layer (ACL) orders, idempotency keys, delivery facts.
CREATE SCHEMA IF NOT EXISTS identity_pii;
CREATE SCHEMA IF NOT EXISTS core;
CREATE SCHEMA IF NOT EXISTS catalog;
CREATE SCHEMA IF NOT EXISTS fulfillment;

-- ----------------------------------------------------------------------------
-- System feature flags (controls L1 -> L2 -> L3 degradation & Kuper rollout)
-- ----------------------------------------------------------------------------
CREATE TABLE core.feature_flags (
    flag_key    TEXT PRIMARY KEY,
    enabled     BOOLEAN     NOT NULL DEFAULT FALSE,
    payload     JSONB       NOT NULL DEFAULT '{}'::jsonb,
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

INSERT INTO core.feature_flags (flag_key, enabled, payload)
VALUES
    ('retailer.local_list.enabled', TRUE,  '{"level": "L1", "description": "Smart shopping list without partner contract"}'),
    ('retailer.kuper.enabled',      FALSE, '{"level": "L3", "reason": "awaiting_partner_credentials"}')
ON CONFLICT (flag_key) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 152-FZ: Isolated identity, explicit health-data consents & medical stop-list
-- ----------------------------------------------------------------------------
CREATE TABLE identity_pii.users (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone_hash              TEXT UNIQUE,
    medical_stoplist_passed BOOLEAN     NOT NULL DEFAULT FALSE, -- FALSE when pregnancy / diabetes / eating_disorders triggered
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE identity_pii.user_consents (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID        NOT NULL REFERENCES identity_pii.users(id) ON DELETE CASCADE,
    consent_type    TEXT        NOT NULL CHECK (
                        consent_type IN (
                            'pdn_general',
                            'pdn_health_152fz',
                            'non_medical_disclaimer'
                        )
                    ),
    policy_version  TEXT        NOT NULL,
    granted_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    revoked_at      TIMESTAMPTZ NULL
);

CREATE INDEX idx_user_consents_user_type
    ON identity_pii.user_consents (user_id, consent_type)
    WHERE revoked_at IS NULL;

CREATE TABLE identity_pii.user_addresses (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID             NOT NULL REFERENCES identity_pii.users(id) ON DELETE CASCADE,
    label           TEXT             NOT NULL DEFAULT 'Дом',
    address_line    TEXT             NOT NULL,
    lat             DOUBLE PRECISION NOT NULL CHECK (lat BETWEEN -90.0 AND 90.0),
    lon             DOUBLE PRECISION NOT NULL CHECK (lon BETWEEN -180.0 AND 180.0),
    is_default      BOOLEAN          NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMPTZ      NOT NULL DEFAULT now()
);

CREATE INDEX idx_user_addresses_user_id
    ON identity_pii.user_addresses (user_id);
