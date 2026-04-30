# Data Sources & Attribution

The seed data in `sql/seed/` is derived from the sources documented below.
This file satisfies the attribution requirements of CC BY-NC-SA 4.0 and CC BY-SA.

> This file will be filled in as each phase of seed data is added. The skeleton
> below establishes the format; entries are appended as data lands in `sql/seed/`.

---

## Format

For each source, document:

- **Name & URL** — where to find it
- **License** — exact license and version
- **Retrieval date** — when this project's snapshot was taken
- **Used for** — which seed files derive from it
- **Modifications** — manual curation, corrections, format conversions

---

## StatsBomb Open Data

- **Repository**: https://github.com/statsbomb/open-data
- **License**: Creative Commons Attribution-NonCommercial-ShareAlike 4.0
- **Retrieval date**: _to be filled in during Phase 3 / 4 / 5 ETL_
- **Used for**: matches, lineups, match events, referees per match
- **Modifications**: JSON events transformed into SQL `INSERT` statements via
  `scripts/transform_statsbomb.py`. Coordinates and per-event xy data are
  dropped in this dataset.

## openfootball / worldcup.json

- **Repository**: https://github.com/openfootball/worldcup.json
- **License**: Public Domain (CC0)
- **Retrieval date**: _to be filled in_
- **Used for**: cross-reference of match results and goal scorers

## Kaggle datasets (TBD)

- **Source**: _specific datasets and authors to be selected during Phase 2_
- **License**: per-dataset (most are CC0 or CC BY)
- **Used for**: player-club affiliations not present in StatsBomb

## Wikipedia

- **License**: Creative Commons Attribution-ShareAlike 4.0
- **Used for**: stadium descriptions, head coaches, referee assignments,
  verification of all other data
- **Modifications**: manual curation for the ~50 rows where other sources
  have gaps

---

_Last updated: Phase 1 scaffolding (no seed data yet)._
