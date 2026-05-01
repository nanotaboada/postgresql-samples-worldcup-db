-- =============================================================================
-- Phase 1 — Tables
-- =============================================================================
-- Foundational tournament structure: identity tables (confederation,
-- team), the tournament root with edition-specific scoping
-- (tournament_team, tournament_group, group_standing), and venues
-- (stadium).
--
-- Multi-edition design (ADR-0001): per-tournament tables carry a
-- denormalized `tournament_id` column. Global tables — confederation,
-- team, stadium — do not.
--
-- Primary keys are smallint identity columns (ADR-0006).
-- =============================================================================


-- -----------------------------------------------------------------------------
-- Global tables (no tournament_id)
-- -----------------------------------------------------------------------------

CREATE TABLE confederation (
    id    smallint     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name  varchar(100) NOT NULL,
    code  varchar(10)  NOT NULL UNIQUE
);

CREATE TABLE team (
    id                smallint    GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name              varchar(50) NOT NULL UNIQUE,
    code              char(3)     NOT NULL UNIQUE,
    confederation_id  smallint    NOT NULL REFERENCES confederation(id)
);

CREATE TABLE stadium (
    id           smallint     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name         varchar(100) NOT NULL,
    city         varchar(50)  NOT NULL,
    country      varchar(50)  NOT NULL,
    capacity     integer,
    opened_year  smallint,
    description  text
);


-- -----------------------------------------------------------------------------
-- Tournament root + per-tournament tables
-- -----------------------------------------------------------------------------

CREATE TABLE tournament (
    id              smallint    GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    year            smallint    NOT NULL UNIQUE,
    host_country    varchar(50) NOT NULL,
    edition_name    varchar(100),
    start_date      date        NOT NULL,
    end_date        date        NOT NULL,
    -- Nullable: tournaments in progress have no winner yet.
    winner_team_id  smallint    REFERENCES team(id),
    CHECK (end_date >= start_date)
);

CREATE TABLE tournament_team (
    id              smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tournament_id   smallint NOT NULL REFERENCES tournament(id),
    team_id         smallint NOT NULL REFERENCES team(id),
    fifa_ranking    smallint,
    final_position  smallint,
    UNIQUE (tournament_id, team_id)
);

CREATE TABLE tournament_group (
    id             smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tournament_id  smallint NOT NULL REFERENCES tournament(id),
    letter         char(1)  NOT NULL,
    UNIQUE (tournament_id, letter),
    CHECK (letter IN ('A','B','C','D','E','F','G','H'))
);

CREATE TABLE group_standing (
    id              smallint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tournament_id   smallint NOT NULL REFERENCES tournament(id),
    group_id        smallint NOT NULL REFERENCES tournament_group(id),
    team_id         smallint NOT NULL REFERENCES team(id),
    played          smallint NOT NULL DEFAULT 0,
    won             smallint NOT NULL DEFAULT 0,
    drawn           smallint NOT NULL DEFAULT 0,
    lost            smallint NOT NULL DEFAULT 0,
    goals_for       smallint NOT NULL DEFAULT 0,
    goals_against   smallint NOT NULL DEFAULT 0,
    goal_difference smallint NOT NULL DEFAULT 0,
    points          smallint NOT NULL DEFAULT 0,
    position        smallint NOT NULL,
    UNIQUE (group_id, team_id),
    CHECK (position BETWEEN 1 AND 4),
    CHECK (won + drawn + lost = played),
    CHECK (goal_difference = goals_for - goals_against)
);
