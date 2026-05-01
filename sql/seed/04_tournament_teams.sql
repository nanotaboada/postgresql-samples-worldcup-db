-- =============================================================================
-- Phase 1 — Seed: Qatar 2022 participation (tournament_team)
-- =============================================================================
-- One row per team that played Qatar 2022 (32 rows). Captures the
-- edition-specific attributes that don't belong on the global `team` row:
--   - fifa_ranking: the team's FIFA ranking just before the tournament
--     (October 2022 FIFA/Coca-Cola World Ranking, the last published
--     ranking before kickoff).
--   - final_position: the team's official tournament finish (1 = champion,
--     2 = runner-up, 3 = third, 4 = fourth, 5–8 = quarter-finalists,
--     9–16 = round-of-16 losers, 17–32 = group-stage exits).
--
-- Tournament and team identities are looked up by year and code rather than
-- hard-coded, so the seed survives reordering of upstream files.
--
-- After the INSERT, the deferred `tournament.winner_team_id` from
-- `01_tournament.sql` is backfilled to point at Argentina.
-- =============================================================================

WITH q22 AS (
    SELECT id FROM tournament WHERE year = 2022
)
INSERT INTO tournament_team (tournament_id, team_id, fifa_ranking, final_position)
SELECT
    q22.id,
    tm.id,
    src.fifa_ranking,
    src.final_position
FROM (VALUES
    --  code   rank  pos
    ('ARG',     3,    1),
    ('AUS',    38,   13),
    ('BEL',     2,   21),
    ('BRA',     1,    7),
    ('CMR',    43,   17),
    ('CAN',    41,   31),
    ('CRC',    31,   25),
    ('CRO',    12,    3),
    ('DEN',    10,   28),
    ('ECU',    44,   18),
    ('ENG',     5,    6),
    ('FRA',     4,    2),
    ('GER',    11,   26),
    ('GHA',    61,   22),
    ('IRN',    20,   24),
    ('JPN',    24,    9),
    ('MEX',    13,   20),
    ('MAR',    22,    4),
    ('NED',     8,    5),
    ('POL',    26,   16),
    ('POR',     9,    8),
    ('QAT',    50,   32),
    ('KSA',    51,   23),
    ('SEN',    18,   10),
    ('SRB',    21,   30),
    ('KOR',    28,   14),
    ('ESP',     7,   15),
    ('SUI',    15,   12),
    ('TUN',    30,   19),
    ('USA',    16,   11),
    ('URU',    14,   27),
    ('WAL',    19,   29)
) AS src(team_code, fifa_ranking, final_position)
JOIN team tm ON tm.code = src.team_code
CROSS JOIN q22;


-- Backfill: Argentina won Qatar 2022. Resolves the FK left NULL in
-- `01_tournament.sql` (where `team` rows did not yet exist).
UPDATE tournament
SET winner_team_id = (SELECT id FROM team WHERE code = 'ARG')
WHERE year = 2022;
