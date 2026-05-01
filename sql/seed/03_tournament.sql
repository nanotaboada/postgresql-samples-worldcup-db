-- =============================================================================
-- Phase 1 — Seed: FIFA World Cup Qatar 2022 (tournament root)
-- =============================================================================
-- Single row representing the Qatar 2022 edition. v1 of this database seeds
-- only Qatar 2022; future editions will append more rows here.
--
-- This file loads after `02_teams.sql`, so the Argentina row already exists
-- and `winner_team_id` is resolved inline by lookup. No deferred backfill is
-- required (which keeps `sql/seed/` strictly INSERT-only per CONTRIBUTING.md).
-- =============================================================================

INSERT INTO tournament (
    year,
    host_country,
    edition_name,
    start_date,
    end_date,
    winner_team_id
) VALUES (
    2022,
    'Qatar',
    'FIFA World Cup Qatar 2022',
    '2022-11-20',
    '2022-12-18',
    (SELECT id FROM team WHERE code = 'ARG')
);
