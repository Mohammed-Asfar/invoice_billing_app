class AppVersionInfo {
  final String latestVersion;
  final String downloadUrl;
  final String releaseNotes;
  final bool forceUpdate;

  const AppVersionInfo({
    required this.latestVersion,
    required this.downloadUrl,
    required this.releaseNotes,
    required this.forceUpdate,
  });
}
