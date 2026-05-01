-- =============================================================================
-- Phase 1 — Seed: FIFA confederations
-- =============================================================================
-- Six FIFA continental confederations. Inserted alphabetically by code so the
-- generated identities are predictable: AFC=1, CAF=2, CONCACAF=3, CONMEBOL=4,
-- OFC=5, UEFA=6.
-- =============================================================================

INSERT INTO confederation (code, name) VALUES
    ('AFC',      'Asian Football Confederation'),
    ('CAF',      'Confederation of African Football'),
    ('CONCACAF', 'Confederation of North, Central America and Caribbean Association Football'),
    ('CONMEBOL', 'South American Football Confederation'),
    ('OFC',      'Oceania Football Confederation'),
    ('UEFA',     'Union of European Football Associations');
