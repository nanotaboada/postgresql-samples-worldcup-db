# Architecture Decision Records

This directory contains Architecture Decision Records (ADRs) for the
`postgresql-samples-worldcup-db` project.

An ADR captures a decision that had real alternatives, whose reasoning
cannot be inferred from the code alone, and that would be costly to
reverse. See [CONTRIBUTING.md](../../CONTRIBUTING.md) for when to write
one and the three-part test.

ADRs are **append-only**. To change a decision: write a new ADR with
status `SUPERSEDED by ADR-NNNN` on the old one.

## Index

| #    | Title                                                                              | Status                          | Date       |
| ---- | ---------------------------------------------------------------------------------- | ------------------------------- | ---------- |
| [0001](0001-multi-edition-data-model.md)         | Multi-Edition Data Model                                | Accepted (impl. pending) | 2026-04-30 |
| [0002](0002-dual-licensing.md)                   | Dual Licensing — MIT for Code, CC BY-NC-SA 4.0 for Data | Accepted                 | 2026-04-30 |
| [0003](0003-native-postgresql-enums.md)          | Native PostgreSQL ENUM Types over CHECK Constraints     | Accepted (impl. pending) | 2026-04-30 |
| [0004](0004-compose-override-pattern.md)         | Compose Spec Override Pattern for Optional Services     | Accepted                 | 2026-04-30 |
| [0005](0005-do-assert-verification.md)           | Schema Verification via In-Line `DO ... ASSERT` Blocks  | Accepted (impl. pending) | 2026-04-30 |
| [0006](0006-smallint-identity-primary-keys.md)   | `smallint GENERATED ALWAYS AS IDENTITY` for Primary Keys | Accepted (impl. pending) | 2026-04-30 |

## Adding a new ADR

1. Copy [`template.md`](template.md) to a new file
   `NNNN-kebab-case-title.md`, where `NNNN` is the next number.
2. Fill in Status, Context, Alternatives Considered, Decision,
   Consequences.
3. Add a row to the index above.
4. Commit with `docs(adr): add ADR-NNNN — short description`.

## Status meanings

- **PROPOSED** — under discussion; not yet decided.
- **Accepted** — decided and the code reflects the decision.
- **Accepted (impl. pending)** — decided, but the implementation is
  scheduled for a future ticket. The ADR documents the agreement so
  future PRs can reference it.
- **DEPRECATED** — the decision is no longer recommended but has not
  been actively replaced.
- **SUPERSEDED by ADR-NNNN** — replaced by a newer ADR. The original
  remains in the repo as historical context.
