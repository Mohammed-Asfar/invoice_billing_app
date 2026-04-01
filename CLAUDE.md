# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

TBS Invoice Generator — a **Windows desktop** Flutter application for creating, managing, and printing invoices and quotations. Uses Firebase (Auth, Firestore, Storage) as the backend.

## Build & Run Commands

```bash
flutter pub get              # Install dependencies
flutter run -d windows       # Run the app (Windows only)
flutter build windows        # Build release executable
flutter analyze              # Run static analysis (flutter_lints)
flutter test                 # Run tests (no tests exist yet)
```

No code generation (build_runner/freezed) is used. No custom scripts or Makefile.

## Architecture

**Clean Architecture** with feature-based organization:

```
lib/
├── main.dart                    # Entry point, window setup, bloc providers
├── init_dependencies.dart       # GetIt service locator (DI container)
├── core/                        # Shared infrastructure
│   ├── domain/datasources/      # Abstract datasource contracts
│   ├── domain/services/         # Abstract service contracts (printing)
│   ├── domain/usecase/          # Base UseCase<ReturnType, Params> class
│   ├── data/                    # Concrete datasource implementations (Firebase)
│   ├── services/                # Concrete service implementations (PDF gen)
│   ├── entities/                # Domain models (User, Invoice, Quotation, Product)
│   ├── models/                  # Serializable models extending entities (toMap/fromMap)
│   ├── cubit/app_user/          # Global auth state (AppUserCubit)
│   ├── error/                   # Failure and ServerException types
│   └── theme/                   # AppColors, AppTheme (Material 3, Poppins font)
└── features/                    # Feature modules
    ├── auth/                    # Email/password auth, profile setup
    ├── invoice/                 # Invoice creation
    ├── invoice_edit/            # Invoice editing
    ├── quotation/               # Quotation CRUD
    ├── quotation_edit/          # Quotation editing
    ├── dashboard/               # Stats and invoice/quotation lists
    ├── settings/                # User profile management
    └── main_navigation/         # Sidebar navigation shell
```

Each feature follows: `domain/` (repository, usecases) → `presentation/` (bloc, pages, widgets).

## Key Patterns

- **Dependency Injection**: `GetIt` service locator in `init_dependencies.dart`. Datasources and services registered as abstract types. Repositories as factories, blocs as lazy singletons.
- **State Management**: `flutter_bloc` — `AppUserCubit` for global auth state, feature-specific `Bloc`s for business logic. All blocs provided via `MultiBlocProvider` in `main.dart`.
- **Error Handling**: `fpdart` `Either<Failure, T>` return types. Datasources throw `ServerException`, repositories catch and return `Left(Failure)`. Blocs `.fold()` the result to emit success/failure states.
- **Entity-Model Separation**: Domain entities in `core/entities/` are plain classes. Models in `core/models/` extend entities and add `toMap()`/`fromMap()` serialization for Firestore.
- **PDF Generation**: Services in `core/services/` generate PDFs using the `pdf` package, save to `AppDocumentsDir`, and open with `explorer.exe`.

## Firebase Collections

- `users/{uid}` — User profile (company details, bank info, GSTIN, logo URL)
- `invoices/{invoiceNumber}` — Invoice documents
- `quotations/{quotationNumber}` — Quotation documents

## Window Configuration

Fixed minimum size 1000x600, custom title bar using `bitsdojo_window` + `window_manager`. The `WindowTitleBar` widget in `main.dart` wraps the app with a draggable title bar and custom minimize/maximize/close buttons.

## App Initialization Flow

`main()` → window setup → `MyApp` → check internet → `initDependencies()` (Firebase + DI) → `MultiBlocProvider` → `StartingPage` (routes based on `AppUserCubit` state: loading → auth → profile setup → main navigation).
