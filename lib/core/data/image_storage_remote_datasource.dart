import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:invoice_billing_app/core/domain/datasources/image_storage_datasource.dart';
import 'package:invoice_billing_app/core/error/server_exception.dart';
import 'package:invoice_billing_app/core/network_handle/check_connection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Firebase Storage implementation of [ImageStorageDatasource].
class ImageStorageRemoteDatasource implements ImageStorageDatasource {
  final FirebaseStorage _firebaseStorage;

  ImageStorageRemoteDatasource({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  @override
  Future<String> uploadImage(File image, String uid) async {
    try {
      final ref = _firebaseStorage.ref().child('company_logos/$uid');
      await ref.putFile(image);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw ServerException("Error uploading image: $e");
    }
  }

  @override
  Future<File> fetchNetworkImage(String url) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      final ref = _firebaseStorage.refFromURL(url);
      final directory = await getTemporaryDirectory();
      final filePath = p.join(directory.path, 'downloaded_image.png');
      final file = File(filePath);
      await ref.writeToFile(file);
      return file;
    } catch (e) {
      throw ServerException("Error fetching image: $e");
    }
  }
}
