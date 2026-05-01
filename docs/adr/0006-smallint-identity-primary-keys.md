# ADR-0006: `smallint GENERATED ALWAYS AS IDENTITY` for Primary Keys

Date: 2026-04-30

## Status

Accepted (decision). Implementation pending — DDL has not yet landed
in `sql/schema/`. The decision shapes Phase 1 ticket
`feat(schema): Phase 1 DDL`.

## Context

Every table in the schema needs a primary key. The domain has
**bounded sizes** that are unusually small by SaaS standards:

- 1 tournament per edition; ~20–50 editions in any plausible future
- 6 confederations
- ~32 teams per edition (32 in Qatar 2022)
- ~832 players per edition
- ~64 matches per edition
- ~800 events per edition

The largest table is `match_event`, projected at roughly 800 rows
per edition. Even at 40 editions, that's ~32,000 rows — well within
`smallint`'s `[-32768, 32767]` range.

PostgreSQL offers several PK strategies. The choice affects storage,
performance, debuggability, and any future migration path.

## Alternatives Considered

- **`serial` / `bigserial`.** The pre-2017 convention. Now considered
  legacy — `serial` is just a macro for an `integer` column with a
  sequence and a default. The SQL-standard replacement is
  `GENERATED AS IDENTITY`, supported in PostgreSQL since 10 (2017).
  Rejected as outdated.
- **`integer GENERATED ALWAYS AS IDENTITY`.** The default modern
  choice. 4 bytes per value, range `[-2^31, 2^31-1]`. Generous
  headroom but four times the storage of `smallint` for keys we will
  never exhaust.
- **`bigint GENERATED ALWAYS AS IDENTITY`.** Defensive — 8 bytes,
  range to `2^63 - 1`. Appropriate for SaaS-scale tables. Wildly
  oversized for this domain.
- **`uuid` (v4 or v7).** Globally unique, useful for distributed
  systems and offline ID generation. 16 bytes per value, larger
  index footprint. Useful when IDs are exposed in URLs or generated
  outside the database. Not relevant here — IDs are internal.
- **Natural keys** (e.g., `team.code = 'ARG'` as PK). Semantically
  meaningful, but FIFA codes can change (rare but documented), and
  natural keys propagate through every FK. Rejected — surrogate keys
  are the pragmatic default.
- **`smallint GENERATED ALWAYS AS IDENTITY`.** Selected — see
  Decision.

## Decision

We will use `smallint GENERATED ALWAYS AS IDENTITY` as the primary
key type for **every table in the schema**.

The choice is driven by the domain's bounded size. Picking a column
type that reflects the data's actual range is good schema discipline:
it surfaces accidental scale mismatches early (an INSERT that would
exceed 32,767 rows fails loudly) and minimizes per-row storage on
narrow tables that will accumulate millions of FK references.

`GENERATED ALWAYS AS IDENTITY` (rather than `BY DEFAULT`) prevents
clients from supplying their own `id` value, eliminating a class of
seed-data bug where a manual ID collides with a future
auto-generated one.

## Consequences

- **Positive.** Minimum storage (2 bytes per ID vs. 4 for `int` or
  16 for `uuid`). Composite-key indexes — essential for
  multi-tenant uniqueness like `(tournament_id, match_number)` —
  stay narrow. The domain-typed PK acts as a soft assertion that the
  table is bounded; if a future change pushes a table past 32,767
  rows, that's a meaningful design signal worth surfacing. SQL-
  standard syntax is also more future-proof than `serial`.
- **Negative.** Hard ceiling at 32,767 rows per table. The largest
  projected table (`match_event`) reaches the ceiling at roughly 40
  editions of complete event data — far beyond any realistic project
  scope, but a real ceiling nonetheless. If we ever ingest extended
  per-event data (xy coordinates, pass-by-pass) the ceiling shrinks
  fast.
- **Migration path if exceeded.** Promoting a column from `smallint`
  to `integer` is an `ALTER TABLE ... ALTER COLUMN ... TYPE integer`
  on the PK plus all referencing FKs. Doable, but disruptive to a
  populated database; acquires a strong lock. Project a year of
  growth and re-evaluate before getting close to the limit.
- **Limitation: no obfuscation.** Sequential `smallint` IDs leak
  row counts. Not a concern for this educational project, but worth
  flagging if the schema is ever reused for an externally-exposed
  API.
