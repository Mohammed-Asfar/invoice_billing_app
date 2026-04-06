Release a new version of the TBS Invoice Generator.

## Input

The user provides a version number (e.g. `1.4.0`). If not provided, determine the next minor version by reading the current version from `pubspec.yaml`.

## Steps

1. **Check preconditions**: Must be on `develop` branch with no uncommitted changes. If there are uncommitted changes, commit them first (ask for confirmation).

2. **Update RELEASE_NOTES.md**: Review all commits since the last release tag (`git log` from last `release: vX.Y.Z` commit). Write a concise `## What's New in vX.Y.Z` summary based on the changes.

3. **Run the release script**: Execute `./tools/release.sh <version>`. This script:
   - Bumps version in `pubspec.yaml` and `installers/installer.iss`
   - Builds Flutter Windows app
   - Compiles Inno Setup installer
   - Commits, merges develop → main, pushes
   - Creates GitHub Release with `.exe` attached
   - GitHub Actions auto-updates Firestore `app_config/version`

4. **Verify**: After the script completes, check that the GitHub Release was created and the Actions workflow was triggered.

## Important Notes

- The release script requires interactive confirmation (y/n prompt) — pipe `y` or use `echo y |` if running non-interactively.
- The script has a hardcoded Inno Setup path: `D:/Software/Inno Setup 6/ISCC.exe`.
- Installer output: `build/installer/TBS_Invoice_Generator_Setup_{VERSION}.exe`.
- The script will fail if `flutter build windows` fails — resolve build errors first.
