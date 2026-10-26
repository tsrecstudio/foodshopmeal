-- ============================================================================
-- V002__nutrition_core_and_recipes.sql
-- Stage M1: Canonical Ingredient Graph & Recipes schema.
-- Invariant: Recipe table NEVER stores precalculated KBZHU; nutrients are
--            always derived deterministically from core.ingredients.
-- ============================================================================

CREATE TABLE core.ingredients (
    id                  UUID PRIMARY KEY,
    name                TEXT           NOT NULL UNIQUE,
    synonyms            TEXT[]         NOT NULL DEFAULT '{}',
    category            TEXT           NOT NULL,
    kcal_per_100g       NUMERIC(7, 2)  NOT NULL CHECK (kcal_per_100g >= 0 AND kcal_per_100g <= 950),
    protein_per_100g    NUMERIC(6, 2)  NOT NULL CHECK (protein_per_100g >= 0),
    fat_per_100g        NUMERIC(6, 2)  NOT NULL CHECK (fat_per_100g >= 0),
    carb_per_100g       NUMERIC(6, 2)  NOT NULL CHECK (carb_per_100g >= 0),
    fiber_per_100g      NUMERIC(6, 2)  NOT NULL DEFAULT 0 CHECK (fiber_per_100g >= 0),
    density_g_per_ml    NUMERIC(6, 3)  NULL CHECK (density_g_per_ml > 0),
    yield_factor_cooked NUMERIC(6, 4)  NOT NULL DEFAULT 1.0000 CHECK (yield_factor_cooked > 0),
    waste_factor        NUMERIC(5, 4)  NOT NULL DEFAULT 0.0000 CHECK (waste_factor >= 0 AND waste_factor < 1),
    allergens           TEXT[]         NOT NULL DEFAULT '{}',
    tags                TEXT[]         NOT NULL DEFAULT '{}',
    created_at          TIMESTAMPTZ    NOT NULL DEFAULT now(),
    CHECK (protein_per_100g + fat_per_100g + carb_per_100g + fiber_per_100g <= 101.0)
);

CREATE INDEX idx_ingredients_category ON core.ingredients (category);
CREATE INDEX idx_ingredients_allergens_gin ON core.ingredients USING GIN (allergens);
CREATE INDEX idx_ingredients_tags_gin ON core.ingredients USING GIN (tags);

CREATE TABLE core.recipes (
    id          UUID PRIMARY KEY,
    title       TEXT        NOT NULL UNIQUE,
    steps       JSONB       NOT NULL,
    time_min    INT         NOT NULL CHECK (time_min > 0),
    equipment   TEXT[]      NOT NULL DEFAULT '{}',
    servings    INT         NOT NULL CHECK (servings > 0),
    tags        TEXT[]      NOT NULL DEFAULT '{}',
    difficulty  TEXT        NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard')),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (jsonb_typeof(steps) = 'array' AND jsonb_array_length(steps) > 0)
);

CREATE INDEX idx_recipes_tags_gin ON core.recipes USING GIN (tags);
CREATE INDEX idx_recipes_time_min ON core.recipes (time_min);

CREATE TABLE core.recipe_ingredients (
    recipe_id           UUID          NOT NULL REFERENCES core.recipes(id) ON DELETE CASCADE,
    ingredient_id       UUID          NOT NULL REFERENCES core.ingredients(id) ON DELETE RESTRICT,
    grams_raw           NUMERIC(8, 2) NOT NULL CHECK (grams_raw > 0),
    optional            BOOLEAN       NOT NULL DEFAULT FALSE,
    substitution_group  TEXT          NULL,
    PRIMARY KEY (recipe_id, ingredient_id)
);

CREATE INDEX idx_recipe_ingredients_ingredient ON core.recipe_ingredients (ingredient_id);
