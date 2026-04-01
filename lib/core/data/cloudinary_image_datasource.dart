import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:invoice_billing_app/core/domain/datasources/image_storage_datasource.dart';
import 'package:invoice_billing_app/core/error/server_exception.dart';
import 'package:invoice_billing_app/core/network_handle/check_connection.dart';
import 'package:invoice_billing_app/core/secrets/secrets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Cloudinary implementation of [ImageStorageDatasource].
class CloudinaryImageDatasource implements ImageStorageDatasource {
  @override
  Future<String> uploadImage(File image, String uid) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final folder = 'company_logos';
      final publicId = '$folder/$uid';

      // Params in signature must be sorted alphabetically (exclude api_key, file, signature)
      final toSign =
          'overwrite=true&public_id=$publicId&timestamp=$timestamp${Secrets.cloudinaryApiSecret}';
      final signature = sha1.convert(utf8.encode(toSign)).toString();

      final uri = Uri.parse(
          'https://api.cloudinary.com/v1_1/${Secrets.cloudinaryCloudName}/image/upload');

      final request = http.MultipartRequest('POST', uri)
        ..fields['api_key'] = Secrets.cloudinaryApiKey
        ..fields['timestamp'] = timestamp.toString()
        ..fields['signature'] = signature
        ..fields['public_id'] = publicId
        ..fields['overwrite'] = 'true'
        ..files.add(await http.MultipartFile.fromPath('file', image.path));

      final response = await request.send();
      final body = jsonDecode(await response.stream.bytesToString());

      if (response.statusCode == 200) {
        return body['secure_url'] as String;
      }
      throw ServerException(
          "Cloudinary upload failed: ${body['error']?['message'] ?? 'Unknown error'}");
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException("Error uploading image: $e");
    }
  }

  @override
  Future<File> fetchNetworkImage(String url) async {
    if (await checkConnection()) {
      throw ServerException("No Internet Connection.");
    }
    if (url.isEmpty) {
      throw ServerException("No image URL provided.");
    }
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw ServerException("Error fetching image: ${response.statusCode}");
      }
      final directory = await getTemporaryDirectory();
      final filePath = p.join(directory.path, 'downloaded_image.png');
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException("Error fetching image: $e");
    }
  }
}
