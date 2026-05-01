# ADR-0002: Dual Licensing — MIT for Code, CC BY-NC-SA 4.0 for Data

Date: 2026-04-30

## Status

Accepted

## Context

The repository contains two materially different kinds of artifact:

- **Code, schema DDL, ETL scripts, configuration, documentation.**
  Authored by this project. No external license constraints.
- **Seed data** (forthcoming in `sql/seed/`) — `INSERT` statements
  derived primarily from [StatsBomb Open Data](https://github.com/statsbomb/open-data),
  with supplementary sources (Wikipedia, openfootball, Kaggle) listed
  in `DATA_SOURCES.md`.

StatsBomb Open Data is published under **Creative Commons
Attribution-NonCommercial-ShareAlike 4.0 International**
(CC BY-NC-SA 4.0). The ShareAlike clause is viral: any derivative
work — and SQL `INSERT` statements transformed from their JSON event
data unambiguously qualify, regardless of reformatting — must be
released under the same license. The NonCommercial clause prohibits
commercial use without a separate agreement with StatsBomb.

The six sibling API repos (`Dotnet.Samples.AspNetCore.WebApi`,
`go-samples-gin-restful`, `java.samples.spring.boot`,
`python-samples-fastapi-restful`, `rust-samples-rocket-restful`,
`ts-node-samples-express-restful`) are MIT-licensed. Consistency with
that family is a soft goal for the code side of this repo.

## Alternatives Considered

- **Single MIT license over the whole repo.** Permissive and
  consistent with the API repos, but **not legally compatible with
  StatsBomb's ShareAlike clause** for the seed data. Rejected.
- **Single CC BY-NC-SA 4.0 over the whole repo.** Legal for the data,
  but unnecessarily restricts the code (schema, ETL scripts, configs).
  Would prevent commercial re-use of the schema even though no upstream
  source forbids that. Rejected.
- **Single Apache 2.0 over the whole repo.** Same problem as MIT for
  the data. Rejected.
- **Dual license: MIT for code, CC BY-NC-SA 4.0 for seed data.**
  Selected — see Decision.
- **Drop the StatsBomb-derived seed data entirely.** Would dodge the
  ShareAlike issue but eliminates the project's most authoritative
  data source for matches, lineups, and events. Rejected.

## Decision

We will dual-license:

- **`LICENSE` (MIT)** applies to all code and configuration: schema
  DDL (`sql/schema/`), verification queries (`sql/verify/`), example
  queries (`queries/`), Python ETL scripts (`scripts/`), GitHub Actions
  workflows (`.github/`), Compose files, and documentation.
- **`DATA_LICENSE` (CC BY-NC-SA 4.0)** applies exclusively to seed
  data files in `sql/seed/`.

Both license files explicitly state their scope. Attribution for each
upstream data source is recorded in `DATA_SOURCES.md` — required by
both StatsBomb's terms and Wikipedia's CC BY-SA.

## Consequences

- **Positive.** Legally compliant with StatsBomb's terms. The code
  side stays permissive (MIT) and consistent with the companion repositories.
  Downstream users get clear scope boundaries: they can copy the schema
  freely under MIT, and they understand the constraints around
  redistributing the seed data.
- **Negative.** Two license files plus an attribution document is
  more overhead than a single LICENSE. Downstream consumers must
  understand which artifact has which license.
- **Limitation.** The seed data cannot be used commercially without
  separate permission from StatsBomb. This is a feature for an
  educational project; it would be a problem for a commercial fork.
- **Append-only consequence on data sources.** Adding a new upstream
  data source requires checking its license is compatible with
  CC BY-NC-SA 4.0's ShareAlike clause and recording attribution in
  `DATA_SOURCES.md`. Sources under CC0, CC BY, or public domain are
  always compatible. Sources under CC BY-SA require care.
