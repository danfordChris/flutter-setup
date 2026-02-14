# Flutter Setup Script – Full Documentation

## Overview

`flutter_setup` is a global CLI script that automatically creates a fully structured Flutter project with:

- Clean architecture folder structure
- Pre-installed dependencies
- Pre-configured Makefile
- Localization setup
- Theme setup
- Extension utilities
- Code generator template
- Asset directories
- Feature-based modular structure

This script saves hours of manual setup and enforces consistency across projects.

---

# Installation (Global Usage)

## 1️⃣ Move Script to Global Location

Rename your script to `flutter_setup` and move it to a global binary directory:

```bash
sudo mv flutter_setup /usr/local/bin/flutter_setup
```

---

## 2️⃣ Make It Executable

```bash
sudo chmod +x /usr/local/bin/flutter_setup
```

---

## 3️⃣ Test Installation

Run from anywhere:

```bash
flutter_setup my_app
```

This will create a new Flutter project named `my_app` in your current directory.

---

# What the Script Does

When you run:

```bash
flutter_setup my_app
```

The script performs the following steps:

---

## 1. Creates Flutter Project

```bash
flutter create my_app
```

---

## 2. Installs Required Packages

Automatically installs:

- `go_router`
- `flutter_pack`

Then runs:

```bash
flutter pub get
```

---

## 3. Generates Folder Structure

```
lib/
├── core/
│   ├── constants/
│   ├── extensions/
│   ├── mixins/
│   ├── resources/
│   ├── theme/
│   └── utils/
├── dao/
├── features/
├── l10n/
├── root/
├── services/
└── shared/
    ├── components/
    └── controllers/
```

Also creates:

```
assets/
├── fonts/
├── images/
└── svgs/
```

---

## 4. Creates Preconfigured Files

### Extensions

`BuildContextExtension` for:

- Theme access
- Color scheme
- Text styles
- MediaQuery width/height
- GoRouter state access

---

### Theme System

- `AppTheme`
- `CustomColors`
- Material 3 enabled

---

### Localization

ARB files included:

- English
- Arabic
- Spanish
- French
- Swahili

---

### Splash Screen

Basic splash screen template inside:

```
lib/root/splash_screen.dart
```

---

### Resource Exports

- Fonts
- Images
- SVGs

---

### Code Generator

Automatically generates:

```dart
import 'package:flutter_pack/flutter_pack.dart';

void main() {
  List<BaseModelGenerator> generator = [];
  CodeGenerator.of('your_project_name', generator).generate();
}
```

The project name is dynamically injected.

---

### Makefile Included

Preconfigured commands:

| Command | Description |
|----------|-------------|
| make help | Show all commands |
| make run | Run app |
| make clean | Clean project |
| make get | Get dependencies |
| make upgrade | Upgrade packages |
| make apk | Build release APK |
| make apk_debug | Build debug APK |
| make feature name=auth | Generate feature structure |
| make test | Run tests |
| make analyze | Analyze code |
| make format | Format code |
| make coverage | Test with coverage |
| make doctor | Run flutter doctor |

---

# Creating a Feature

Example:

```bash
make feature name=auth
```

Creates:

```
lib/features/auth/
├── controllers/
├── services/
├── models/
├── screens/
└── widgets/
```

---

# Recommended Workflow

After project creation:

```bash
cd my_app
make setup
make feature name=auth
make run
```

---

# Requirements

- Flutter SDK (latest stable)
- Dart SDK
- Make installed (Mac/Linux default)

---

# Updating the Script

If you update the script:

```bash
sudo mv flutter_setup /usr/local/bin/flutter_setup
sudo chmod +x /usr/local/bin/flutter_setup
```

---

# Troubleshooting

## Permission Denied

Run:

```bash
chmod +x flutter_setup
```

## Command Not Found

Ensure `/usr/local/bin` is in your PATH:

```bash
echo $PATH
```

If missing, add to `.zshrc`:

```bash
export PATH="/usr/local/bin:$PATH"
source ~/.zshrc
```

---

# Why Use This Script?

- Enforces consistent architecture
- Saves setup time
- Pre-configured generator system
- Production-ready base structure
- Clean scalable modular design
- Automated dependency installation

---

# Future Improvements (Optional)

- Versioning system
- CLI flags (e.g. --riverpod, --bloc)
- Auto CI/CD template
- Docker setup
- Firebase preset option

---

# Architecture Strengths & Weaknesses

## ✅ Strengths

### 1. Consistent Project Structure
Every project follows the same folder architecture.  
This improves:
- Team collaboration
- Onboarding speed
- Code discoverability
- Maintainability

---

### 2. Modular Feature-Based Design
Each feature is isolated inside:

```
lib/features/<feature_name>/
```

Benefits:
- Clear separation of concerns
- Easier scaling
- Independent feature development
- Reduced merge conflicts

---

### 3. Preconfigured Tooling (Makefile)
Provides:
- Standardized commands
- Faster development workflow
- Reduced human error
- Production-ready build commands

---

### 4. Built-in Code Generator Support
Using `flutter_pack`:
- Encourages structured data modeling
- Reduces boilerplate
- Improves development speed

---

### 5. Clean Core Layer
`core/` centralizes:
- Extensions
- Theme
- Utilities
- Resources

This prevents duplication and keeps business logic clean.

---

### 6. Global CLI Productivity
Because the script runs globally:
- Projects can be scaffolded instantly
- Setup time is reduced from hours to seconds
- Architecture enforcement becomes automatic

---

## ⚠ Weaknesses

### 1. Opinionated Architecture
The structure is predefined and may not fit:
- Small prototype apps
- Micro projects
- Teams using different patterns (e.g., BLoC, Riverpod, Clean Architecture strict layers)

---

### 2. Dependency Lock-in
Pre-installing:
- `go_router`
- `flutter_pack`

May not suit every project requirement.

---

### 3. Overhead for Very Small Apps
For simple apps:
- The folder structure may feel heavy
- Setup may be more than needed

---

### 4. Manual Evolution Required
As Flutter evolves:
- Dependencies may change
- Best practices may shift
- Script must be manually maintained

---

### 5. No Built-in Testing Architecture
While test folders exist, it does not enforce:
- Test structure patterns
- Mocking strategy
- CI integration by default

---

# When This Setup Is Ideal

✅ Medium to large-scale applications  
✅ Teams requiring structure consistency  
✅ Long-term maintainable projects  
✅ Production apps  
✅ Developers who prefer automation  

---

# When It May Not Be Ideal

❌ Hackathons  
❌ Throwaway prototypes  
❌ Very small personal apps  
❌ Highly customized architecture needs  

---

# License
MIT License

Copyright (c) 2026 Danford Jurvis

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


# flutter-setup
