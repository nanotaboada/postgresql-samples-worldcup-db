-- =============================================================================
-- Phase 1 — Indexes (beyond PKs and UNIQUE constraints)
-- =============================================================================
-- Per-tournament tables that don't have `tournament_id` as the
-- leading column of a UNIQUE constraint get an explicit index, so
-- `WHERE tournament_id = ?` filtering stays cheap as edition count
-- grows.
--
-- For Phase 1 only `group_standing` qualifies — its UNIQUE is
-- `(group_id, team_id)`, which doesn't lead with tournament_id.
-- `tournament_team` and `tournament_group` have composite UNIQUEs
-- starting with tournament_id, so the underlying index already
-- serves the filter.
-- =============================================================================

CREATE INDEX idx_group_standing_tournament ON group_standing(tournament_id);
