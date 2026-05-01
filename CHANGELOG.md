# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Release Naming Convention 🏆

This project uses **FIFA World Cup editions** as release codenames, advancing chronologically through World Cup history. The codename advances on each release independently of the SemVer bump (a patch and a major may both consume one codename).

The sibling API repositories use an A-Z football-coaches theme; this database project departs from that convention because its organising principle is *time* (the historical sequence of tournaments) rather than alphabet.

| #  | Year | Host(s)                        | Tag Name                      |
|----|------|--------------------------------|-------------------------------|
| 1  | 1930 | Uruguay                        | `uruguay-1930`                |
| 2  | 1934 | Italy                          | `italy-1934`                  |
| 3  | 1938 | France                         | `france-1938`                 |
| 4  | 1950 | Brazil                         | `brazil-1950`                 |
| 5  | 1954 | Switzerland                    | `switzerland-1954`            |
| 6  | 1958 | Sweden                         | `sweden-1958`                 |
| 7  | 1962 | Chile                          | `chile-1962`                  |
| 8  | 1966 | England                        | `england-1966`                |
| 9  | 1970 | Mexico                         | `mexico-1970`                 |
| 10 | 1974 | West Germany                   | `west-germany-1974`           |
| 11 | 1978 | Argentina                      | `argentina-1978`              |
| 12 | 1982 | Spain                          | `spain-1982`                  |
| 13 | 1986 | Mexico                         | `mexico-1986`                 |
| 14 | 1990 | Italy                          | `italy-1990`                  |
| 15 | 1994 | United States                  | `usa-1994`                    |
| 16 | 1998 | France                         | `france-1998`                 |
| 17 | 2002 | South Korea & Japan            | `south-korea-japan-2002`      |
| 18 | 2006 | Germany                        | `germany-2006`                |
| 19 | 2010 | South Africa                   | `south-africa-2010`           |
| 20 | 2014 | Brazil                         | `brazil-2014`                 |
| 21 | 2018 | Russia                         | `russia-2018`                 |
| 22 | 2022 | Qatar                          | `qatar-2022`                  |
| 23 | 2026 | Canada, Mexico & United States | `canada-mexico-usa-2026`      |
| 24 | 2030 | Spain, Portugal & Morocco      | `spain-portugal-morocco-2030` |
| 25 | 2034 | Saudi Arabia                   | `saudi-arabia-2034`           |

> The 2030 edition marks the World Cup centennial. Three opening matches will be played in Argentina, Paraguay, and Uruguay — the inaugural 1930 hosts and finalists.

---

## [Unreleased]

### Added

- Initial repository scaffolding: `compose.yaml` (Postgres 17 with
  healthcheck), `compose.tools.yaml` override (Adminer), `.env.example`,
  `.gitignore`, dual licensing (`LICENSE` MIT for code, `DATA_LICENSE`
  CC BY-NC-SA 4.0 for seed data), `DATA_SOURCES.md` skeleton, and
  directory layout (`sql/{schema,seed,verify}/`, `scripts/`,
  `queries/`, `docs/`).
- `docs/ERD.md` with the full multi-edition Mermaid entity-relationship
  diagram. Splits tables into global (no `tournament_id`) and
  tournament-scoped (denormalized `tournament_id`).
- GitHub issue templates: `feature_request.md`, `bug_report.md`, and
  `config.yml` (blank issues disabled).
- Architecture Decision Records — initial set in `docs/adr/`:
  - ADR-0001: Multi-Edition Data Model
  - ADR-0002: Dual Licensing — MIT for Code, CC BY-NC-SA 4.0 for Data
  - ADR-0003: Native PostgreSQL ENUM Types over CHECK Constraints
  - ADR-0004: Compose Spec Override Pattern for Optional Services
  - ADR-0005: Schema Verification via In-Line `DO ... ASSERT` Blocks
  - ADR-0006: `smallint GENERATED ALWAYS AS IDENTITY` for Primary Keys
- `CONTRIBUTING.md` covering commit conventions, branching, PR
  workflow, ADR three-part test, and CI checks.
- `.coderabbit.yaml` committing the organization-level CodeRabbit
  defaults into the repo, with `auto_review.labels` emptied (the org
  default required a `planning` label to trigger reviews) and
  per-path review instructions for `sql/`, `docs/adr/`, `scripts/`,
  and `compose*.yaml`.
- Phase 1 DDL — `sql/schema/`:
  - `01_types.sql`: four enum types (`player_position`, `match_stage`,
    `event_type`, `official_role`) declared upfront per ADR-0003.
  - `02_tables.sql`: seven Phase 1 tables — `confederation`, `team`,
    `stadium` (global) plus `tournament`, `tournament_team`,
    `tournament_group`, `group_standing` (per-tournament). All carry
    `smallint GENERATED ALWAYS AS IDENTITY` PKs per ADR-0006; per-
    tournament tables carry `tournament_id` per ADR-0001. Includes
    domain CHECK constraints (`group_standing.position BETWEEN 1 AND 4`,
    `won + drawn + lost = played`, `goal_difference = goals_for - goals_against`).
  - `03_indexes.sql`: `idx_group_standing_tournament` on
    `group_standing(tournament_id)` — the only Phase 1 table whose
    UNIQUE constraint doesn't lead with `tournament_id`.
- `sql/init.sh` — Postgres docker-entrypoint hook that iterates and
  applies every `*.sql` file in `/repo/sql/schema/` and
  `/repo/sql/seed/` in alphabetical order.
- Phase 1 seed — `sql/seed/01_tournament.sql`: single tournament row
  for FIFA World Cup Qatar 2022 (year 2022, host Qatar, dates
  2022-11-20 to 2022-12-18). `winner_team_id` left NULL; backfilled
  in a later sub-ticket once team rows exist.
- Phase 1 seed — `sql/seed/02_confederations.sql`: six FIFA continental
  confederations (AFC, CAF, CONCACAF, CONMEBOL, OFC, UEFA), inserted
  alphabetically by code so identities are predictable.
- Phase 1 seed — `sql/seed/03_teams.sql`: the 32 national teams that
  participated in Qatar 2022, with FIFA 3-letter codes and FK to
  `confederation`. Uses `INSERT ... SELECT FROM (VALUES ...) JOIN
  confederation ON code` so the seed is robust against changes in
  confederation insertion order.
- Phase 1 seed — `sql/seed/04_tournament_teams.sql`: 32 rows recording
  each team's Qatar 2022 participation (`fifa_ranking` from the
  October 2022 FIFA ranking, `final_position` from the official
  tournament finish — Argentina 1st, France 2nd, Croatia 3rd,
  Morocco 4th, etc.). Tournament and team identities resolved by
  year and code, not hard-coded ids.

### Changed

- `sql/schema/02_tables.sql`: `confederation.name` widened from
  `varchar(50)` to `varchar(100)` so CONCACAF's full official name
  (*"Confederation of North, Central America and Caribbean Association
  Football"*, 73 chars) fits without truncation.
- `compose.yaml`: volume mounts switched from directory-based
  (`./sql/schema:/docker-entrypoint-initdb.d/01-schema`, ignored by
  the postgres entrypoint because it doesn't recurse into
  subdirectories) to script-driven init via `sql/init.sh` mounted at
  `/docker-entrypoint-initdb.d/00-init.sh`, with the full `sql/`
  directory mounted at `/repo/sql/`.

### Fixed

- `tournament.winner_team_id` for Qatar 2022 backfilled to point at
  Argentina, resolving the deferred FK left NULL in
  `01_tournament.sql` because team rows had not yet been seeded at
  that point. Backfill runs at the tail of
  `04_tournament_teams.sql`.

### Removed

---

<!--
## [X.Y.Z - HOST-COUNTRY-YEAR] - YYYY-MM-DD

### Added
- New features

### Changed
- Changes in existing functionality

### Deprecated
- Soon-to-be removed features

### Removed
- Removed features

### Fixed
- Bug fixes

### Security
- Security vulnerability fixes

-->

---

[unreleased]: https://github.com/nanotaboada/postgresql-samples-worldcup-db/commits/master
