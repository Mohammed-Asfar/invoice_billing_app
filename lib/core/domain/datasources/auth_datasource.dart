/// Abstraction for authentication operations only.
abstract class AuthDatasource {
  /// Sign in with email and password. Returns a map with user info.
  Future<Map> signWithEmailPassword(
      {required String email, required String password});

  /// Send a password reset email.
  Future<String> forgotPassword({required String email});
}
