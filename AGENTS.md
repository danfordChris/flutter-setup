# Setup Repo Guide

This repository contains the Flutter setup generator, template docs, and support files used to scaffold new apps with `ipf_flutter_starter_pack`.

## What This Repo Does

- Creates a new Flutter project from the command script.
- Installs `ipf_flutter_starter_pack` and its skills into the generated project.
- Writes project-level `AGENTS.md`, `CLAUDE.md`, `.claude/commands`, and `.claude/skills` for the target app.
- Generates a starter app shell that uses provider-based state management and theme-driven colors.

## Source Of Truth

- `flutter_setup.sh` is the generator entrypoint.
- `skills/` and `commands/` are template docs that are copied into generated projects.
- `README.md` documents how to use the generator.

## Editing Rules

- Keep the generator compatible with `ipf_flutter_starter_pack`; do not reintroduce `flutter_pack`.
- Do not hand-edit generated app output from an existing run in this repository.
- Keep template docs project-agnostic so they can be copied into any target app.
- Remove or replace any project-specific dependency in a template before treating it as reusable.

## Common Change Areas

- Generator behavior: `flutter_setup.sh`
- Starter-pack setup notes: `skills/ipf-setup.md` and `commands/ipf-setup.md`
- User-facing generator guidance: `README.md`

## Validation

- Run `bash -n flutter_setup.sh` after editing the generator.
- Prefer a focused dry run in a disposable target project for behavior changes.
