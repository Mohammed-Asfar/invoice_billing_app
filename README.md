# TBS Invoice Generator

A Windows desktop application for creating, managing, and printing invoices and quotations. Built with Flutter and Firebase.

## Features

- Create and manage **invoices** and **quotations** with PDF generation
- Financial year invoice numbering (e.g. `26-27/001`)
- Dashboard with stats (total invoices, quotations, monthly counts)
- Company profile management with logo upload (Cloudinary)
- In-app update notifications
- Windows installer (.exe) via Inno Setup

## Tech Stack

- **Framework**: Flutter (Windows desktop)
- **Auth & Database**: Firebase Auth + Cloud Firestore
- **Image Storage**: Cloudinary
- **State Management**: flutter_bloc
- **DI**: GetIt service locator
- **PDF**: pdf + printing packages
- **Architecture**: Clean Architecture (domain → data → presentation)

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel)
- [Firebase CLI](https://firebase.google.com/docs/cli) (for Firebase setup)
- Windows 10/11 (for running the desktop app)
- [Inno Setup 6](https://jrsoftware.org/isinfo.php) (for building the installer)

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/Mohammed-Asfar/invoice_billing_app.git
   cd invoice_billing_app
   ```

2. Create a `.env` file from the example:
   ```bash
   cp .env.example .env
   ```
   Fill in your Cloudinary credentials in `.env`.

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run -d windows
   ```

## Project Structure

```
lib/
├── main.dart                # Entry point, window setup
├── init_dependencies.dart   # DI container (GetIt)
├── core/                    # Shared: datasources, services, entities, models, theme
└── features/                # Feature modules (auth, invoice, quotation, dashboard, settings)
```

Each feature follows Clean Architecture: `domain/` (repository, usecases) → `presentation/` (bloc, pages, widgets).

## Releasing

Releases are built locally and published via a script. Must be on the `develop` branch.

1. Write release notes in `RELEASE_NOTES.md`:
   ```md
   ## What's New
   - New invoice format
   - Bug fixes
   ```

2. Run the release script:
   ```bash
   ./tools/release.sh 1.1.0
   ```

This will:
- Bump the version in `pubspec.yaml` and `installer.iss`
- Build the Flutter Windows app
- Compile the Inno Setup installer (.exe)
- Commit, merge `develop` → `main`, and push
- Create a GitHub Release with the installer attached
- GitHub Actions auto-updates Firestore with the new version and download URL

### Branch Strategy

| Branch | Purpose |
|--------|---------|
| `develop` | Active development |
| `main` | Production releases only (triggers Firestore update via GitHub Actions) |

## Environment Variables

| Variable | Description |
|----------|-------------|
| `CLOUDINARY_CLOUD_NAME` | Cloudinary cloud name |
| `CLOUDINARY_API_KEY` | Cloudinary API key |
| `CLOUDINARY_API_SECRET` | Cloudinary API secret |

### GitHub Actions Secrets

| Secret | Description |
|--------|-------------|
| `FIREBASE_SERVICE_ACCOUNT` | Firebase service account JSON (for Firestore updates) |
| `CLOUDINARY_CLOUD_NAME` | Cloudinary cloud name |
| `CLOUDINARY_API_KEY` | Cloudinary API key |
| `CLOUDINARY_API_SECRET` | Cloudinary API secret |
