# ADR-0004: Compose Spec Override Pattern for Optional Services

Date: 2026-04-30

## Status

Accepted

## Context

The project's runtime is Docker Compose. The base service set is just
PostgreSQL — sufficient for CI, headless workflows, and any consumer
who only needs the database.

A second service is occasionally useful: **Adminer**, a single-file
PHP database client (~200 KB) for visual exploration of the schema
and data. Adminer is not required to run the database; it's a
developer convenience.

The question is how to model "optional service" in the Compose
configuration so that:

- The default `docker compose up` stays minimal — no PHP image pulled
  unless needed, no extra port bound, no extra container in CI.
- Adminer can be enabled with a short, explicit command.
- The pattern can be extended naturally as more optional tools are
  added (e.g., pgAdmin, pgweb, observability sidecars).

The Compose Specification (the post-2023 successor to legacy
`docker-compose.yml`) offers two well-supported mechanisms for this:
**`profiles:`** and **multi-file overrides**.

## Alternatives Considered

- **Single `compose.yaml` with all services.** Adminer always runs.
  Wastes resources in CI and any headless workflow. Rejected — the
  base must stay minimal.
- **`profiles:` field on each optional service.** Modern Compose
  feature — services tagged with one or more profiles only start when
  the matching `--profile` flag is supplied or the
  `COMPOSE_PROFILES` environment variable is set. Cleaner from a
  single-file perspective; one source of truth.
- **Multi-file override pattern.** Base `compose.yaml` + opt-in
  `compose.tools.yaml`, loaded via
  `docker compose -f compose.yaml -f compose.tools.yaml up`. A
  long-standing Compose feature, well-documented by Docker.
  Selected — see Decision.
- **Separate Compose stacks.** One stack for the database, another
  for tools, run independently. Loses healthcheck-based ordering
  (`depends_on: condition: service_healthy`). Rejected.

## Decision

We will use the **multi-file override pattern**. The base
`compose.yaml` declares only the `db` service; an opt-in
`compose.tools.yaml` adds `adminer` with `depends_on: condition:
service_healthy` against the base `db` service.

```bash
docker compose up --wait                                  # db only
docker compose -f compose.yaml -f compose.tools.yaml up   # + Adminer
```

Both files are checked in at the repo root.

## Consequences

- **Positive.** The base file is minimal and self-contained — easier
  to read, faster to start, no surprise services in CI. The override
  file is opt-in and explicit at invocation time. Adding more
  optional services (e.g., `compose.observability.yaml`) follows the
  same pattern.
- **Negative.** Tools mode requires a longer command than `profiles:`
  would. Users may forget the `-f` flags and wonder why Adminer isn't
  running.
- **Limitation as override files multiply.** If the project grows to
  five or six override files, the invocation gets unwieldy. The
  recommended response at that point would be a thin
  `Makefile`/`Taskfile.yml` wrapper rather than a switch to
  `profiles:`. Override files compose; profiles do not.
- **Forward-compatibility.** The Compose Specification continues to
  support both override files and profiles, so this decision is not
  locked-in against a future migration.
