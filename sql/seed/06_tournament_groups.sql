-- =============================================================================
-- Phase 1 — Seed: tournament groups A–H (Qatar 2022)
-- =============================================================================
-- The eight group-stage groups for FIFA World Cup Qatar 2022. Future
-- editions will append more rows scoped by `tournament_id`.
-- =============================================================================

WITH q22 AS (SELECT id FROM tournament WHERE year = 2022)
INSERT INTO tournament_group (tournament_id, letter)
SELECT q22.id, ltr.letter
FROM (VALUES ('A'),('B'),('C'),('D'),('E'),('F'),('G'),('H')) AS ltr(letter)
CROSS JOIN q22;
