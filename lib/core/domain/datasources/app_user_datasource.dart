/// Abstraction for fetching app user data.
abstract class AppUserDatasource {
  /// Fetch user data by UID. Returns null if user not found.
  Future<Map?> getUserData({required String uid});
}
