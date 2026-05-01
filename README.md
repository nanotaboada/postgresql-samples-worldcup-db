# 🧪 Sample Database with PostgreSQL and Docker

Proof of Concept for a non-trivial relational database modelling FIFA World Cup tournaments — squads, matches, stadiums, events, and officials. Built with **PostgreSQL 17** and containerized with **Docker Compose**, this project demonstrates DDL design, constraints, enums, indexes, seed scripts, multi-tenant data modelling, and Docker-based database workflows.

The schema is **multi-edition by design**: a `tournament` root table makes every per-tournament row scoped by edition, so future World Cups can be added without schema migration. **v1 seeds the FIFA World Cup Qatar 2022.**

This is a sibling project to a series of educational RESTful API samples in .NET, Java, TypeScript, Python, Go, and Rust. One of those stacks will eventually consume this database to build an API and UI on top.

## 🗺️ Roadmap

The database is built in six phases, each tracked as a GitHub epic with a sub-ticket checklist. Phases are sequential — each builds on the data landed by the previous one.

| Phase                                       | Epic                                                                                | Status      |
|---------------------------------------------|-------------------------------------------------------------------------------------|-------------|
| **1 — Tournament Structure**                | [#4](https://github.com/nanotaboada/postgresql-samples-worldcup-db/issues/4)        | ✅ complete |
| **2 — Squads** (leagues, clubs, players, coaches) | [#14](https://github.com/nanotaboada/postgresql-samples-worldcup-db/issues/14) | 🟡 next     |
| **3 — Matches & Officials**                 | [#15](https://github.com/nanotaboada/postgresql-samples-worldcup-db/issues/15)      | ⏳ pending  |
| **4 — Lineups**                             | [#16](https://github.com/nanotaboada/postgresql-samples-worldcup-db/issues/16)      | ⏳ pending  |
| **5 — Match Events** (goals, cards, subs)   | [#17](https://github.com/nanotaboada/postgresql-samples-worldcup-db/issues/17)      | ⏳ pending  |
| **6 — Penalty Shootouts**                   | [#18](https://github.com/nanotaboada/postgresql-samples-worldcup-db/issues/18)      | ⏳ pending  |

Each epic body has data-source pointers, known gotchas, and per-sub-ticket model recommendations (`model:opus` for design-density tickets, `model:sonnet` for mechanical execution).

## 🐳 Quickstart

### Database only

```bash
docker compose up --wait
```

This boots PostgreSQL 17 on `localhost:5432` with database `worldcup` and
user/password `worldcup` / `worldcup`. The `--wait` flag blocks until the
healthcheck passes.

Connect via `psql`:

```bash
psql -h localhost -U worldcup -d worldcup
```

### With Adminer (visual exploration)

```bash
docker compose -f compose.yaml -f compose.tools.yaml up --wait
```

Then browse to <http://localhost:8080> — log in as `worldcup` / `worldcup`
against server `db`.

### Tear down

```bash
docker compose down          # stop containers, keep data volume
docker compose down -v       # also drop the data volume (full reset)
```

## 📂 Layout

```
sql/
├── schema/   # DDL — types, tables, indexes (loaded first)
├── seed/     # Seed data (loaded second, by phase)
└── verify/   # Verification assertions used by CI
scripts/      # One-time Python ETL — outputs sql/seed/*.sql
queries/      # Sample analytical queries
docs/         # Project documentation (ERD, ADRs)
```

📐 The current entity-relationship diagram lives in [`docs/ERD.md`](docs/ERD.md). It renders natively on GitHub via Mermaid and evolves per phase as new tables land.

## 🧭 Architecture Decisions

Significant design decisions are captured as Architecture Decision Records in [`docs/adr/`](docs/adr/). Highlights:

- [ADR-0001](docs/adr/0001-multi-edition-data-model.md) — Multi-edition data model with denormalized `tournament_id`
- [ADR-0002](docs/adr/0002-dual-licensing.md) — Dual licensing (MIT + CC BY-NC-SA 4.0)
- [ADR-0003](docs/adr/0003-native-postgresql-enums.md) — Native PostgreSQL ENUM types
- [ADR-0004](docs/adr/0004-compose-override-pattern.md) — Compose Spec override pattern
- [ADR-0005](docs/adr/0005-do-assert-verification.md) — Verification via `DO ... ASSERT` blocks
- [ADR-0006](docs/adr/0006-smallint-identity-primary-keys.md) — `smallint GENERATED ALWAYS AS IDENTITY` PKs

Full index and contribution guidelines: [`docs/adr/README.md`](docs/adr/README.md) and [`CONTRIBUTING.md`](CONTRIBUTING.md).

## 📜 Licenses

This repository is **dual-licensed**:

- **Code, schema, scripts, configuration** → [MIT](LICENSE)
- **Seed data (`sql/seed/`)** → [CC BY-NC-SA 4.0](DATA_LICENSE)

The data license is required because the seed data is derived from StatsBomb
Open Data, which uses the ShareAlike clause. See [`DATA_SOURCES.md`](DATA_SOURCES.md)
for the full chain of attribution.

## 🤝 Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for commit conventions, branching, PR workflow, and the ADR three-part test. All notable changes are tracked in [`CHANGELOG.md`](CHANGELOG.md).
