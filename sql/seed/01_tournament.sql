-- =============================================================================
-- Phase 1 — Seed: FIFA World Cup Qatar 2022 (tournament root)
-- =============================================================================
-- Single row representing the Qatar 2022 edition. v1 of this database seeds
-- only Qatar 2022; future editions will append more rows here.
--
-- `winner_team_id` is left NULL on insert because the `team` rows it
-- references are seeded in a later sub-ticket (1.3). The reference is
-- backfilled in `04_tournament_teams.sql` once both `team` and
-- `tournament_team` are populated.
-- =============================================================================

INSERT INTO tournament (
    year,
    host_country,
    edition_name,
    start_date,
    end_date
) VALUES (
    2022,
    'Qatar',
    'FIFA World Cup Qatar 2022',
    '2022-11-20',
    '2022-12-18'
);
