#!/bin/bash
# ─────────────────────────────────────────────────────────────
# TBS Invoice Generator — Release Script
#
# Usage:
#   ./tools/release.sh <version>
#
# Examples:
#   ./tools/release.sh 1.1.0
#
# Before running, write your release notes in RELEASE_NOTES.md
# at the project root. Multi-line notes are supported.
#
# What it does:
#   1. Updates version in pubspec.yaml and installer.iss
#   2. Builds Flutter Windows app locally
#   3. Compiles Inno Setup installer locally
#   4. Commits version bump, merges develop → main
#   5. Creates GitHub Release with .exe attached
#   6. GitHub Actions updates Firestore (triggered by push to main)
# ─────────────────────────────────────────────────────────────

set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ISCC_PATH="D:/Software/Inno Setup 6/ISCC.exe"

cd "$PROJECT_DIR"

# ── Parse args ──────────────────────────────────────────────
VERSION="$1"

if [ -z "$VERSION" ]; then
  echo "Usage: ./tools/release.sh <version>"
  echo "  e.g. ./tools/release.sh 1.1.0"
  echo ""
  echo "Write release notes in RELEASE_NOTES.md before running."
  exit 1
fi

if ! echo "$VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
  echo "Error: Version must be semver (e.g. 1.1.0)"
  exit 1
fi

# ── Check RELEASE_NOTES.md ─────────────────────────────────
NOTES_FILE="$PROJECT_DIR/RELEASE_NOTES.md"

if [ ! -f "$NOTES_FILE" ] || [ ! -s "$NOTES_FILE" ]; then
  echo "Error: RELEASE_NOTES.md is missing or empty."
  echo "Create it with your release notes before running this script."
  echo ""
  echo "Example:"
  echo "  ## What's New"
  echo "  - New financial year invoice format (26-27/001)"
  echo "  - Cloudinary image uploads"
  echo "  - In-app update notifications"
  exit 1
fi

echo ""
echo "═══════════════════════════════════════════════════"
echo "  TBS Invoice Generator — Release v$VERSION"
echo "═══════════════════════════════════════════════════"
echo ""
echo "Release notes:"
echo "───────────────────────────────────────────────────"
cat "$NOTES_FILE"
echo ""
echo "───────────────────────────────────────────────────"
echo ""
read -p "Proceed with release? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 0
fi
echo ""

# ── Verify we're on develop ─────────────────────────────────
BRANCH=$(git branch --show-current)
if [ "$BRANCH" != "develop" ]; then
  echo "Error: You must be on the 'develop' branch. Currently on '$BRANCH'."
  exit 1
fi

if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "Error: You have uncommitted changes. Commit or stash them first."
  exit 1
fi

# ── Step 1: Bump version ────────────────────────────────────
echo "▸ [1/6] Updating version to $VERSION..."

CURRENT_BUILD=$(grep -oP 'version: [0-9.]+\+\K[0-9]+' pubspec.yaml || echo "0")
NEW_BUILD=$((CURRENT_BUILD + 1))
sed -i "s/^version: .*/version: $VERSION+$NEW_BUILD/" pubspec.yaml

sed -i "s/#define MyAppVersion.*/#define MyAppVersion   \"$VERSION\"/" installers/installer.iss

echo "  Done"
echo ""

# ── Step 2: Build Flutter ────────────────────────────────────
echo "▸ [2/6] Building Flutter Windows app..."
flutter build windows --release
echo "  Done"
echo ""

# ── Step 3: Compile installer ────────────────────────────────
echo "▸ [3/6] Compiling Inno Setup installer..."
INSTALLER_FILE="TBS_Invoice_Generator_Setup_$VERSION.exe"
"$ISCC_PATH" "$PROJECT_DIR/installers/installer.iss"

if [ ! -f "$PROJECT_DIR/build/installer/$INSTALLER_FILE" ]; then
  echo "Error: Installer not found at build/installer/$INSTALLER_FILE"
  exit 1
fi

INSTALLER_SIZE=$(du -h "$PROJECT_DIR/build/installer/$INSTALLER_FILE" | cut -f1)
echo "  Done: $INSTALLER_FILE ($INSTALLER_SIZE)"
echo ""

# ── Step 4: Commit and merge ─────────────────────────────────
echo "▸ [4/6] Committing and merging develop -> main..."

git add pubspec.yaml installers/installer.iss
git commit -m "release: v$VERSION"

git checkout main
git merge develop --no-ff -m "release: v$VERSION"
git push origin main
git checkout develop
git push origin develop

echo "  Done"
echo ""

# ── Step 5: Upload to GitHub Releases ─────────────────────────
echo "▸ [5/6] Creating GitHub Release with installer..."

gh release create "v$VERSION" \
  "$PROJECT_DIR/build/installer/$INSTALLER_FILE" \
  --title "TBS Invoice Generator v$VERSION" \
  --notes-file "$NOTES_FILE"

echo "  Done"
echo ""

# ── Step 6: Done ─────────────────────────────────────────────
echo "▸ [6/6] GitHub Actions will update Firestore automatically"
echo ""
echo "═══════════════════════════════════════════════════"
echo "  Release v$VERSION complete!"
echo "═══════════════════════════════════════════════════"
echo ""
