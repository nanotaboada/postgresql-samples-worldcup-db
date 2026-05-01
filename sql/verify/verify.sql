-- =============================================================================
-- Verification — Phase 1 (and onward) data integrity assertions
-- =============================================================================
-- This file is the single source of truth for "is the seeded data correct?"
-- Runs in CI via:
--   psql -v ON_ERROR_STOP=1 -f /repo/sql/verify/verify.sql
--
-- Each phase appends one or more DO blocks with PL/pgSQL ASSERT statements
-- (per ADR-0005). The first failed assertion aborts the script with a
-- non-zero exit code, failing the workflow.
--
-- Schema-level CHECK constraints already enforce structural invariants like
-- `won + drawn + lost = played`, `goal_difference = goals_for - goals_against`,
-- and `position BETWEEN 1 AND 4`. ASSERTs below cover what the schema can't:
-- counts, cross-data consistency, and named-row presence.
-- =============================================================================


-- -----------------------------------------------------------------------------
-- Phase 1 — Tournament Structure
-- -----------------------------------------------------------------------------

DO $$
DECLARE
    qatar2022_id smallint;
    arg_team_id  smallint;
    qualifier_mismatch integer;
BEGIN
    -- Resolve key identities once.
    SELECT id INTO qatar2022_id FROM tournament WHERE year = 2022;
    SELECT id INTO arg_team_id  FROM team       WHERE code = 'ARG';

    ASSERT qatar2022_id IS NOT NULL,
        'expected a tournament row for year 2022';
    ASSERT arg_team_id IS NOT NULL,
        'expected a team row for code ARG (Argentina)';

    -- ------------------------------------------------------------
    -- Counts
    -- ------------------------------------------------------------
    ASSERT (SELECT count(*) FROM tournament) = 1,
        'expected exactly 1 tournament row (v1 seeds Qatar 2022 only)';
    ASSERT (SELECT count(*) FROM confederation) = 6,
        'expected 6 confederations';
    ASSERT (SELECT count(*) FROM team) = 32,
        'expected 32 teams (national identity, global)';
    ASSERT (SELECT count(*) FROM tournament_team
             WHERE tournament_id = qatar2022_id) = 32,
        'expected 32 tournament_team rows for Qatar 2022';
    ASSERT (SELECT count(*) FROM tournament_group
             WHERE tournament_id = qatar2022_id) = 8,
        'expected 8 tournament_group rows for Qatar 2022 (letters A-H)';
    ASSERT (SELECT count(*) FROM group_standing
             WHERE tournament_id = qatar2022_id) = 32,
        'expected 32 group_standing rows for Qatar 2022 (4 teams x 8 groups)';
    ASSERT (SELECT count(*) FROM stadium) = 8,
        'expected 8 stadiums (Qatar 2022 venues)';

    -- ------------------------------------------------------------
    -- Domain integrity
    -- ------------------------------------------------------------
    ASSERT (SELECT winner_team_id FROM tournament WHERE year = 2022) = arg_team_id,
        'expected tournament.winner_team_id for Qatar 2022 to resolve to Argentina';

    -- Stronger than `count(DISTINCT letter) = 8` because it asserts the
    -- actual set, not just the cardinality. Covered by schema CHECK +
    -- UNIQUE constraints in practice; this is defence-in-depth.
    ASSERT NOT EXISTS (
        SELECT 1
        FROM tournament_group
        WHERE tournament_id = qatar2022_id
          AND letter NOT IN ('A','B','C','D','E','F','G','H')
    ),
        'every Qatar 2022 group letter must be one of A-H';

    ASSERT (
        SELECT count(*)
        FROM tournament_group
        WHERE tournament_id = qatar2022_id
    ) = 8,
        'expected exactly 8 group rows for Qatar 2022';

    ASSERT NOT EXISTS (
        SELECT group_id
        FROM group_standing
        WHERE tournament_id = qatar2022_id
        GROUP BY group_id
        HAVING count(*) <> 4
    ),
        'every Qatar 2022 group must have exactly 4 standings rows';

    ASSERT NOT EXISTS (
        SELECT group_id
        FROM group_standing
        WHERE tournament_id = qatar2022_id
        GROUP BY group_id
        HAVING count(DISTINCT position) <> 4
    ),
        'positions 1-4 must each appear exactly once per Qatar 2022 group';

    -- Exactly one tournament_team row should match Argentina-as-champion.
    -- Combines two checks (single champion row + correct team) into one
    -- assertion so an extra row at final_position=1 fails with a clear
    -- message rather than triggering a scalar-subquery overflow error.
    ASSERT (
        SELECT count(*)
        FROM tournament_team
        WHERE tournament_id = qatar2022_id
          AND final_position = 1
          AND team_id = arg_team_id
    ) = 1,
        'expected exactly one Qatar 2022 champion row, and it must be Argentina';

    -- ------------------------------------------------------------
    -- Cross-data consistency
    -- ------------------------------------------------------------
    -- The 16 teams who finished 1st or 2nd in their group should be the
    -- same 16 teams whose tournament_team.final_position is <= 16
    -- (i.e., R16 qualifiers).
    SELECT count(*)
    INTO qualifier_mismatch
    FROM (
        SELECT t.code
        FROM group_standing gs
        JOIN team t ON t.id = gs.team_id
        WHERE gs.tournament_id = qatar2022_id AND gs.position <= 2
    ) AS group_qualifiers
    WHERE NOT EXISTS (
        SELECT 1
        FROM tournament_team tt
        JOIN team t2 ON t2.id = tt.team_id
        WHERE tt.tournament_id = qatar2022_id
          AND tt.final_position <= 16
          AND t2.code = group_qualifiers.code
    );
    ASSERT qualifier_mismatch = 0,
        'group qualifiers (pos<=2) must match R16 qualifiers (final_position<=16)';

    RAISE NOTICE 'verify: Phase 1 — all assertions passed';
END $$;
