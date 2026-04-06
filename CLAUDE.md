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

No code generation (build_runner/freezed) is used. Dart SDK constraint: `^3.6.0`.

## Release Process

Releases are done locally via `./tools/release.sh`. **Must be on `develop` branch** with no uncommitted changes.

```bash
# 1. Write release notes in RELEASE_NOTES.md (multi-line supported)
# 2. Run:
./tools/release.sh 1.1.0
```

The script: bumps version in `pubspec.yaml` + `installers/installer.iss` (build number auto-increments) → builds Flutter → compiles Inno Setup `.exe` → commits (`release: vX.Y.Z`) → merges `develop` → `main` (with `--no-ff`) → pushes → creates GitHub Release with `.exe`. GitHub Actions (`release.yml`, triggered on `release: [published]`) then auto-updates Firestore `app_config/version` with download URL and release notes.

**Branch strategy**: `develop` (working branch) → merge to `main` (triggers release pipeline).

**Note**: The release script has a hardcoded Inno Setup path (`D:/Software/Inno Setup 6/ISCC.exe`). Installer output: `build/installer/TBS_Invoice_Generator_Setup_{VERSION}.exe` (x64 only, no admin required).

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
│   ├── entities/                # Domain models + form-state controllers (see below)
│   ├── models/                  # Serializable models extending entities (toMap/fromMap)
│   ├── cubit/app_user/          # Global auth state (AppUserCubit)
│   ├── error/                   # Failure and ServerException types
│   ├── secrets/                 # Secrets class (reads from .env via dotenv)
│   ├── utils/                   # Shared UI helpers (snackbar, dialogs, loader, date formatting)
│   └── theme/                   # AppColors, AppTheme (Material 3, Poppins font)
└── features/                    # Feature modules
    ├── auth/                    # Email/password auth + first-time profile setup (AuthDetailsPage)
    ├── invoice/                 # Invoice creation
    ├── invoice_edit/            # Invoice editing
    ├── quotation/               # Quotation creation
    ├── quotation_edit/          # Quotation editing
    ├── dashboard/               # Stats and invoice/quotation lists
    ├── settings/                # User profile management
    ├── initialize_and_error/    # Splash/loading screen and network error page
    └── main_navigation/         # Sidebar navigation shell + update check
```

Each feature follows: `domain/` (repository, usecases) → `presentation/` (bloc, pages, widgets).

## Key Patterns

### Dependency Injection

`GetIt` service locator in `init_dependencies.dart`. Registration patterns:
- **Lazy singletons**: Core Firebase services, datasources, services, `AppUserCubit`, and all blocs (blocs persist across navigation — state is retained).
- **Factories**: Repositories and usecases (new instance per resolution).

All datasources and services are registered by their abstract type for DIP compliance. Registration is organized into feature-specific private init functions (e.g., `_initAuth()`, `_initCreateInvoice()`, `_initDashboard()`, `_initQuotation()`, etc.).

### UseCase vs Repository

Both wrap datasource calls with `try/catch ServerException → Left(Failure)`, but serve different roles:
- **Repository**: Simple single-datasource operations (e.g., `getNextInvoiceNumber`).
- **UseCase** (extends `UseCase<ReturnType, Params>`): Multi-step orchestration that coordinates multiple services (e.g., `CreateInvoiceUseCase` saves to Firestore *then* generates PDF). Not every feature uses usecases — only invoice and quotation creation do.

### Form-State Controllers

`InvoiceController` and `QuotationController` in `core/entities/` are **not** domain entities — they are form-state holders that bundle `TextEditingController`s for the creation/edit forms. They contain tax calculation logic (`calculateTotals`, `calculateWithTax`, `calculateWithoutTax`) and a `toInvoiceModel()`/`toQuotationModel()` method that converts form state into a serializable model.

Tax defaults: SGST/CGST at **9% each** (18% total). Rounding: `rawTotal.roundToDouble() - rawTotal` to get round-off amount (nearest rupee). Calculations are deferred via `addPostFrameCallback` to avoid build-phase setState.

**IGST toggle**: Both controllers have a `bool isIgst` field and `igstTaxController`/`igstAmountController`. When toggled ON, the form shows a single "Output IGST" row (combined SGST+CGST). `syncIgstToSgstCgst()` splits the IGST percentage equally into SGST and CGST. The `isIgst` flag is persisted to Firestore and controls whether the PDF prints IGST or separate SGST/CGST lines.

**Quotation vs Invoice differences**: Quotations have `validUntilDate` (default 30 days) and a terms & conditions field. Quotations do not have a GST-IN field. `QuotationController` has a `fromQuotation()` factory for edit mode.

### State Management

`flutter_bloc` — `AppUserCubit` for global auth state, feature-specific `Bloc`s for business logic. All blocs provided via `MultiBlocProvider` in `main.dart`.

### Error Handling

`fpdart` `Either<Failure, T>` return types throughout. Datasources throw `ServerException`, repositories/usecases catch and return `Left(Failure)`. Blocs `.fold()` the result to emit success/failure states.

### Entity-Model Separation

Domain entities in `core/entities/` are plain classes. Models in `core/models/` extend entities and add `toMap()`/`fromMap()` serialization for Firestore.

### PDF Generation

Services in `core/services/` generate PDFs using the `pdf` package, save to the app documents directory, and open with `explorer.exe`.

### Image Uploads

Cloudinary signed uploads via `CloudinaryImageDatasource`. Upload signature uses `crypto` package for SHA-1. Secrets read from `.env` via the `Secrets` class. Uploads go to folder `company_logos` with public ID `company_logos/{uid}` and `overwrite=true`.

### In-App Updates

`AppUpdateService` checks Firestore `app_config/version` on login, shows a floating update dialog if a newer version exists.

## Invoice Number Format

Financial year format: `YY-YY/NNN` (e.g. `26-27/001`). FY runs April–March. Counter resets each April. Firestore doc IDs use `_` instead of `/` (e.g. `26-27_001`).

## Firebase Collections

- `users/{uid}` — User profile (company details, bank info, GSTIN, logo URL)
- `invoices/{docId}` — Invoice documents (docId = invoiceNumber with `/` replaced by `_`)
- `quotations/{quotationNumber}` — Quotation documents
- `app_config/version` — App update info (latestVersion, downloadUrl, releaseNotes, forceUpdate). **Firestore database ID**: `billing-app-db`

## Window Configuration

Fixed minimum size 1000x600, custom title bar using `bitsdojo_window` + `window_manager`. The `WindowTitleBar` widget in `main.dart` wraps the app with a draggable title bar and custom minimize/maximize/close buttons.

## App Initialization Flow

`main()` → load `.env` → window setup → `MyApp` → check internet (shows `NetworkErrorPage` if offline) → `initDependencies()` (Firebase + DI) → `MultiBlocProvider` → `StartingPage` (routes based on `AppUserCubit` state: `AppUserInitial` → `AuthPage`, `AppUserDetailsUpdate` → `AuthDetailsPage`, `AppUserLoggedIn` → `MainNavigationPage`) → `MainNavigationPage` checks for app updates on init.

## Notable Utilities

- `core/utils/number_to_word.dart` — Converts grand total to words for display on invoices/quotations.
- `hsn_gst_dataset.json` (repo root) — 4000+ HSN codes with GST rates. **Currently unused** in the app; available for future HSN autocomplete features.
