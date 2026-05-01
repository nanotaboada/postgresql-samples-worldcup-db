-- ============================================================
-- Phase 1 — Enum types
-- ============================================================
-- All four enum types are declared upfront (not just the ones used
-- by Phase 1 tables) per ADR-0003. The vocabularies are stable
-- across editions and tables; defining them here lets later phases
-- reference them without schema migration.
-- ============================================================

CREATE TYPE player_position AS ENUM ('GK', 'DF', 'MF', 'FW');

CREATE TYPE match_stage AS ENUM (
    'GROUP',
    'ROUND_OF_16',
    'QUARTER_FINAL',
    'SEMI_FINAL',
    'THIRD_PLACE',
    'FINAL'
);

CREATE TYPE event_type AS ENUM (
    'GOAL',
    'OWN_GOAL',
    'PENALTY_GOAL',
    'PENALTY_MISS',
    'YELLOW_CARD',
    'SECOND_YELLOW',
    'RED_CARD',
    'SUBSTITUTION'
);

CREATE TYPE official_role AS ENUM (
    'MAIN',
    'ASSISTANT_1',
    'ASSISTANT_2',
    'FOURTH',
    'VAR'
);
