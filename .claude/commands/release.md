Release a new version of the TBS Invoice Generator.

## Input

The user provides a version number (e.g. `1.4.0`). If not provided, determine the next minor version by reading the current version from `lib/core/constants/app_version.dart`.

## Steps

1. **Check preconditions**: Must be on `develop` branch with no uncommitted changes. If there are uncommitted changes, commit them first (ask for confirmation).

2. **Update version — code level first**: The code-level version in `lib/core/constants/app_version.dart` is the **source of truth**. Update it first, then update `pubspec.yaml` to match. Both files MUST always have the same version.
   - `lib/core/constants/app_version.dart`: `const String appVersion = '<version>';`
   - `pubspec.yaml`: `version: <version>+<build_number>` (keep existing build number, the release script auto-increments it)

3. **Generate RELEASE_NOTES.md**: Run `git log --oneline` from the last `release: vX.Y.Z` commit to HEAD. Summarize the changes into user-friendly bullet points (not raw commit messages) under a `## What's New in vX.Y.Z` heading. Write this to `RELEASE_NOTES.md`.

4. **Commit all changes**: Commit the version bump + release notes so the working tree is clean before the release script runs.

5. **Run the release script**: Execute `echo y | ./tools/release.sh <version>`. This script:
   - Bumps version in `pubspec.yaml` and `installers/installer.iss`
   - Builds Flutter Windows app
   - Compiles Inno Setup installer
   - Commits, merges develop → main, pushes
   - Creates GitHub Release with `.exe` attached
   - GitHub Actions auto-updates Firestore `app_config/version`

6. **Verify**: After the script completes, check that the GitHub Release was created and the Actions workflow was triggered.

## Important Notes

- **Version sync**: `lib/core/constants/app_version.dart` and `pubspec.yaml` must always match. Update code level first, then pubspec.
- The release script requires interactive confirmation — use `echo y |` to auto-confirm.
- The script has a hardcoded Inno Setup path: `D:/Software/Inno Setup 6/ISCC.exe`.
- Installer output: `build/installer/TBS_Invoice_Generator_Setup_{VERSION}.exe`.
- The script will fail if `flutter build windows` fails — resolve build errors first.
