// lib/data/datasources/remote/upload_remote_data_source.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../../../core/config/app_config.dart';

abstract class UploadRemoteDataSource {
  Future<String> uploadProfileImage(XFile imageFile, String token);
}

class UploadRemoteDataSourceImpl implements UploadRemoteDataSource {
  final Dio dio;
  final NetworkInfo networkInfo;

  UploadRemoteDataSourceImpl({
    required this.dio,
    required this.networkInfo,
  });

  @override
  Future<String> uploadProfileImage(XFile imageFile, String token) async {
    if (!await networkInfo.isConnected) {
      throw const ServerException(message: 'Pas de connexion internet');
    }

    try {
      // Lire les bytes du fichier (fonctionne sur toutes les plateformes)
      final bytes = await imageFile.readAsBytes();
      
      print('Upload image - Nom: ${imageFile.name}, Taille: ${bytes.length} bytes');
      
      // Déterminer le mimetype basé sur l'extension
      String mimeType = 'image/jpeg'; // Par défaut
      final extension = imageFile.name.toLowerCase().split('.').last;
      switch (extension) {
        case 'jpg':
        case 'jpeg':
          mimeType = 'image/jpeg';
          break;
        case 'png':
          mimeType = 'image/png';
          break;
        case 'gif':
          mimeType = 'image/gif';
          break;
        case 'webp':
          mimeType = 'image/webp';
          break;
        case 'bmp':
          mimeType = 'image/bmp';
          break;
        case 'tiff':
          mimeType = 'image/tiff';
          break;
        case 'svg':
          mimeType = 'image/svg+xml';
          break;
      }
      
      print('Upload image - MimeType détecté: $mimeType');
      
      final formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(
          bytes,
          filename: imageFile.name,
        ),
      });

      final response = await dio.post(
        '${AppConfig.uploadEndpoint}/profile-image',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['imageUrl'] as String;
      } else {
        throw ServerException(message: 'Erreur lors de l\'upload: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Erreur DioException: $e');
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      
      if (e.response?.statusCode == 400) {
        // Récupérer le message d'erreur du backend
        final errorMessage = e.response?.data?['message'] ?? 'Erreur de validation';
        throw ServerException(message: errorMessage);
      } else if (e.response?.statusCode == 401) {
        throw const ServerException(message: 'Non autorisé');
      } else if (e.response?.statusCode == 413) {
        throw const ServerException(message: 'Fichier trop volumineux (max 5MB)');
      } else {
        throw ServerException(message: 'Erreur réseau: ${e.message}');
      }
    } catch (e) {
      print('Erreur inattendue: $e');
      throw ServerException(message: 'Erreur inattendue: $e');
    }
  }
}
