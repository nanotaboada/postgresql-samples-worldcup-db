-- =============================================================================
-- Phase 1 — Seed: National teams (global identity)
-- =============================================================================
-- The 32 teams that participated in the FIFA World Cup Qatar 2022. `team` is
-- a global table (no `tournament_id`); per-tournament participation
-- attributes (FIFA ranking, group, final position) live in `tournament_team`
-- and are seeded in sub-ticket 1.4.
--
-- Codes are FIFA's official 3-letter abbreviations. Confederations are
-- looked up by code rather than hard-coded id, so this seed is robust
-- against changes in confederation insertion order.
--
-- Teams are listed alphabetically by name.
-- =============================================================================

INSERT INTO team (code, name, confederation_id)
SELECT
    src.code,
    src.name,
    c.id
FROM (VALUES
    ('ARG', 'Argentina',     'CONMEBOL'),
    ('AUS', 'Australia',     'AFC'),
    ('BEL', 'Belgium',       'UEFA'),
    ('BRA', 'Brazil',         'CONMEBOL'),
    ('CMR', 'Cameroon',       'CAF'),
    ('CAN', 'Canada',         'CONCACAF'),
    ('CRC', 'Costa Rica',     'CONCACAF'),
    ('CRO', 'Croatia',        'UEFA'),
    ('DEN', 'Denmark',        'UEFA'),
    ('ECU', 'Ecuador',        'CONMEBOL'),
    ('ENG', 'England',        'UEFA'),
    ('FRA', 'France',         'UEFA'),
    ('GER', 'Germany',        'UEFA'),
    ('GHA', 'Ghana',          'CAF'),
    ('IRN', 'Iran',           'AFC'),
    ('JPN', 'Japan',          'AFC'),
    ('MEX', 'Mexico',         'CONCACAF'),
    ('MAR', 'Morocco',        'CAF'),
    ('NED', 'Netherlands',    'UEFA'),
    ('POL', 'Poland',         'UEFA'),
    ('POR', 'Portugal',       'UEFA'),
    ('QAT', 'Qatar',          'AFC'),
    ('KSA', 'Saudi Arabia',   'AFC'),
    ('SEN', 'Senegal',        'CAF'),
    ('SRB', 'Serbia',         'UEFA'),
    ('KOR', 'South Korea',    'AFC'),
    ('ESP', 'Spain',          'UEFA'),
    ('SUI', 'Switzerland',    'UEFA'),
    ('TUN', 'Tunisia',        'CAF'),
    ('USA', 'United States',  'CONCACAF'),
    ('URU', 'Uruguay',        'CONMEBOL'),
    ('WAL', 'Wales',          'UEFA')
) AS src(code, name, confed_code)
JOIN confederation c ON c.code = src.confed_code;
