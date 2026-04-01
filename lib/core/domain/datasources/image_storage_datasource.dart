import 'dart:io';

/// Abstraction for image storage operations.
abstract class ImageStorageDatasource {
  /// Upload an image to cloud storage and return its download URL.
  Future<String> uploadImage(File image, String uid);

  /// Fetch an image from a remote URL and return it as a local file.
  Future<File> fetchNetworkImage(String url);
}
