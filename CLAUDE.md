# Project Guide

## What This Project Is

This repository is a Flutter setup generator scaffolded around `ipf_flutter_starter_pack`.
It is designed to stay project-level and reusable, while the starter pack handles shared package-level skills and infrastructure.

## Conventions

- Use `provider` for state in the generated scaffold.
- Keep theme colors in `lib/core/theme` and consume them through `ThemeData` and `ColorScheme`.
- Do not add manually defined widget colors when a theme value can be used.
- Use `APIManager` for service calls.
- Keep screens, providers, services, and models in the feature-based layout.

## Project Structure

- `lib/core/`: theme, router, resources, utilities, extensions
- `lib/root/`: app shell, splash, home
- `lib/features/`: feature modules
- `lib/shared/providers/`: global provider registration
- `lib/shared/widgets/`: shared project widgets
- `.claude/commands/`: project-level setup and workflow docs
- `.claude/skills/`: starter-pack skill docs installed by the package

## Setup Notes

- The Android project must include network permissions and core library desugaring.
- The iOS project must keep a valid bundle identifier and display name.
- The generator should not use `flutter_pack`; only `ipf_flutter_starter_pack` is supported.
