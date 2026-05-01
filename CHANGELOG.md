# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Release Naming Convention 🏆

This project uses **FIFA World Cup editions** as release codenames, advancing chronologically through World Cup history. The codename advances on each release independently of the SemVer bump (a patch and a major may both consume one codename).

The sibling API repositories use an A-Z football-coaches theme; this database project departs from that convention because its organising principle is *time* (the historical sequence of tournaments) rather than alphabet.

| #  | Year | Host(s)                                                                                    | Tag Name                       |
|----|------|--------------------------------------------------------------------------------------------|--------------------------------|
| 1  | 1930 | Uruguay                                                                                    | `uruguay-1930`                 |
| 2  | 1934 | Italy                                                                                      | `italy-1934`                   |
| 3  | 1938 | France                                                                                     | `france-1938`                  |
| 4  | 1950 | Brazil                                                                                     | `brazil-1950`                  |
| 5  | 1954 | Switzerland                                                                                | `switzerland-1954`             |
| 6  | 1958 | Sweden                                                                                     | `sweden-1958`                  |
| 7  | 1962 | Chile                                                                                      | `chile-1962`                   |
| 8  | 1966 | England                                                                                    | `england-1966`                 |
| 9  | 1970 | Mexico                                                                                     | `mexico-1970`                  |
| 10 | 1974 | West Germany                                                                               | `west-germany-1974`            |
| 11 | 1978 | Argentina                                                                                  | `argentina-1978`               |
| 12 | 1982 | Spain                                                                                      | `spain-1982`                   |
| 13 | 1986 | Mexico                                                                                     | `mexico-1986`                  |
| 14 | 1990 | Italy                                                                                      | `italy-1990`                   |
| 15 | 1994 | United States                                                                              | `usa-1994`                     |
| 16 | 1998 | France                                                                                     | `france-1998`                  |
| 17 | 2002 | South Korea & Japan                                                                        | `south-korea-japan-2002`       |
| 18 | 2006 | Germany                                                                                    | `germany-2006`                 |
| 19 | 2010 | South Africa                                                                               | `south-africa-2010`            |
| 20 | 2014 | Brazil                                                                                     | `brazil-2014`                  |
| 21 | 2018 | Russia                                                                                     | `russia-2018`                  |
| 22 | 2022 | Qatar                                                                                      | `qatar-2022`                   |
| 23 | 2026 | Canada, Mexico & United States                                                             | `canada-mexico-usa-2026`       |
| 24 | 2030 | Spain, Portugal & Morocco                                                                  | `spain-portugal-morocco-2030`  |
| 25 | 2034 | Saudi Arabia                                                                               | `saudi-arabia-2034`            |

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
  `config.yml` (blank issues disabled). Mirrors the format used across
  the six sibling API repositories.
- Architecture Decision Records — initial set in `docs/adr/`:
  - ADR-0001: Multi-Edition Data Model
  - ADR-0002: Dual Licensing — MIT for Code, CC BY-NC-SA 4.0 for Data
  - ADR-0003: Native PostgreSQL ENUM Types over CHECK Constraints
  - ADR-0004: Compose Spec Override Pattern for Optional Services
  - ADR-0005: Schema Verification via In-Line `DO ... ASSERT` Blocks
  - ADR-0006: `smallint GENERATED ALWAYS AS IDENTITY` for Primary Keys
- `CONTRIBUTING.md` covering commit conventions, branching, PR
  workflow, ADR three-part test, and CI checks.

### Changed

### Fixed

### Removed

---

<!--
## [X.Y.Z - COACH_NAME] - YYYY-MM-DD

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
