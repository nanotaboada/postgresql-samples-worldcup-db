# ADR-0005: Schema Verification via In-Line `DO ... ASSERT` Blocks

Date: 2026-04-30

## Status

Accepted (decision). Implementation pending — `sql/verify/verify.sql`
has not yet been authored. The decision shapes Phase 1 ticket
`feat(verify): Phase 1 verification queries` and the CI workflow.

## Context

The project is data-heavy: every phase ships seed data that has to
satisfy invariants (counts, FK integrity, derived consistency) for
the database to be trustworthy. CI must catch integrity drift the
moment a seed file goes wrong, not when a developer happens to run
an exploratory query days later.

Concrete examples of what needs to be asserted:

- `count(*) = 6` on `confederation`, `count(*) = 32` on `team`,
  `count(*) = 64` on `match WHERE tournament_id = (SELECT id FROM
  tournament WHERE year = 2022)`, etc.
- Derived consistency, e.g. **goal events must reconcile with
  `match.home_score + match.away_score`** — a class of bug that's
  silent until queried.
- Per-edition uniqueness invariants like "every team in Qatar 2022
  has exactly 26 squad players".

The assertion set grows with every phase. The mechanism needs to be:

- **Versionable** alongside the schema and seed.
- **Runnable in CI** without extra orchestration.
- **Fail-fast** — first failure aborts with a non-zero exit code.

## Alternatives Considered

- **pgTAP** — a TAP-output PostgreSQL testing framework. The
  industry-standard choice. Supports test discovery, parallelism,
  rich assertion vocabulary. Requires installing the `pgtap`
  extension (`CREATE EXTENSION pgtap`) and a TAP harness
  (`pg_prove` / `pg_isolation_regress`). Heavy for this project's
  current scope.
- **Application-level integration tests** — write the assertions in
  Python/Go/etc., run them via `pytest` or equivalent against the
  running database. Adds a runtime dependency and a test framework
  before there's any application code, contradicting the project's
  staged delivery.
- **Plain `SELECT count(*)` queries** with shell-side comparisons
  in the CI workflow. Loose — duplicates assertion logic between
  SQL and shell, errors are unstructured.
- **In-line `DO ... ASSERT` blocks** in `sql/verify/*.sql`,
  executed via `psql -v ON_ERROR_STOP=1 -f`. Selected — see
  Decision.

## Decision

We will write verification queries as **PL/pgSQL `DO` blocks
containing `ASSERT` statements**, organized by phase, in a single
`sql/verify/verify.sql` file. Each `DO` block scopes to one phase,
with a `DECLARE` section that resolves shared identifiers
(e.g., `qatar2022_id smallint;`) once and reuses them across the
phase's assertions.

CI invokes:

```bash
docker compose exec -T db \
  psql -v ON_ERROR_STOP=1 -U worldcup -d worldcup \
  -f /verify/verify.sql
```

`ON_ERROR_STOP=1` plus the failed assertion's non-zero exit code
fails the workflow on the first integrity violation.

## Consequences

- **Positive.** Zero dependencies beyond PostgreSQL itself — no
  extension to install, no test framework to introduce. Assertions
  live alongside the schema and seed, versioned in the same commits.
  CI integration is a single shell line. Each `DO` block is
  self-contained and reads top-to-bottom as the per-phase invariants
  the data must satisfy.
- **Negative.** Less rich than pgTAP — no test discovery, no
  parallel execution, no per-assertion granular reporting. The first
  failed assertion aborts the block; subsequent assertions in the
  same `DO` block do not run. CI sees one failure at a time even if
  multiple invariants are broken.
- **Limitation: navigation as the assertion set grows.** Past ~50
  assertions across 6 phases, a single `verify.sql` file becomes
  hard to navigate. Mitigation: split into `verify_phase_1.sql`,
  `verify_phase_2.sql`, etc., loaded in order by the CI step. The
  split is mechanical and does not require revisiting this ADR.
- **Migration path to pgTAP.** If the assertion set outgrows `DO`
  blocks (very unlikely at this project's scope), a follow-up ADR
  would supersede this one. Migration would be assertion-by-assertion
  rewriting, which is mechanical but tedious.
