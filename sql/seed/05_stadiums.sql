-- =============================================================================
-- Phase 1 — Seed: stadiums (8 Qatar 2022 venues)
-- =============================================================================
-- All eight venues used during FIFA World Cup Qatar 2022. `stadium` is a
-- global table (no `tournament_id`) — venues exist independently of which
-- editions use them, so future tournaments can reference these rows or add
-- new ones without re-seeding.
--
-- Stadiums are listed alphabetically by name. Each row is split across two
-- lines because the description column would otherwise push a single line
-- past the 100-column code budget.
-- =============================================================================

INSERT INTO stadium (name, city, country, capacity, opened_year, description)
VALUES
    ('Ahmad bin Ali Stadium', 'Al Rayyan', 'Qatar', 44740, 2020,
     'Sand-dune-patterned facade evoking traditional Qatari architecture.'),

    ('Al Bayt Stadium', 'Al Khor', 'Qatar', 68895, 2021,
     'Bedouin-tent design; hosted the Qatar 2022 opening match.'),

    ('Al Janoub Stadium', 'Al Wakrah', 'Qatar', 44325, 2019,
     'Curved sail-like roof recalling Qatari dhow boats.'),

    ('Al Thumama Stadium', 'Doha', 'Qatar', 44400, 2021,
     'Round form inspired by the gahfiya, a traditional Arab cap.'),

    ('Education City Stadium', 'Al Rayyan', 'Qatar', 44667, 2020,
     'Diamond-pattern facade; sits within the Education City complex.'),

    ('Khalifa International Stadium', 'Al Rayyan', 'Qatar', 45857, 1976,
     'Oldest Qatar 2022 venue; renovated for the tournament; hosted the third-place playoff.'),

    ('Lusail Stadium', 'Lusail', 'Qatar', 88966, 2022,
     'Largest venue of Qatar 2022; hosted the World Cup final.'),

    ('Stadium 974', 'Doha', 'Qatar', 44089, 2021,
     'Built from 974 reused shipping containers; named after Qatar''s +974 dialing code.');
