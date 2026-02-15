#!/bin/bash

# Flutter Project Structure Initialization Script
# This script creates a complete Flutter project with the specified folder structure

set -e  # Exit on error

PROJECT_NAME="$1"

if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: ./init_flutter_project.sh <project_name>"
    exit 1
fi

echo "=========================================="
echo "Creating Flutter Project: $PROJECT_NAME"
echo "=========================================="

# Create Flutter project
flutter create "$PROJECT_NAME"


# Navigate into project
cd "$PROJECT_NAME"

echo ""
echo "Installing required packages..."
flutter pub add go_router
flutter pub add flutter_pack
flutter pub get

echo "Adding dotenv support..."
flutter pub add flutter_dotenv

echo "Injecting assets into existing flutter section..."

awk '
/uses-material-design: true/ && !x {
    print;
    print "";
    print "  assets:";
    print "    - assets/images/";
    print "    - assets/svgs/";
    print "    - assets/fonts/";
    print "    - .env";
    x=1;
    next
}
{print}
' pubspec.yaml > pubspec.tmp && mv pubspec.tmp pubspec.yaml

echo "Updating pubspec.yaml with flutter_intl..."
cat >> pubspec.yaml << 'EOF'

flutter_intl:
  enabled: true
EOF

echo ""
echo "Creating folder structure..."

# Create core directories
mkdir -p lib/core/constants
mkdir -p lib/core/extensions
mkdir -p lib/core/mixins
mkdir -p lib/core/resources
mkdir -p lib/core/theme
mkdir -p lib/core/utils

# Create feature directories
mkdir -p lib/features

# Create dao directory
mkdir -p lib/dao

# Create l10n directory with ARB files
mkdir -p lib/l10n

# Create root directory
mkdir -p lib/root

# Create services directory
mkdir -p lib/services

# Create shared directories
mkdir -p lib/shared/components
mkdir -p lib/shared/controllers

# Create assets directories
mkdir -p assets/fonts
mkdir -p assets/images
mkdir -p assets/svgs

# Create test directory (already exists but ensure it's there)
mkdir -p test


echo ""
echo "Creating extension files..."

cat > lib/core/extensions/build_context_extension.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension BuildContextExtension on BuildContext {
  GoRouterState get goRouterState => GoRouterState.of(this);
  String? get currentRoute => goRouterState.fullPath;

  ThemeData get themeData => Theme.of(this);

  ColorScheme get colorScheme => themeData.colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  TextStyle get displayLarge => textTheme.displayLarge!;
  TextStyle get displayMedium => textTheme.displayMedium!;
  TextStyle get displaySmall => textTheme.displaySmall!;

  TextStyle get headlineLarge => textTheme.headlineLarge!;
  TextStyle get headlineMedium => textTheme.headlineMedium!;
  TextStyle get headlineSmall => textTheme.headlineSmall!;

  TextStyle get titleLarge => textTheme.titleLarge!;
  TextStyle get titleMedium => textTheme.titleMedium!;
  TextStyle get titleSmall => textTheme.titleSmall!;

  TextStyle get bodyLarge => textTheme.bodyLarge!;
  TextStyle get bodyMedium => textTheme.bodyMedium!;
  TextStyle get bodySmall => textTheme.bodySmall!;

  TextStyle get labelLarge => textTheme.labelLarge!;
  TextStyle get labelMedium => textTheme.labelMedium!;
  TextStyle get labelSmall => textTheme.labelSmall!;

  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
}
EOF

echo ""
echo "Creating core resource files..."

# Create core resource files
cat > lib/core/resources/resources.dart << 'EOF'
/// Main resources file that exports all resource files
library resources;

export 'app_fonts.dart';
export 'images.dart';
export 'svgs.dart';
EOF

cat > lib/core/resources/app_fonts.dart << 'EOF'
/// App fonts resources
class AppFonts {
  AppFonts._();

  // Add your font family names here
  // Example:
  // static const String roboto = 'Roboto';
  // static const String openSans = 'OpenSans';
}
EOF

cat > lib/core/resources/images.dart << 'EOF'
/// Image assets resources
class Images {
  Images._();

  // Add your image asset paths here
  // Example:
  // static const String logo = 'assets/images/logo.png';
  // static const String placeholder = 'assets/images/placeholder.png';
}
EOF

cat > lib/core/resources/svgs.dart << 'EOF'
/// SVG assets resources
class Svgs {
  Svgs._();

  // Add your SVG asset paths here
  // Example:
  // static const String iconHome = 'assets/svgs/icon_home.svg';
  // static const String iconProfile = 'assets/svgs/icon_profile.svg';
}
EOF

echo ""
echo "Creating theme files..."

cat > lib/core/theme/app_theme.dart << 'EOF'
import 'package:flutter/material.dart';
import 'custom_colors.dart';

/// Application theme configuration
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: CustomColors.primary,
        brightness: Brightness.light,
      ),
      // Add your custom theme configuration here
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: CustomColors.primary,
        brightness: Brightness.dark,
      ),
      // Add your custom theme configuration here
    );
  }
}
EOF

cat > lib/core/theme/custom_colors.dart << 'EOF'
import 'package:flutter/material.dart';

/// Custom color definitions for the app
class CustomColors {
  CustomColors._();

  // Primary colors
  static const Color primary = Color(0xFF6200EE);
  static const Color primaryVariant = Color(0xFF3700B3);
  static const Color secondary = Color(0xFF03DAC6);

  // Add more custom colors here
}
EOF

echo ""
echo "Creating l10n files..."

cat > lib/l10n/intl_en.arb << 'EOF'
{
  "@@locale": "en",
  "appTitle": "My App",
  "@appTitle": {
    "description": "The title of the application"
  }
}
EOF

cat > lib/l10n/intl_ar.arb << 'EOF'
{
  "@@locale": "ar",
  "appTitle": "تطبيقي",
  "@appTitle": {
    "description": "The title of the application"
  }
}
EOF

cat > lib/l10n/intl_es.arb << 'EOF'
{
  "@@locale": "es",
  "appTitle": "Mi Aplicación",
  "@appTitle": {
    "description": "The title of the application"
  }
}
EOF

cat > lib/l10n/intl_fr.arb << 'EOF'
{
  "@@locale": "fr",
  "appTitle": "Mon Application",
  "@appTitle": {
    "description": "The title of the application"
  }
}
EOF

cat > lib/l10n/intl_sw.arb << 'EOF'
{
  "@@locale": "sw",
  "appTitle": "Programu Yangu",
  "@appTitle": {
    "description": "The title of the application"
  }
}
EOF

echo ""
echo "Creating splash screen..."

cat > lib/root/splash_screen.dart << 'EOF'
import 'package:flutter/material.dart';

/// Splash screen widget
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      // Navigate to your home screen
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your logo here
            const FlutterLogo(size: 100),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
EOF

echo ""
echo "Creating .env file..."
cat > .env << 'EOF'
# Environment variables
API_BASE_URL=https://api.example.com
APP_ENV=development
EOF

echo "Creating .gitkeep files..."

# Create .gitkeep files for empty directories
touch lib/core/constants/.gitkeep
touch lib/core/extensions/.gitkeep
touch lib/core/mixins/.gitkeep
touch lib/core/utils/.gitkeep
touch lib/dao/.gitkeep
touch lib/features/.gitkeep
touch lib/services/.gitkeep
touch lib/shared/components/.gitkeep
touch lib/shared/controllers/.gitkeep
touch assets/fonts/.gitkeep
touch assets/images/.gitkeep
touch assets/svgs/.gitkeep

echo ""
echo "Copying Makefile..."

# Create the Makefile
cat > Makefile << 'MAKEFILE_EOF'
# Makefile for Flutter Project
# Usage: make <command>
# Examples: make clean, make install, make create_apk, make code_gen, make feature name=auth

.PHONY: help clean install apk apk_debug code_gen feature run build_runner watch get upgrade outdated analyze format test coverage doctor

# Default target - show help
help:
	@echo "Available commands:"
	@echo "  make clean          - Clean project and get dependencies"
	@echo "  make install        - Install app on connected device"
	@echo "  make apk            - Build release APK and open folder"
	@echo "  make apk_debug      - Build debug APK and open folder"
	@echo "  make code_gen        - Run IPF generator"
	@echo "  make feature name=<feature_name> - Generate new feature structure"
	@echo "  make run            - Run the app"
	@echo "  make build_runner   - Run build_runner once"
	@echo "  make watch          - Run build_runner in watch mode"
	@echo "  make get            - Get dependencies"
	@echo "  make upgrade        - Upgrade dependencies"
	@echo "  make outdated       - Check outdated packages"
	@echo "  make analyze        - Analyze code"
	@echo "  make format         - Format code"
	@echo "  make test           - Run tests"
	@echo "  make coverage       - Run tests with coverage"
	@echo "  make doctor         - Run flutter doctor"
	@echo "  make setup          - Initial project setup"

# Clean the project and get dependencies
clean:
	flutter clean
	flutter pub get

# Get dependencies
get:
	flutter pub get

# Upgrade dependencies
upgrade:
	flutter pub upgrade

# Check outdated packages
outdated:
	flutter pub outdated

# Install the app on a connected device or emulator
install:
	flutter clean
	flutter pub get
	flutter build apk
	flutter install apk

# Create a release APK and open the folder containing the APK
apk:
	flutter clean
	flutter pub get
	flutter build apk --release
	@echo "APK created successfully!"
	open build/app/outputs/flutter-apk/ || xdg-open build/app/outputs/flutter-apk/ || start build/app/outputs/flutter-apk/

# Create a debug APK with custom name and open folder
apk_debug:
	flutter clean
	flutter pub get
	flutter build apk --debug
	mv build/app/outputs/flutter-apk/app-debug.apk build/app/outputs/flutter-apk/app_debug_mode.apk
	@echo "Debug APK created successfully!"
	open build/app/outputs/flutter-apk/ || xdg-open build/app/outputs/flutter-apk/ || start build/app/outputs/flutter-apk/

# Run IPF generator file to generate models, services, repositories, etc.
code_gen:
	flutter test code_generator.dart

# Run build_runner once
build_runner:
	flutter pub run build_runner build --delete-conflicting-outputs

# Run build_runner in watch mode
watch:
	flutter pub run build_runner watch --delete-conflicting-outputs

# Generate new feature with complete folder structure
# Usage: make feature name=auth
feature:
ifndef name
	@echo "Error: Please provide a feature name. Usage: make feature name=<feature_name>"
	@exit 1
endif
	@echo "Creating feature: $(name)"
	@mkdir -p lib/features/$(name)/controllers
	@mkdir -p lib/features/$(name)/services
	@mkdir -p lib/features/$(name)/models
	@mkdir -p lib/features/$(name)/screens
	@mkdir -p lib/features/$(name)/widgets
	@echo "// Controllers for $(name) feature" > lib/features/$(name)/controllers/.gitkeep
	@echo "// Services for $(name) feature" > lib/features/$(name)/services/.gitkeep
	@echo "// Models for $(name) feature" > lib/features/$(name)/models/.gitkeep
	@echo "// Screens for $(name) feature" > lib/features/$(name)/screens/.gitkeep
	@echo "// Widgets for $(name) feature" > lib/features/$(name)/widgets/.gitkeep
	@echo "Feature '$(name)' created successfully at lib/features/$(name)/"
	@echo "Structure:"
	@echo "  lib/features/$(name)/"
	@echo "    ├── controllers/"
	@echo "    ├── services/"
	@echo "    ├── models/"
	@echo "    ├── screens/"
	@echo "    └── widgets/"

# Run the app
run:
	flutter run

# Analyze code
analyze:
	flutter analyze

# Format code
format:
	dart format lib/ test/

# Run tests
test:
	flutter test

# Run tests with coverage
coverage:
	flutter test --coverage
	@echo "Coverage report generated at coverage/lcov.info"

# Run flutter doctor
doctor:
	flutter doctor -v

# Initial project setup
setup:
	flutter clean
	flutter pub get
	flutter pub run build_runner build --delete-conflicting-outputs
	@echo "Project setup complete!"
MAKEFILE_EOF

echo ""
echo "Creating README..."

cat > README.md << 'README_EOF'
# Flutter Project

A Flutter project with a clean, organized architecture.

## Project Structure

```
lib/
├── core/
│   ├── constants/      # App-wide constants
│   ├── extensions/     # Dart extensions
│   ├── mixins/         # Reusable mixins
│   ├── resources/      # Resource files (fonts, images, svgs)
│   ├── theme/          # App theming
│   └── utils/          # Utility functions
├── dao/                # Data Access Objects
├── features/           # Feature modules
├── l10n/               # Localization files
├── root/               # Root level screens (splash, etc.)
├── services/           # Global services
└── shared/             # Shared components and controllers
    ├── components/
    └── controllers/
```

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- Make (for using Makefile commands)

### Setup

1. Clone the repository
2. Run initial setup:
   ```bash
   make setup
   ```

## Available Make Commands

- `make help` - Show all available commands
- `make clean` - Clean project and get dependencies
- `make run` - Run the app
- `make feature name=<name>` - Generate new feature structure
- `make apk` - Build release APK
- `make apk_debug` - Build debug APK
- `make test` - Run tests
- `make analyze` - Analyze code
- `make format` - Format code

### Creating a New Feature

To create a new feature with the complete folder structure:

```bash
make feature name=auth
```

This will create:
```
lib/features/auth/
├── controllers/
├── services/
├── models/
├── screens/
└── widgets/
```

## Development

Run the app in development mode:
```bash
make run
```

Run tests:
```bash
make test
```

Format code:
```bash
make format
```

## Building

### Debug APK
```bash
make apk_debug
```

### Release APK
```bash
make apk
```

## Contributing

1. Create a feature branch
2. Make your changes
3. Run `make format` and `make analyze`
4. Submit a pull request

## License

Add your license here
README_EOF

echo ""
echo "Creating code_generator.dart placeholder..."

cat > code_generator.dart << EOF
import 'package:flutter_pack/flutter_pack.dart';

void main() {
  List<BaseModelGenerator> generator = [

  ];
  CodeGenerator.of('$PROJECT_NAME', generator).generate();
}
EOF

echo ""
echo "=========================================="
echo "✅ Project structure created successfully!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. cd $PROJECT_NAME"
echo "2. make setup"
echo "3. make feature name=your_feature_name"
echo "4. make run"
echo ""
echo "Use 'make help' to see all available commands"