# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

TBS Invoice Generator — a **Windows desktop** Flutter application for creating, managing, and printing invoices and quotations. Uses Firebase (Auth, Firestore) and Cloudinary (image uploads) as the backend.

## Build & Run Commands

```bash
flutter pub get              # Install dependencies
flutter run -d windows       # Run the app (Windows only)
flutter build windows        # Build release executable
flutter analyze              # Run static analysis (flutter_lints)
flutter test                 # Run tests (no tests exist yet)
```

No code generation (build_runner/freezed) is used.

## Release Process

Releases are done locally via the release script. **Must be on `develop` branch** with no uncommitted changes.

```bash
# 1. Write release notes in RELEASE_NOTES.md (multi-line supported)
# 2. Run:
./tools/release.sh 1.1.0
```

The script: bumps version in `pubspec.yaml` + `installer.iss` → builds Flutter → compiles Inno Setup `.exe` → commits → merges `develop` → `main` → pushes → creates GitHub Release with `.exe`. GitHub Actions then auto-updates Firestore `app_config/version` with download URL and release notes.

**Branch strategy**: `develop` (working branch) → merge to `main` (triggers release pipeline).

## Environment Setup

Secrets are loaded from `.env` via `flutter_dotenv`. Copy `.env.example` to `.env` and fill in:

```
CLOUDINARY_CLOUD_NAME=...
CLOUDINARY_API_KEY=...
CLOUDINARY_API_SECRET=...
```

GitHub Actions secret `FIREBASE_SERVICE_ACCOUNT` holds the Firebase service account JSON for Firestore updates.

## Architecture

**Clean Architecture** with feature-based organization:

```
lib/
├── main.dart                    # Entry point, window setup, dotenv, bloc providers
├── init_dependencies.dart       # GetIt service locator (DI container)
├── core/                        # Shared infrastructure
│   ├── domain/datasources/      # Abstract datasource contracts
│   ├── domain/services/         # Abstract service contracts (printing, updates)
│   ├── domain/usecase/          # Base UseCase<ReturnType, Params> class
│   ├── data/                    # Concrete datasource implementations (Firebase, Cloudinary)
│   ├── services/                # Concrete service implementations (PDF gen, update checker)
│   ├── entities/                # Domain models (User, Invoice, Quotation, Product, AppVersionInfo)
│   ├── models/                  # Serializable models extending entities (toMap/fromMap)
│   ├── cubit/app_user/          # Global auth state (AppUserCubit)
│   ├── error/                   # Failure and ServerException types
│   ├── secrets/                 # Secrets class (reads from .env via dotenv)
│   └── theme/                   # AppColors, AppTheme (Material 3, Poppins font)
└── features/                    # Feature modules
    ├── auth/                    # Email/password auth, profile setup
    ├── invoice/                 # Invoice creation
    ├── invoice_edit/            # Invoice editing
    ├── quotation/               # Quotation CRUD
    ├── quotation_edit/          # Quotation editing
    ├── dashboard/               # Stats and invoice/quotation lists
    ├── settings/                # User profile management
    └── main_navigation/         # Sidebar navigation shell + update check
```

Each feature follows: `domain/` (repository, usecases) → `presentation/` (bloc, pages, widgets).

## Key Patterns

- **Dependency Injection**: `GetIt` service locator in `init_dependencies.dart`. Datasources and services registered as abstract types. Repositories as factories, blocs as lazy singletons.
- **State Management**: `flutter_bloc` — `AppUserCubit` for global auth state, feature-specific `Bloc`s for business logic. All blocs provided via `MultiBlocProvider` in `main.dart`.
- **Error Handling**: `fpdart` `Either<Failure, T>` return types. Datasources throw `ServerException`, repositories catch and return `Left(Failure)`. Blocs `.fold()` the result to emit success/failure states.
- **Entity-Model Separation**: Domain entities in `core/entities/` are plain classes. Models in `core/models/` extend entities and add `toMap()`/`fromMap()` serialization for Firestore.
- **PDF Generation**: Services in `core/services/` generate PDFs using the `pdf` package, save to `AppDocumentsDir`, and open with `explorer.exe`.
- **Image Uploads**: Cloudinary signed uploads via `CloudinaryImageDatasource`. Secrets read from `.env`.
- **In-App Updates**: `AppUpdateService` checks Firestore `app_config/version` on login, shows update dialog if newer version exists.

## Invoice Number Format

Financial year format: `YY-YY/NNN` (e.g. `26-27/001`). FY runs April–March. Counter resets each April. Firestore doc IDs use `_` instead of `/` (e.g. `26-27_001`).

## Firebase Collections

- `users/{uid}` — User profile (company details, bank info, GSTIN, logo URL)
- `invoices/{docId}` — Invoice documents (docId = invoiceNumber with `/` replaced by `_`)
- `quotations/{quotationNumber}` — Quotation documents
- `app_config/version` — App update info (latestVersion, downloadUrl, releaseNotes, forceUpdate)

## Window Configuration

Fixed minimum size 1000x600, custom title bar using `bitsdojo_window` + `window_manager`. The `WindowTitleBar` widget in `main.dart` wraps the app with a draggable title bar and custom minimize/maximize/close buttons.

## App Initialization Flow

`main()` → load `.env` → window setup → `MyApp` → check internet → `initDependencies()` (Firebase + DI) → `MultiBlocProvider` → `StartingPage` (routes based on `AppUserCubit` state) → `MainNavigationPage` (checks for app updates on init).
