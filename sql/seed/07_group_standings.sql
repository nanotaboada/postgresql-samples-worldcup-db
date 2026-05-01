-- =============================================================================
-- Phase 1 — Seed: group_standing (Qatar 2022 final group-stage tables)
-- =============================================================================
-- Final group-stage standings for all 32 teams (4 per group × 8 groups).
-- Sourced from FIFA Qatar 2022 official records.
--
-- Tournament, group, and team identities are all looked up by code/letter
-- rather than hard-coded ids — the seed is robust against insertion-order
-- changes upstream.
--
-- Schema CHECK constraints enforce three invariants per row:
--   - won + drawn + lost = played
--   - goal_difference   = goals_for - goals_against
--   - position BETWEEN 1 AND 4
-- All 32 rows below satisfy them.
-- =============================================================================

WITH q22 AS (SELECT id FROM tournament WHERE year = 2022)
INSERT INTO group_standing (
    tournament_id, group_id, team_id,
    played, won, drawn, lost,
    goals_for, goals_against, goal_difference,
    points, position
)
SELECT
    q22.id,
    g.id,
    t.id,
    src.played, src.won, src.drawn, src.lost,
    src.goals_for, src.goals_against, src.goal_difference,
    src.points, src.position
FROM (VALUES
    --   grp  team    pld  w  d  l   gf ga  gd  pts pos
    -- Group A
    ('A', 'NED',     3, 2, 1, 0,  5,  1,  4,  7, 1),
    ('A', 'SEN',     3, 2, 0, 1,  5,  3,  2,  6, 2),
    ('A', 'ECU',     3, 1, 1, 1,  4,  3,  1,  4, 3),
    ('A', 'QAT',     3, 0, 0, 3,  1,  7, -6,  0, 4),

    -- Group B
    ('B', 'ENG',     3, 2, 1, 0,  9,  2,  7,  7, 1),
    ('B', 'USA',     3, 1, 2, 0,  2,  1,  1,  5, 2),
    ('B', 'IRN',     3, 1, 0, 2,  4,  7, -3,  3, 3),
    ('B', 'WAL',     3, 0, 1, 2,  1,  6, -5,  1, 4),

    -- Group C
    ('C', 'ARG',     3, 2, 0, 1,  5,  2,  3,  6, 1),
    ('C', 'POL',     3, 1, 1, 1,  2,  2,  0,  4, 2),
    ('C', 'MEX',     3, 1, 1, 1,  2,  3, -1,  4, 3),
    ('C', 'KSA',     3, 1, 0, 2,  3,  5, -2,  3, 4),

    -- Group D
    ('D', 'FRA',     3, 2, 0, 1,  6,  3,  3,  6, 1),
    ('D', 'AUS',     3, 2, 0, 1,  3,  4, -1,  6, 2),
    ('D', 'TUN',     3, 1, 1, 1,  1,  1,  0,  4, 3),
    ('D', 'DEN',     3, 0, 1, 2,  1,  3, -2,  1, 4),

    -- Group E
    ('E', 'JPN',     3, 2, 0, 1,  4,  3,  1,  6, 1),
    ('E', 'ESP',     3, 1, 1, 1,  9,  3,  6,  4, 2),
    ('E', 'GER',     3, 1, 1, 1,  6,  5,  1,  4, 3),
    ('E', 'CRC',     3, 1, 0, 2,  3, 11, -8,  3, 4),

    -- Group F
    ('F', 'MAR',     3, 2, 1, 0,  4,  1,  3,  7, 1),
    ('F', 'CRO',     3, 1, 2, 0,  4,  1,  3,  5, 2),
    ('F', 'BEL',     3, 1, 1, 1,  1,  2, -1,  4, 3),
    ('F', 'CAN',     3, 0, 0, 3,  2,  7, -5,  0, 4),

    -- Group G
    ('G', 'BRA',     3, 2, 0, 1,  3,  1,  2,  6, 1),
    ('G', 'SUI',     3, 2, 0, 1,  4,  3,  1,  6, 2),
    ('G', 'CMR',     3, 1, 1, 1,  4,  4,  0,  4, 3),
    ('G', 'SRB',     3, 0, 1, 2,  5,  8, -3,  1, 4),

    -- Group H
    ('H', 'POR',     3, 2, 0, 1,  6,  4,  2,  6, 1),
    ('H', 'KOR',     3, 1, 1, 1,  4,  4,  0,  4, 2),
    ('H', 'URU',     3, 1, 1, 1,  2,  2,  0,  4, 3),
    ('H', 'GHA',     3, 1, 0, 2,  5,  7, -2,  3, 4)
) AS src(
    group_letter, team_code,
    played, won, drawn, lost,
    goals_for, goals_against, goal_difference,
    points, position
)
CROSS JOIN q22
JOIN tournament_group g ON g.tournament_id = q22.id AND g.letter = src.group_letter
JOIN team t ON t.code = src.team_code;
