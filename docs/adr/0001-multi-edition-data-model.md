# ADR-0001: Multi-Edition Data Model

Date: 2026-04-30

## Status

Accepted (decision). Implementation pending — DDL has not yet landed in
`sql/schema/`. The decision shapes Phase 1 ticket `feat(schema): Phase 1
DDL`.

## Context

The schema models FIFA World Cup tournaments. v1 seeds Qatar 2022 only,
but the project's stated goal includes leaving the door open for future
editions (2026, historical) without a painful schema retrofit.

A naive single-edition schema would treat "Argentina" as one row whose
attributes (FIFA ranking, group, final position) are all bound to a
single tournament. That couples team identity to a specific edition,
which falls apart the moment a second edition is added.

Multi-edition support introduces a `tournament` root entity. The
question becomes how aggressively to propagate `tournament_id` through
the rest of the schema.

## Alternatives Considered

- **Single-edition schema (no `tournament` table).** Simplest possible
  design. Rejected because retrofitting multi-tenancy onto a populated
  single-edition schema is migration hell — every UNIQUE constraint
  widens, every FK propagates, every query needs a backfill of
  `tournament_id`.
- **One repository per edition.** Every edition is its own database
  with its own seed scripts. Sidesteps schema complexity but forces
  duplication of `team`, `player`, `stadium` identity across repos and
  blocks any cross-edition query ("all matches Messi played in").
- **Multi-edition with normalized FK chain only.** `tournament_id`
  appears on top-level tables (`tournament_team`, `tournament_group`,
  `match`, `coach`, `squad_player`); other per-tournament tables reach
  it transitively through their parent FK. Cleaner from a third-normal-
  form standpoint but forces every query that filters by tournament to
  join through to the parent.
- **Multi-edition with denormalized `tournament_id` on every
  per-tournament row.** Selected — see Decision.

## Decision

We will introduce a `tournament` root table and **denormalize
`tournament_id` onto every per-tournament row**. The denormalized
column appears on `tournament_team`, `tournament_group`,
`group_standing`, `coach`, `squad_player`, `match`, `match_official`,
`match_lineup`, `match_event`, and `penalty_kick`.

`team`, `player`, `referee`, `stadium`, `confederation`, `league`, and
`club` remain global (no `tournament_id`) because their identity is
edition-independent.

This denormalization is the standard multi-tenant pattern in production
PostgreSQL: filtering rows by tenant becomes a single indexed column
read; composite uniqueness keys (e.g.,
`(tournament_id, match_number)`) compose naturally; and the door is
open for row-level security policies later. The educational value of
this pattern — used by virtually every B2B SaaS — is itself a goal of
the project.

## Consequences

- **Positive.** Future editions add without schema migration. Queries
  filtering by edition are fast and ergonomic. The schema teaches
  multi-tenant patterns relevant to enterprise systems. Composite
  uniqueness keeps each edition's data internally consistent without
  cross-edition collisions.
- **Negative.** Every per-tournament table carries an extra `smallint`
  column. Seed data is slightly more verbose because each row must
  reference the right `tournament_id` (mitigated via a transaction-
  scoped CTE pattern at the head of seed files).
- **Limitation.** Cross-edition aggregate queries are easy to write
  but require careful indexing on `tournament_id` to stay fast as
  edition count grows. Index strategy is documented alongside the DDL
  in Phase 1.
