CREATE DATABASE IF NOT EXISTS foodshop_analytics;

CREATE TABLE IF NOT EXISTS foodshop_analytics.domain_events
(
    event_id        UUID,
    event_name      LowCardinality(String),
    user_id         UUID, -- pseudonymized UUID only, zero PII per 152-FZ
    degradation_lvl LowCardinality(String),
    experiment_key  LowCardinality(String) DEFAULT '',
    variant         LowCardinality(String) DEFAULT '',
    payload_json    String DEFAULT '{}',
    occurred_at     DateTime64(3, 'UTC') DEFAULT now64(3)
)
ENGINE = MergeTree
PARTITION BY toYYYYMM(occurred_at)
ORDER BY (event_name, occurred_at, user_id);
