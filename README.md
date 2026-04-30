# 🧪 Sample Database with PostgreSQL and Docker

Proof of Concept for a non-trivial relational database modelling FIFA World Cup tournaments — squads, matches, stadiums, events, and officials. Built with **PostgreSQL 17** and containerized with **Docker Compose**, this project demonstrates DDL design, constraints, enums, indexes, seed scripts, multi-tenant data modelling, and Docker-based database workflows.

The schema is **multi-edition by design**: a `tournament` root table makes every per-tournament row scoped by edition, so future World Cups can be added without schema migration. **v1 seeds the FIFA World Cup Qatar 2022.**

This is a sibling project to a series of educational RESTful API samples in .NET, Java, TypeScript, Python, Go, and Rust. One of those stacks will eventually consume this database to build an API and UI on top.

## 🏗️ Status

🚧 **Phase 1 scaffolding.** Schema and seed data land incrementally per the
phased delivery plan documented in the project proposal.

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

## 📜 Licenses

This repository is **dual-licensed**:

- **Code, schema, scripts, configuration** → [MIT](LICENSE)
- **Seed data (`sql/seed/`)** → [CC BY-NC-SA 4.0](DATA_LICENSE)

The data license is required because the seed data is derived from StatsBomb
Open Data, which uses the ShareAlike clause. See [`DATA_SOURCES.md`](DATA_SOURCES.md)
for the full chain of attribution.
