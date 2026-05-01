# ADR-0003: Native PostgreSQL ENUM Types over CHECK Constraints

Date: 2026-04-30

## Status

Accepted (decision). Implementation pending — DDL has not yet landed
in `sql/schema/`. The decision shapes Phase 1 ticket
`feat(schema): Phase 1 DDL`.

## Context

The schema has four small, fixed-domain attributes that need their
valid values enforced at the database layer:

- **Player position**: `GK`, `DF`, `MF`, `FW`
- **Match stage**: `GROUP`, `ROUND_OF_16`, `QUARTER_FINAL`,
  `SEMI_FINAL`, `THIRD_PLACE`, `FINAL`
- **Match event type**: `GOAL`, `OWN_GOAL`, `PENALTY_GOAL`,
  `PENALTY_MISS`, `YELLOW_CARD`, `SECOND_YELLOW`, `RED_CARD`,
  `SUBSTITUTION`
- **Official role**: `MAIN`, `ASSISTANT_1`, `ASSISTANT_2`, `FOURTH`,
  `VAR`

These domains are **stable across editions** — FIFA's competition
structure does not change frequently, and the categorical vocabulary
of football events is largely settled. New values may be added
occasionally (e.g., a new card type), but existing values rarely
change meaning.

PostgreSQL offers three reasonable mechanisms for this kind of fixed
domain.

## Alternatives Considered

- **`CHECK` constraint**, e.g.
  `position varchar(2) CHECK (position IN ('GK','DF','MF','FW'))`.
  Most flexible — values can be added, removed, or renamed by dropping
  and recreating the constraint. Stores the value as a regular string,
  so storage is not optimal. The constraint must be repeated on every
  table that uses the domain, which violates DRY and risks drift.
- **Lookup table** (`position_type` with a `code` PK and FK from main
  tables). Allows attaching metadata to each value (display name,
  description, sort order). Adds a join to most queries that read
  positional data. Overkill for a domain with no metadata to attach.
- **Native PostgreSQL ENUM type**, e.g.
  `CREATE TYPE player_position AS ENUM ('GK','DF','MF','FW')`.
  Type-safe at the column level, defined once and reused across
  tables, stored as a 4-byte OID. Selected — see Decision.

## Decision

We will define native PostgreSQL ENUM types for the four fixed
domains listed above, in `sql/schema/01_types.sql`. Tables reference
the types directly (e.g.,
`position player_position NOT NULL`).

Native ENUMs are the right fit because the domains are **fixed and
shared across multiple tables**. Defining the type once and reusing
it via a column type is cleaner than repeating a `CHECK` constraint
or maintaining a lookup table.

## Consequences

- **Positive.** Type safety at the column level — invalid values are
  rejected at INSERT time with a clear error. The DDL is
  self-documenting (the type definition lists every valid value).
  Storage is compact (4 bytes per value via OID lookup). Reuse across
  tables avoids drift between table definitions.
- **Negative.** ENUM types are tied to PostgreSQL specifically. If
  the schema were ever ported to another engine (e.g., for an API
  backend that wants SQLite), the ENUMs would have to be rewritten as
  CHECK constraints or lookup tables.
- **Limitation: ALTER TYPE has restrictions.** Adding values is
  supported (`ALTER TYPE x ADD VALUE 'NEW' AFTER 'EXISTING'`), but
  **removing** or **renaming** values is not directly supported and
  requires a multi-step migration (create new type, swap columns,
  drop old type). Acceptable because the domains are stable; if a
  domain becomes volatile, that domain should be migrated to a
  lookup table in a follow-up ADR.
- **Limitation: ordering of ENUM values matters** for sort comparisons.
  The order in `CREATE TYPE` defines the comparison order. Adding a
  value out-of-band requires `AFTER`/`BEFORE` clauses to maintain
  intuitive ordering.
