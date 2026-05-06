#!/usr/bin/env bash

set -euo pipefail

# Restore cursor on exit so a Ctrl-C during a menu doesn't leave it hidden.
trap 'tput cnorm 2>/dev/null || true' EXIT INT TERM

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STARTER_PACK_LOCAL_PATH="/Users/danfordchris/projects/iPF_Flutter_Starter_Pack"
STARTER_PACK_GIT_URL="https://github.com/iPFSoftwares/iPF_Flutter_Starter_Pack.git"
DEFAULT_APP_NAME="flutter_app_1"

# ─── Utilities ────────────────────────────────────────────────────────────────

log() { printf '%s\n' "$1"; }
to_lower() { printf '%s' "$1" | tr '[:upper:]' '[:lower:]'; }
die() { printf 'Error: %s\n' "$1" >&2; exit 1; }
is_valid_starter_pack_path() { [[ -f "$1/pubspec.yaml" ]]; }
ensure_directory() { mkdir -p "$1"; }

prompt_with_default() {
  local question="$1" default="$2" answer=""
  read -r -p "$question [$default]: " answer
  printf '%s\n' "${answer:-$default}"
}

prompt_yes_no() {
  local question="$1" default="$2" answer=""
  read -r -p "$question [$default]: " answer
  answer="${answer:-$default}"
  case "$(to_lower "$answer")" in
    y|yes|true|1)  printf 'true\n' ;;
    n|no|false|0)  printf 'false\n' ;;
    *)             printf '%s\n' "$(to_lower "$default")" ;;
  esac
}

# Arrow-key interactive menu. Use ↑/↓ to move, Enter to confirm.
# Result stored in _MENU_RESULT (1-based). All I/O via /dev/tty — never call inside $().
_MENU_RESULT=1
prompt_select() {
  local question="$1"
  local default_index="$2"
  shift 2
  # After shift, $1..$# are the options. ${!i} resolves them by index.
  local count="$#"
  local cur=$(( default_index - 1 ))   # 0-based current index
  local i key ch

  printf '\n%s\n' "$question" >/dev/tty
  printf '\0337' >/dev/tty             # DEC save cursor (ESC 7)

  # Initial draw
  for (( i = 1; i <= count; i++ )); do
    if [[ $(( i - 1 )) -eq $cur ]]; then
      printf '  \033[1;36m> %s\033[0m\033[K\n' "${!i}" >/dev/tty
    else
      printf '    %s\033[K\n' "${!i}" >/dev/tty
    fi
  done

  tput civis >/dev/tty 2>/dev/null || true

  while IFS= read -r -s -n1 key </dev/tty; do
    case "$key" in
      $'\x1b')
        IFS= read -r -s -n1 -t 1 ch </dev/tty || true
        if [[ "$ch" == '[' ]]; then
          IFS= read -r -s -n1 -t 1 ch </dev/tty || true
          case "$ch" in
            A) cur=$(( (cur - 1 + count) % count )) ;;   # up arrow
            B) cur=$(( (cur + 1) % count )) ;;           # down arrow
          esac
        fi
        ;;
      '' | $'\n' | $'\r') break ;;
    esac

    # Restore saved cursor then redraw the list in-place
    printf '\0338' >/dev/tty           # DEC restore cursor (ESC 8)
    for (( i = 1; i <= count; i++ )); do
      if [[ $(( i - 1 )) -eq $cur ]]; then
        printf '  \033[1;36m> %s\033[0m\033[K\n' "${!i}" >/dev/tty
      else
        printf '    %s\033[K\n' "${!i}" >/dev/tty
      fi
    done
  done

  tput cnorm >/dev/tty 2>/dev/null || true
  printf '\n' >/dev/tty

  _MENU_RESULT=$(( cur + 1 ))
}

sanitize_project_name() {
  local v; v="$(to_lower "$1")"
  v="${v// /_}"; v="${v//-/_}"
  v="$(printf '%s' "$v" | tr -cd 'a-z0-9_')"
  v="$(printf '%s' "$v" | tr -s '_')"
  v="${v#_}"; v="${v%_}"
  [[ -z "$v" ]] && die "App name must contain at least one valid character."
  [[ "$v" =~ ^[0-9] ]] && v="flutter_${v}"
  printf '%s\n' "$v"
}

sanitize_package_name() {
  local v; v="$(to_lower "$1")"
  v="${v// /.}"; v="${v//-/.}"
  v="$(printf '%s' "$v" | tr -cd 'a-z0-9_.')"
  v="$(printf '%s' "$v" | tr -s '.')"
  v="${v#.}"; v="${v%.}"
  [[ -z "$v" ]] && die "Package name must contain at least one valid character."
  [[ "$v" != *.* ]] && v="com.${v}.app"
  printf '%s\n' "$v"
}

title_case() {
  printf '%s' "$1" | tr '_-' '  ' | awk '{for(i=1;i<=NF;i++){$i=toupper(substr($i,1,1))substr($i,2)} print}'
}

setup_android_signing() {
  local alias="$1" key_pass="$2" store_pass="$3"
  log "Configuring Android app signing..."

  cat > android/key.properties <<EOF
storePassword=${store_pass}
keyPassword=${key_pass}
keyAlias=${alias}
storeFile=../keystore.jks
EOF

  if command -v keytool &>/dev/null; then
    keytool -genkeypair -v \
      -keystore android/keystore.jks \
      -keyalg RSA -keysize 2048 -validity 10000 \
      -alias "$alias" \
      -dname "CN=$DISPLAY_NAME, O=$PROJECT_NAME, C=US" \
      -storepass "$store_pass" \
      -keypass "$key_pass" \
      >/dev/null 2>&1 \
      && log "  Keystore generated: android/keystore.jks" \
      || log "  Warning: keytool failed — generate android/keystore.jks manually."
  else
    log "  keytool not found — generate android/keystore.jks manually."
  fi

  # Never commit signing secrets
  printf '\n# Signing — never commit\nandroid/key.properties\nandroid/keystore.jks\n' >> .gitignore

  # Patch build.gradle / build.gradle.kts with signing config
  python3 - <<PY
from pathlib import Path
import re

def patch_gradle(path):
    if not path.exists():
        return
    text = path.read_text()
    if 'keystoreProperties' in text:
        return
    kts = path.suffix == '.kts'
    if kts:
        header = ('import java.io.FileInputStream\nimport java.util.Properties\n\n'
                  'val keystoreProperties = Properties()\n'
                  'val keystorePropertiesFile = rootProject.file("key.properties")\n'
                  'if (keystorePropertiesFile.exists()) {\n'
                  '    keystoreProperties.load(FileInputStream(keystorePropertiesFile))\n}\n\n')
        sig = ('\n    signingConfigs {\n'
               '        create("release") {\n'
               '            keyAlias = keystoreProperties["keyAlias"] as String? ?: ""\n'
               '            keyPassword = keystoreProperties["keyPassword"] as String? ?: ""\n'
               '            storeFile = file(keystoreProperties["storeFile"] as String? ?: "keystore.jks")\n'
               '            storePassword = keystoreProperties["storePassword"] as String? ?: ""\n'
               '        }\n'
               '        getByName("debug") {\n'
               '            keyAlias = keystoreProperties["keyAlias"] as String? ?: ""\n'
               '            keyPassword = keystoreProperties["keyPassword"] as String? ?: ""\n'
               '            storeFile = file(keystoreProperties["storeFile"] as String? ?: "keystore.jks")\n'
               '            storePassword = keystoreProperties["storePassword"] as String? ?: ""\n'
               '        }\n    }')
        rel = '\n            signingConfig = signingConfigs.getByName("release")'
        dbg = '\n            signingConfig = signingConfigs.getByName("debug")'
    else:
        header = ("def keystoreProperties = new Properties()\n"
                  "def keystorePropertiesFile = rootProject.file('key.properties')\n"
                  "if (keystorePropertiesFile.exists()) {\n"
                  "    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))\n}\n\n")
        sig = ("\n    signingConfigs {\n"
               "        release {\n"
               "            keyAlias keystoreProperties['keyAlias'] ?: ''\n"
               "            keyPassword keystoreProperties['keyPassword'] ?: ''\n"
               "            storeFile file(keystoreProperties['storeFile'] ?: 'keystore.jks')\n"
               "            storePassword keystoreProperties['storePassword'] ?: ''\n"
               "        }\n"
               "        debug {\n"
               "            keyAlias keystoreProperties['keyAlias'] ?: ''\n"
               "            keyPassword keystoreProperties['keyPassword'] ?: ''\n"
               "            storeFile file(keystoreProperties['storeFile'] ?: 'keystore.jks')\n"
               "            storePassword keystoreProperties['storePassword'] ?: ''\n"
               "        }\n    }")
        rel = "\n            signingConfig signingConfigs.release"
        dbg = "\n            signingConfig signingConfigs.debug"

    text = header + text
    text = re.sub(r'(android\s*\{)', r'\1' + sig, text, count=1)
    # inject signingConfig into release buildType
    text = re.sub(r'(release\s*\{)', r'\1' + rel, text, count=1)
    # inject signingConfig into debug buildType
    text = re.sub(r'(debug\s*\{)', r'\1' + dbg, text, count=1)
    path.write_text(text)

for f in ['android/app/build.gradle', 'android/app/build.gradle.kts']:
    patch_gradle(Path(f))
print("  build.gradle signing config applied.")
PY
}

run_skill_initializer() {
  log "Initializing starter-pack skills..."
  # Suppress all output — dart run uses dart pub which errors on Flutter-only sdks
  # when the dart binary is not the Flutter-bundled one.
  if dart run ipf_flutter_starter_pack:initialize_skills >/dev/null 2>&1; then
    log "  Skills initialized."
    return 0
  fi
  if dart run ipf_flutter_starter_pack:install_skills >/dev/null 2>&1; then
    log "  Skills installed."
    return 0
  fi
  log "  Skill initializer unavailable. Run 'make initialize_skills' after setup."
}

# Run build_runner in a Flutter-SDK-aware context.
run_build_runner() {
  if dart run build_runner build --delete-conflicting-outputs >/dev/null 2>&1; then
    return 0
  fi
  # Fallback: flutter pub run has the Flutter SDK in scope even when dart does not.
  flutter pub run build_runner build --delete-conflicting-outputs
}

# ─── Prompts ──────────────────────────────────────────────────────────────────

APP_NAME_DEFAULT="${1:-$DEFAULT_APP_NAME}"
APP_NAME_RAW="$(prompt_with_default "App name" "$APP_NAME_DEFAULT")"
PROJECT_NAME="$(sanitize_project_name "$APP_NAME_RAW")"
DEFAULT_DERIVED_PACKAGE="com.${PROJECT_NAME}.app"
PACKAGE_NAME_RAW="$(prompt_with_default "Package name" "$DEFAULT_DERIVED_PACKAGE")"
PACKAGE_NAME="$(sanitize_package_name "$PACKAGE_NAME_RAW")"

prompt_select "State management:" 1 "provider" "riverpod" "bloc"
case "$_MENU_RESULT" in
  1) STATE_MANAGEMENT="provider" ;;
  2) STATE_MANAGEMENT="riverpod" ;;
  3) STATE_MANAGEMENT="bloc" ;;
  *) STATE_MANAGEMENT="provider" ;;
esac

prompt_select "Navigator:" 1 "go_router" "navigator 2.0" "auto_route"
case "$_MENU_RESULT" in
  1) NAVIGATOR="go_router" ;;
  2) NAVIGATOR="navigator_2_0" ;;
  3) NAVIGATOR="auto_route" ;;
  *) NAVIGATOR="go_router" ;;
esac

APP_SIGNING="$(prompt_yes_no "Enable app signing (debug + release)" "false")"

KEY_ALIAS=""
KEY_PASSWORD=""
KEYSTORE_PASSWORD=""
if [[ "$APP_SIGNING" == "true" ]]; then
  KEY_ALIAS="$(prompt_with_default "Signing key alias" "upload")"
  printf 'Key password (input hidden): ' >/dev/tty
  IFS= read -r -s KEY_PASSWORD </dev/tty; printf '\n' >/dev/tty
  printf 'Keystore password (input hidden): ' >/dev/tty
  IFS= read -r -s KEYSTORE_PASSWORD </dev/tty; printf '\n' >/dev/tty
  if [[ -z "$KEY_PASSWORD" || -z "$KEYSTORE_PASSWORD" ]]; then
    die "Key password and keystore password are required when signing is enabled."
  fi
fi

DISPLAY_NAME="$(title_case "$PROJECT_NAME")"
PROJECT_ORG="$(printf '%s' "$PACKAGE_NAME" | awk -F'.' '{print $1"."$2}')"
GENERATED_IDENTIFIER="${PROJECT_ORG}.${PROJECT_NAME}"

[[ -e "$PROJECT_NAME" ]] && die "Directory '$PROJECT_NAME' already exists. Remove it or choose a different name."

log ""
log "=========================================="
log "Creating:  $PROJECT_NAME"
log "Package:   $PACKAGE_NAME"
log "State:     $STATE_MANAGEMENT"
log "Navigator: $NAVIGATOR"
log "Signing:   $APP_SIGNING"
log "=========================================="

# ─── Create Flutter project ────────────────────────────────────────────────────

flutter create --org "$PROJECT_ORG" --platforms android,ios,web,macos,windows,linux "$PROJECT_NAME"
cd "$PROJECT_NAME"

# ─── Install packages ──────────────────────────────────────────────────────────

log "Installing packages..."

case "$STATE_MANAGEMENT" in
  provider)
    flutter pub add provider
    ;;
  riverpod)
    flutter pub add flutter_riverpod
    ;;
  bloc)
    # Pin modern versions — prevents pub resolving to old bloc 1.x that circularly depends on flutter_bloc
    flutter pub add 'flutter_bloc:^9.0.0' 'equatable:^2.0.0'
    ;;
esac

case "$NAVIGATOR" in
  go_router)
    flutter pub add go_router
    ;;
  auto_route)
    flutter pub add auto_route
    flutter pub add --dev auto_route_generator
    ;;
esac

# build_runner is always available as a dev dep (skill initializer fallback needs it)
flutter pub add --dev build_runner

log "Installing ipf_flutter_starter_pack..."
if is_valid_starter_pack_path "$STARTER_PACK_LOCAL_PATH"; then
  log "  Using local path: $STARTER_PACK_LOCAL_PATH"
  if ! flutter pub add ipf_flutter_starter_pack --path "$STARTER_PACK_LOCAL_PATH" 2>/dev/null; then
    log "  Local path failed. Falling back to git."
    flutter pub add ipf_flutter_starter_pack --git-url "$STARTER_PACK_GIT_URL" --git-ref develop
  fi
else
  log "  Local path invalid. Using git."
  flutter pub add ipf_flutter_starter_pack --git-url "$STARTER_PACK_GIT_URL" --git-ref develop
fi

flutter pub add toastification
flutter pub get

log "Running skill initializer..."
run_skill_initializer

# ─── Folder structure ──────────────────────────────────────────────────────────

log "Creating folder structure..."
for dir in \
  lib/core/constants lib/core/extensions lib/core/mixins \
  lib/core/resources lib/core/router lib/core/theme lib/core/utils \
  lib/features/auth/{models,providers,screens,services,widgets} \
  lib/features/home/{models,providers,screens,services,widgets} \
  lib/features/markets/{models,providers,screens,services,widgets} \
  lib/features/my_story/{models,providers,screens,services,widgets} \
  lib/features/notifications/{models,providers,screens,services,widgets} \
  lib/features/orders/{models,providers,screens,services,widgets} \
  lib/features/profile/{models,providers,screens,services,widgets} \
  lib/features/updates/{models,providers,screens,services,widgets} \
  lib/l10n lib/root lib/services \
  lib/shared/providers lib/shared/widgets \
  assets/fonts assets/images assets/svgs \
  .claude/commands .claude/skills; do
  ensure_directory "$dir"
done

# ─── Core: theme ──────────────────────────────────────────────────────────────

log "Writing scaffold files..."

cat > lib/core/theme/app_theme.dart <<'EOF'
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color _seedColor = Color(0xFF0F766E);

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
        ),
      );
}
EOF

# ─── Core: resources ──────────────────────────────────────────────────────────

cat > lib/core/resources/resources.dart <<'EOF'
library resources;

export 'app_assets.dart';
EOF

cat > lib/core/resources/app_assets.dart <<'EOF'
class AppAssets {
  AppAssets._();

  static const String logo = 'assets/images/logo.png';
  static const String emptyState = 'assets/images/empty_state.png';
}
EOF

# ─── Core: extensions ─────────────────────────────────────────────────────────

if [[ "$NAVIGATOR" == "go_router" ]]; then
  cat > lib/core/extensions/build_context_extension.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension BuildContextExtension on BuildContext {
  GoRouterState get goRouterState => GoRouterState.of(this);
  ThemeData get themeData => Theme.of(this);
  ColorScheme get colorScheme => themeData.colorScheme;
  TextTheme get textTheme => themeData.textTheme;
  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;
}
EOF
else
  cat > lib/core/extensions/build_context_extension.dart <<'EOF'
import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  ThemeData get themeData => Theme.of(this);
  ColorScheme get colorScheme => themeData.colorScheme;
  TextTheme get textTheme => themeData.textTheme;
  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;
}
EOF
fi

# ─── Navigator: router + splash ───────────────────────────────────────────────

if [[ "$NAVIGATOR" == "go_router" ]]; then

  cat > lib/core/router/router.dart <<'EOF'
import 'package:go_router/go_router.dart';

import '../../root/home_screen.dart';
import '../../root/splash_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    ],
  );
}
EOF

  cat > lib/root/splash_screen.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (mounted) context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(
                Icons.flutter_dash_rounded,
                size: 56,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 20),
            Text('Loading…', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
EOF

elif [[ "$NAVIGATOR" == "navigator_2_0" ]]; then

  cat > lib/core/router/routes.dart <<'EOF'
abstract class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
}
EOF

  cat > lib/root/splash_screen.dart <<'EOF'
import 'package:flutter/material.dart';

import '../core/router/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(
                Icons.flutter_dash_rounded,
                size: 56,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 20),
            Text('Loading…', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
EOF

elif [[ "$NAVIGATOR" == "auto_route" ]]; then

  cat > lib/core/router/router.dart <<'EOF'
import 'package:auto_route/auto_route.dart';

import '../../root/home_screen.dart';
import '../../root/splash_screen.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, path: '/', initial: true),
        AutoRoute(page: HomeRoute.page, path: '/home'),
      ];
}
EOF

  cat > lib/root/splash_screen.dart <<'EOF'
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (mounted) context.router.pushNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(
                Icons.flutter_dash_rounded,
                size: 56,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 20),
            Text('Loading…', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
EOF

fi

# ─── Home screen ──────────────────────────────────────────────────────────────

if [[ "$NAVIGATOR" == "auto_route" ]]; then
  cat > lib/root/home_screen.dart <<'EOF'
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Project scaffold ready',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(
                  'Add screens, providers, and services under lib/features.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
EOF
else
  cat > lib/root/home_screen.dart <<'EOF'
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Project scaffold ready',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(
                  'Add screens, providers, and services under lib/features.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
EOF
fi

# ─── State management files ───────────────────────────────────────────────────

if [[ "$STATE_MANAGEMENT" == "provider" ]]; then

  cat > lib/shared/providers/app_provider.dart <<'EOF'
import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode value) {
    if (_themeMode == value) return;
    _themeMode = value;
    notifyListeners();
  }
}
EOF

  cat > lib/shared/providers/providers.dart <<'EOF'
import 'package:provider/provider.dart';

import 'app_provider.dart';

final List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider(create: (_) => AppProvider()),
];
EOF

elif [[ "$STATE_MANAGEMENT" == "riverpod" ]]; then

  cat > lib/shared/providers/app_notifier.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void setThemeMode(ThemeMode mode) => state = mode;
}

final appNotifierProvider = NotifierProvider<AppNotifier, ThemeMode>(
  AppNotifier.new,
);
EOF

elif [[ "$STATE_MANAGEMENT" == "bloc" ]]; then

  ensure_directory lib/shared/bloc

  cat > lib/shared/bloc/app_event.dart <<'EOF'
part of 'app_bloc.dart';

abstract class AppEvent {}

class AppThemeModeChanged extends AppEvent {
  AppThemeModeChanged(this.themeMode);
  final ThemeMode themeMode;
}
EOF

  cat > lib/shared/bloc/app_state.dart <<'EOF'
part of 'app_bloc.dart';

class AppState extends Equatable {
  const AppState({this.themeMode = ThemeMode.system});

  final ThemeMode themeMode;

  AppState copyWith({ThemeMode? themeMode}) =>
      AppState(themeMode: themeMode ?? this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}
EOF

  cat > lib/shared/bloc/app_bloc.dart <<'EOF'
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState()) {
    on<AppThemeModeChanged>(
      (event, emit) => emit(state.copyWith(themeMode: event.themeMode)),
    );
  }
}
EOF

fi

# ─── app.dart (matrix: state × navigator) ────────────────────────────────────

if [[ "$STATE_MANAGEMENT" == "provider" && "$NAVIGATOR" == "go_router" ]]; then
  cat > lib/root/app.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/router/router.dart';
import '../core/theme/app_theme.dart';
import '../shared/providers/app_provider.dart';
import '../shared/providers/providers.dart';

class ProjectApp extends StatelessWidget {
  const ProjectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: Builder(
        builder: (ctx) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          themeMode: ctx.watch<AppProvider>().themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
EOF

elif [[ "$STATE_MANAGEMENT" == "provider" && "$NAVIGATOR" == "navigator_2_0" ]]; then
  cat > lib/root/app.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/router/routes.dart';
import '../core/theme/app_theme.dart';
import '../shared/providers/app_provider.dart';
import '../shared/providers/providers.dart';
import 'home_screen.dart';
import 'splash_screen.dart';

class ProjectApp extends StatelessWidget {
  const ProjectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: Builder(
        builder: (ctx) => MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: ctx.watch<AppProvider>().themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          initialRoute: AppRoutes.splash,
          routes: {
            AppRoutes.splash: (_) => const SplashScreen(),
            AppRoutes.home: (_) => const HomeScreen(),
          },
        ),
      ),
    );
  }
}
EOF

elif [[ "$STATE_MANAGEMENT" == "provider" && "$NAVIGATOR" == "auto_route" ]]; then
  cat > lib/root/app.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/router/router.dart';
import '../core/theme/app_theme.dart';
import '../shared/providers/app_provider.dart';
import '../shared/providers/providers.dart';

class ProjectApp extends StatefulWidget {
  const ProjectApp({super.key});

  @override
  State<ProjectApp> createState() => _ProjectAppState();
}

class _ProjectAppState extends State<ProjectApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: Builder(
        builder: (ctx) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          themeMode: ctx.watch<AppProvider>().themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          routerConfig: _appRouter.config(),
        ),
      ),
    );
  }
}
EOF

elif [[ "$STATE_MANAGEMENT" == "riverpod" && "$NAVIGATOR" == "go_router" ]]; then
  cat > lib/root/app.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/router/router.dart';
import '../core/theme/app_theme.dart';
import '../shared/providers/app_notifier.dart';

class ProjectApp extends ConsumerWidget {
  const ProjectApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appNotifierProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}
EOF

elif [[ "$STATE_MANAGEMENT" == "riverpod" && "$NAVIGATOR" == "navigator_2_0" ]]; then
  cat > lib/root/app.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/router/routes.dart';
import '../core/theme/app_theme.dart';
import '../shared/providers/app_notifier.dart';
import 'home_screen.dart';
import 'splash_screen.dart';

class ProjectApp extends ConsumerWidget {
  const ProjectApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appNotifierProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
      },
    );
  }
}
EOF

elif [[ "$STATE_MANAGEMENT" == "riverpod" && "$NAVIGATOR" == "auto_route" ]]; then
  cat > lib/root/app.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/router/router.dart';
import '../core/theme/app_theme.dart';
import '../shared/providers/app_notifier.dart';

class ProjectApp extends ConsumerStatefulWidget {
  const ProjectApp({super.key});

  @override
  ConsumerState<ProjectApp> createState() => _ProjectAppState();
}

class _ProjectAppState extends ConsumerState<ProjectApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(appNotifierProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: _appRouter.config(),
    );
  }
}
EOF

elif [[ "$STATE_MANAGEMENT" == "bloc" && "$NAVIGATOR" == "go_router" ]]; then
  cat > lib/root/app.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/router/router.dart';
import '../core/theme/app_theme.dart';
import '../shared/bloc/app_bloc.dart';

class ProjectApp extends StatelessWidget {
  const ProjectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppBloc(),
      child: BlocBuilder<AppBloc, AppState>(
        buildWhen: (prev, curr) => prev.themeMode != curr.themeMode,
        builder: (_, state) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          themeMode: state.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
EOF

elif [[ "$STATE_MANAGEMENT" == "bloc" && "$NAVIGATOR" == "navigator_2_0" ]]; then
  cat > lib/root/app.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/router/routes.dart';
import '../core/theme/app_theme.dart';
import '../shared/bloc/app_bloc.dart';
import 'home_screen.dart';
import 'splash_screen.dart';

class ProjectApp extends StatelessWidget {
  const ProjectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppBloc(),
      child: BlocBuilder<AppBloc, AppState>(
        buildWhen: (prev, curr) => prev.themeMode != curr.themeMode,
        builder: (_, state) => MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: state.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          initialRoute: AppRoutes.splash,
          routes: {
            AppRoutes.splash: (_) => const SplashScreen(),
            AppRoutes.home: (_) => const HomeScreen(),
          },
        ),
      ),
    );
  }
}
EOF

elif [[ "$STATE_MANAGEMENT" == "bloc" && "$NAVIGATOR" == "auto_route" ]]; then
  cat > lib/root/app.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/router/router.dart';
import '../core/theme/app_theme.dart';
import '../shared/bloc/app_bloc.dart';

class ProjectApp extends StatefulWidget {
  const ProjectApp({super.key});

  @override
  State<ProjectApp> createState() => _ProjectAppState();
}

class _ProjectAppState extends State<ProjectApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppBloc(),
      child: BlocBuilder<AppBloc, AppState>(
        buildWhen: (prev, curr) => prev.themeMode != curr.themeMode,
        builder: (_, state) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          themeMode: state.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          routerConfig: _appRouter.config(),
        ),
      ),
    );
  }
}
EOF

fi

# ─── main.dart ────────────────────────────────────────────────────────────────

if [[ "$STATE_MANAGEMENT" == "provider" ]]; then
  cat > lib/main.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import 'package:provider/provider.dart';

import 'root/app.dart';
import 'shared/providers/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await AppDatabase.instance.init();
  AppNotificationService.instance.init();
  runApp(
    MultiProvider(
      providers: appProviders,
      child: const ProjectApp(),
    ),
  );
}
EOF

elif [[ "$STATE_MANAGEMENT" == "riverpod" ]]; then
  cat > lib/main.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';

import 'root/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await AppDatabase.instance.init();
  AppNotificationService.instance.init();
  runApp(
    const ProviderScope(
      child: ProjectApp(),
    ),
  );
}
EOF

elif [[ "$STATE_MANAGEMENT" == "bloc" ]]; then
  cat > lib/main.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';

import 'root/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await AppDatabase.instance.init();
  AppNotificationService.instance.init();
  runApp(const ProjectApp());
}
EOF

fi

# ─── Shared widgets README ────────────────────────────────────────────────────

cat > lib/shared/widgets/README.md <<'EOF'
# Shared Widgets

Place project-specific shared widgets here.
Use Theme.of(context).colorScheme — never hardcode colors.
EOF

# ─── Static config files ──────────────────────────────────────────────────────

cat > .env <<EOF
APP_NAME=$PROJECT_NAME
PACKAGE_NAME=$PACKAGE_NAME
STATE_MANAGEMENT=$STATE_MANAGEMENT
NAVIGATOR=$NAVIGATOR
APP_SIGNING=$APP_SIGNING
EOF

cat > .env.example <<EOF
APP_NAME=$PROJECT_NAME
PACKAGE_NAME=$PACKAGE_NAME
STATE_MANAGEMENT=$STATE_MANAGEMENT
NAVIGATOR=$NAVIGATOR
APP_SIGNING=$APP_SIGNING
EOF

cat > lib/l10n/app_en.arb <<EOF
{
  "@@locale": "en",
  "appName": "$DISPLAY_NAME"
}
EOF

cat > AGENTS.md <<EOF
# Project Agent Guide

This app was scaffolded with \`ipf_flutter_starter_pack\`.

## Project Facts

- App name: $DISPLAY_NAME
- Project folder: $PROJECT_NAME
- Package name: $PACKAGE_NAME
- State management: $STATE_MANAGEMENT
- Navigator: $NAVIGATOR
- App signing: $APP_SIGNING

## Architecture Flow

\`screen/widget → provider/notifier/bloc → service → APIManager → model\`

## Rules

- Use \`ipf_flutter_starter_pack\` for package-level skills, helpers, and shared infra.
- Keep widgets theme-driven; use colorScheme values — never hardcode colors.
- Use \`APIManager\` for all network work.
- Keep new feature code under \`lib/features/<feature>/\`.
- Project commands live in \`.claude/commands\`.

## Validation

Run \`flutter analyze\` after non-trivial changes.
EOF

cat > CLAUDE.md <<EOF
# Project Guide

## What This Project Is

\`$DISPLAY_NAME\` is a Flutter app scaffolded with \`ipf_flutter_starter_pack\`.

## Conventions

- State management: \`$STATE_MANAGEMENT\`
- Navigator: \`$NAVIGATOR\`
- Theme colors live in \`lib/core/theme\` — always consume via \`ThemeData\` and \`ColorScheme\`.
- Use \`APIManager\` for service calls.
- Feature-based layout: screens, providers/notifiers/blocs, services, models per feature.

## Project Structure

- \`lib/core/\`: theme, router, resources, utilities, extensions
- \`lib/root/\`: app shell, splash, home
- \`lib/features/\`: feature modules
- \`lib/shared/\`: global state and reusable widgets
- \`.claude/commands/\`: project-level workflow docs
- \`.claude/skills/\`: starter-pack skill docs

## Setup Notes

- Android: network permissions and core library desugaring are configured.
- iOS: bundle identifier and display name are set.
- Only \`ipf_flutter_starter_pack\` is supported — not \`flutter_pack\`.
EOF

cat > README.md <<EOF
# $DISPLAY_NAME

Flutter project generated by the local setup script.

## Configuration

| Key | Value |
|-----|-------|
| Package | \`$PACKAGE_NAME\` |
| State management | \`$STATE_MANAGEMENT\` |
| Navigator | \`$NAVIGATOR\` |
| App signing | \`$APP_SIGNING\` |

## Run

\`\`\`bash
flutter pub get
flutter run
\`\`\`

## Project layout

- \`lib/core/\` — theme, routing, extensions, resources
- \`lib/root/\` — app shell and entry screens
- \`lib/features/\` — feature modules
- \`lib/shared/\` — global state and reusable widgets
EOF

cat > Makefile <<'MAKEFILE_EOF'
.PHONY: help clean get upgrade run analyze format test coverage doctor setup initialize_skills install_skills code_gen feature

help:
	@echo "Available commands:"
	@echo "  make setup               - Initial project setup"
	@echo "  make initialize_skills   - Initialize starter-pack skills"
	@echo "  make install_skills      - Alias for initialize_skills"
	@echo "  make code_gen            - Run build_runner code generation"
	@echo "  make feature name=<name> - Create a feature folder scaffold"
	@echo "  make clean               - Clean and reinstall dependencies"
	@echo "  make get                 - Get dependencies"
	@echo "  make upgrade             - Upgrade dependencies"
	@echo "  make run                 - Run the app"
	@echo "  make analyze             - Analyze code"
	@echo "  make format              - Format code"
	@echo "  make test                - Run tests"
	@echo "  make coverage            - Run tests with coverage"
	@echo "  make doctor              - Run flutter doctor"

clean:
	flutter clean
	flutter pub get

get:
	flutter pub get

upgrade:
	flutter pub upgrade

run:
	flutter run

analyze:
	flutter analyze

format:
	dart format lib/ test/

test:
	flutter test

coverage:
	flutter test --coverage

doctor:
	flutter doctor -v

initialize_skills:
	dart run ipf_flutter_starter_pack:initialize_skills || dart run ipf_flutter_starter_pack:install_skills

install_skills: initialize_skills

code_gen:
	dart run build_runner build --delete-conflicting-outputs || \
	  flutter pub run build_runner build --delete-conflicting-outputs

setup:
	flutter clean
	flutter pub get
	@$(MAKE) initialize_skills

feature:
ifndef name
	@echo "Error: provide a feature name. Usage: make feature name=<feature_name>"
	@exit 1
endif
	@mkdir -p lib/features/$(name)/models lib/features/$(name)/providers lib/features/$(name)/screens lib/features/$(name)/services lib/features/$(name)/widgets
	@echo "Created lib/features/$(name)/"
MAKEFILE_EOF

# ─── Copy project-level assets ────────────────────────────────────────────────

cp -R "$SCRIPT_DIR/commands/." .claude/commands/
cp -R "$SCRIPT_DIR/skills/." .claude/skills/
cp -R "$SCRIPT_DIR/widgets/." lib/shared/widgets/

# ─── Platform configuration ───────────────────────────────────────────────────

log "Applying platform configuration..."
python3 - "$GENERATED_IDENTIFIER" "$PACKAGE_NAME" "$DISPLAY_NAME" <<'PY'
from pathlib import Path
import re
import sys

generated_identifier = sys.argv[1]
package_name = sys.argv[2]
display_name = sys.argv[3]


def patch_text(path: Path, transform):
    if not path.exists():
        return
    original = path.read_text()
    updated = transform(original)
    if updated != original:
        path.write_text(updated)


pubspec = Path('pubspec.yaml')
if pubspec.exists():
    def transform_pubspec(text: str) -> str:
        if 'assets/images/' not in text:
            text = re.sub(
                r'(flutter:\s*\n\s*uses-material-design:\s*true\s*)',
                r'\1\n  assets:\n    - assets/images/\n    - assets/svgs/\n    - assets/fonts/\n    - .env\n',
                text,
                count=1,
            )
        return text
    patch_text(pubspec, transform_pubspec)

manifest = Path('android/app/src/main/AndroidManifest.xml')
if manifest.exists():
    def transform_manifest(text: str) -> str:
        if 'android.permission.INTERNET' not in text:
            text = re.sub(
                r'(<manifest[^>]*>)',
                r'\1\n    <uses-permission android:name="android.permission.INTERNET" />\n    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />',
                text,
                count=1,
            )
        return text.replace(generated_identifier, package_name)
    patch_text(manifest, transform_manifest)

strings_xml = Path('android/app/src/main/res/values/strings.xml')
if strings_xml.exists():
    def transform_strings(text: str) -> str:
        if '<string name="app_name">' in text:
            text = re.sub(
                r'(<string name="app_name">)([^<]*)</string>',
                rf'\1{display_name}</string>',
                text,
                count=1,
            )
        return text
    patch_text(strings_xml, transform_strings)

for file_name in ('android/app/build.gradle', 'android/app/build.gradle.kts'):
    path = Path(file_name)
    if not path.exists():
        continue

    def transform_gradle(text: str, _path=path) -> str:
        text = text.replace(f'namespace = "{generated_identifier}"', f'namespace = "{package_name}"')
        text = text.replace(f'applicationId = "{generated_identifier}"', f'applicationId = "{package_name}"')
        text = text.replace(f'namespace "{generated_identifier}"', f'namespace "{package_name}"')
        text = text.replace(f'applicationId "{generated_identifier}"', f'applicationId "{package_name}"')
        if 'isCoreLibraryDesugaringEnabled = true' not in text and 'coreLibraryDesugaringEnabled true' not in text:
            text = text.replace('compileOptions {', 'compileOptions {\n        isCoreLibraryDesugaringEnabled = true', 1)
        if 'coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")' not in text and 'coreLibraryDesugaring "com.android.tools:desugar_jdk_libs:2.1.4"' not in text:
            text = text.replace('dependencies {', 'dependencies {\n    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")', 1)
        if str(_path) != 'android/app/build.gradle.kts' and 'isCoreLibraryDesugaringEnabled = true' in text:
            text = text.replace('isCoreLibraryDesugaringEnabled = true', 'coreLibraryDesugaringEnabled true')
        return text

    patch_text(path, transform_gradle)

plist = Path('ios/Runner/Info.plist')
if plist.exists():
    def transform_plist(text: str) -> str:
        if '<key>CFBundleDisplayName</key>' in text:
            text = re.sub(
                r'(<key>CFBundleDisplayName</key>\s*<string>)([^<]*)</string>',
                rf'\1{display_name}</string>',
                text,
                count=1,
            )
        else:
            text = text.replace('<dict>', '<dict>\n\t<key>CFBundleDisplayName</key>\n\t<string>' + display_name + '</string>', 1)
        if '<key>NSAppTransportSecurity</key>' not in text:
            text = text.replace(
                '<dict>',
                '<dict>\n\t<key>NSAppTransportSecurity</key>\n\t<dict>\n\t\t<key>NSAllowsArbitraryLoads</key>\n\t\t<false/>\n\t</dict>',
                1,
            )
        return text.replace(generated_identifier, package_name)
    patch_text(plist, transform_plist)
PY

# ─── auto_route code generation ───────────────────────────────────────────────

if [[ "$NAVIGATOR" == "auto_route" ]]; then
  log "Generating auto_route route classes..."
  run_build_runner
fi

# ─── Android signing setup ────────────────────────────────────────────────────

if [[ "$APP_SIGNING" == "true" ]]; then
  setup_android_signing "$KEY_ALIAS" "$KEY_PASSWORD" "$KEYSTORE_PASSWORD"
fi

log ""
log "=========================================="
log "Project '$PROJECT_NAME' created successfully!"
log "=========================================="
log ""
log "Next steps:"
log "  cd $PROJECT_NAME"
log "  make run"
log "  make analyze"
