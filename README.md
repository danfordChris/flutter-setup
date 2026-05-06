# Flutter Setup Script

`flutter_setup.sh` creates a Flutter project scaffold that uses `ipf_flutter_starter_pack` instead of `flutter_pack`.

## What it does

- Prompts for the app name, package name, state management choice, and signing preference.
- Creates the Flutter project.
- Installs `go_router`, `provider`, `flutter_dotenv`, and `ipf_flutter_starter_pack`.
- Initializes starter-pack global/project skills via `dart run ipf_flutter_starter_pack:initialize_skills`.
- Falls back to `install_skills` automatically when using an older starter-pack version.
- Generates project-level `AGENTS.md`, `CLAUDE.md`, `.claude/commands`, and `.claude/skills`.
- Writes a provider-based starter app shell with theme-driven colors.
- Configures Android network permissions and core library desugaring.
- Updates the iOS bundle identifier and display name.

## Usage

```bash
chmod +x flutter_setup.sh
./flutter_setup.sh
```

You can also pass a first positional argument to seed the app name prompt.

## Starter Pack Skill Initialization

The generator uses a version-safe initialization flow:

1. Run `initialize_skills` from `iPF_Flutter_Starter_Pack`.
2. If unavailable, run `install_skills`.
3. If both fail, run build-runner generation as a last fallback.

This keeps global skills owned by `iPF_Flutter_Starter_Pack` while still supporting older local package versions.

## Project output

The generated app includes:

- `lib/core/` for theme, routing, extensions, and resources.
- `lib/root/` for the app shell, splash screen, and home screen.
- `lib/features/` for feature modules.
- `lib/shared/providers/` for the generated provider scaffold.
- `lib/shared/widgets/` for project-specific widgets.

## Notes

- Keep generated widgets theme-driven; do not hardcode colors when the theme already provides a value.
- The root repository is a setup tool, not the generated app itself.
- The starter pack owns the shared skill installation; this repo only templates the project-level structure.
