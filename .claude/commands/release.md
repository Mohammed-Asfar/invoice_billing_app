Release a new version of the application.

## Input

The user may provide a version number (e.g. `1.5.0`). If not provided, auto-determine using semver based on commits since the last release:
- **New feature** (`feat:`) → bump minor (e.g. 1.4.0 → 1.5.0)
- **Bug fix / small change** (`fix:`, `chore:`, `docs:`) → bump patch (e.g. 1.5.0 → 1.5.1)
- **Breaking change** → bump major (e.g. 1.5.1 → 2.0.0)

Read the current version from the code-level version constant.

## Steps

1. **Find the version constant**: Search the codebase for a version constant file (e.g. `app_version.dart`, `version.dart`, `constants.dart`). This is the **source of truth**. If none exists, check `pubspec.yaml` or `package.json`.

2. **Check preconditions**: Must be on the development branch with no uncommitted changes. If there are uncommitted changes, commit them first (ask for confirmation).

3. **Update version — code level first**: Update the code-level version constant first, then update the project manifest (`pubspec.yaml`, `package.json`, etc.) to match. Both MUST always have the same version.

4. **Generate release notes**: Run `git log --oneline` from the last release commit to HEAD. Write **only user-facing software changes** as bullet points. Include: new features, UI changes, bug fixes, performance improvements. Exclude: CI/CD changes, GitHub Actions, build scripts, documentation updates, code refactoring, dependency bumps, skill/command additions. Write to the release notes file (e.g. `RELEASE_NOTES.md`, `CHANGELOG.md`).

5. **Force update?**: Ask the user if this is a forced update (users cannot skip it) or optional. Default is optional (not forced).

6. **Commit all changes**: Commit the version bump + release notes so the working tree is clean before any release script runs.

7. **Run the release script**: Look for a release script in `tools/`, `scripts/`, or project root. If found, execute it with the version number. If not found, manually:
   - Build the project
   - Create a git tag `v<version>`
   - Push to remote
   - Create a GitHub Release via `gh release create`

8. **Set forceUpdate**: If the project has a Firestore update script (e.g. `.github/scripts/update_firestore.js`), update `forceUpdate` to `true` or `false` based on the user's answer from step 5. Commit if changed.

9. **Verify**: Check that the GitHub Release was created and any CI/CD workflows were triggered.

## Important Notes

- **Version sync**: Code-level version and project manifest must always match. Update code level first.
- Check `CLAUDE.md` for project-specific release instructions.
- If a release script exists, check if it needs interactive confirmation and handle accordingly.
