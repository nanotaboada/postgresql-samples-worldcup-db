# Contributing

Thank you for improving this project! We value small, precise changes that solve real problems.
We value **incremental, detail‑first contributions** over big rewrites or abstractions.

## 1. Philosophy

> "Nobody should start to undertake a large project. You start with a small _trivial_ project, and you should never expect it to get large. If you do, you'll just overdesign and generally think it is more important than it likely is at that stage. Or worse, you might be scared away by the sheer size of the work you envision. So start small, and think about the details. Don't think about some big picture and fancy design. If it doesn't solve some fairly immediate need, it's almost certainly over-designed. And don't expect people to jump in and help you. That's not how these things work. You need to get something half-way _useful_ first, and then others will say "hey, that _almost_ works for me", and they'll get involved in the project." — [Linus Torvalds](https://web.archive.org/web/20050404020308/http://www.linuxtimes.net/modules.php?name=News&file=article&sid=145)

## 2. Code & Commit Conventions

- **Conventional Commits**
  Follow <https://www.conventionalcommits.org/en/v1.0.0/>:
  - `feat: ` for new features (schema additions, seed data, queries)
  - `fix: ` for bug fixes (data corrections, broken constraints)
  - `chore: ` for maintenance or tooling
  - `docs: ` for documentation changes
  - `docs(adr): ` for new or amended Architecture Decision Records
  - `test: ` for verification-query additions or corrections
  - `refactor: ` for non-behavioural code changes
  - `ci: ` for CI/CD pipeline changes
  - `perf: ` for performance improvements (e.g. index tuning)

- **Commit subject ≤ 80 characters** (commitlint enforced).

- **Logical Commits**
  Group changes by purpose. Multiple commits are fine, but avoid noise. Squash when appropriate.

- **SQL Style**
  - Lowercase keywords are acceptable, but UPPERCASE is preferred for SQL keywords (`CREATE TABLE`, `NOT NULL`, `REFERENCES`).
  - Snake_case for identifiers (tables, columns, indexes).
  - Singular table names (`team`, not `teams`).
  - One DDL statement per logical unit; group related tables together with section comments.

- **Schema Discipline**
  - Schema changes go through `sql/schema/`, never inline in seed files.
  - Seed files only contain `INSERT` statements (and CTE setup at the head of each file).
  - Verification assertions live in `sql/verify/` and run in CI.

## 3. Branching and Pull Requests

- **Branch per Issue/ticket**, named with conventional-commit-style prefixes:
  `feat/phase1-ddl`, `chore/init-adrs`, `docs/data-sources-update`, etc.
- **One logical change per PR.**
- **Rebase or squash** before opening to keep history clean.
- **Title & Description**
  - Title in Conventional Commit format.
  - Body explains _what_ and _why_ concisely. Reference any related ADR
    (e.g., "implements ADR-0001").
- **CodeRabbit review** runs server-side on every PR. Address findings
  before merge — only reply when dismissing a suggestion; no reply is
  needed when accepting a fix.
- **No direct pushes to `master`.** Master is protected; everything
  goes through a PR.

## 4. Architecture Decision Records

Significant architectural decisions are documented as ADRs in
[`docs/adr/`](docs/adr/). Before changing or replacing a decision
captured in an ADR, write a new ADR that supersedes it — do not edit
the original.

**When to write an ADR:** apply the three-part test:

1. **A real fork existed** — a genuine alternative was considered and
   rejected.
2. **The code doesn't explain the why** — a new contributor reading
   the source cannot infer the reasoning.
3. **Revisiting it would be costly** — changing it requires
   significant rework.

All three must be true. Process conventions (commit format, branch
naming) and project principles (audience, tone) do **not** belong in
ADRs — those go here in `CONTRIBUTING.md` or in the README.

ADRs are **append-only**. To change a decision: write a new ADR with
status `SUPERSEDED by ADR-NNNN` on the old one.

See [`docs/adr/README.md`](docs/adr/README.md) for the index and the
ADR template.

## 5. Issue Reporting

- Search open issues before creating a new one.
- Use the appropriate template (`Bug report` or `Feature request`).
- Include clear steps to reproduce and environment details
  (PostgreSQL version, Docker version, OS).
- Prefer **focused** issues — don't bundle multiple topics.

## 6. Automation & Checks

All PRs and pushes go through CI:

- **Commitlint** for commit-message style.
- **Schema + seed bring-up** — `docker compose up --wait` boots the
  database with all schema and seed scripts applied.
- **Verification queries** — `sql/verify/verify.sql` runs every
  `DO ... ASSERT` block. First failure fails the workflow.
- **CodeRabbit** server-side review on every PR.
