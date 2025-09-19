import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import '../../../core/config/app_config.dart';
import '../../../core/errors/exceptions.dart';

abstract class ServiceRequestImagesRemoteDataSource {
  Future<List<String>> uploadServiceRequestImages(
    List<XFile> imageFiles,
    String token,
  );
}

class ServiceRequestImagesRemoteDataSourceImpl
    implements ServiceRequestImagesRemoteDataSource {
  final Dio dio;
  final String baseUrl;

  ServiceRequestImagesRemoteDataSourceImpl({
    required this.dio,
    String? baseUrl,
  }) : baseUrl = baseUrl ?? AppConfig.uploadEndpoint;

  @override
  Future<List<String>> uploadServiceRequestImages(
    List<XFile> imageFiles,
    String token,
  ) async {
    try {
      print('Upload service request images - Count: ${imageFiles.length}');
      
      if (imageFiles.isEmpty) {
        throw const ServerException(message: 'Aucune image à uploader');
      }

      if (imageFiles.length > 10) {
        throw const ServerException(message: 'Maximum 10 images autorisées');
      }

      // Préparer les fichiers multipart
      final List<MultipartFile> multipartFiles = [];
      
      for (int i = 0; i < imageFiles.length; i++) {
        final imageFile = imageFiles[i];
        final bytes = await imageFile.readAsBytes();
        
        // Détecter le type MIME
        String mimeType = 'image/jpeg'; // Par défaut
        if (imageFile.name.toLowerCase().endsWith('.png')) {
          mimeType = 'image/png';
        } else if (imageFile.name.toLowerCase().endsWith('.gif')) {
          mimeType = 'image/gif';
        } else if (imageFile.name.toLowerCase().endsWith('.jpg') || 
                   imageFile.name.toLowerCase().endsWith('.jpeg')) {
          mimeType = 'image/jpeg';
        }

        print('Upload image $i - Nom: ${imageFile.name}, Taille: ${bytes.length} bytes, MimeType: $mimeType');

        final multipartFile = MultipartFile.fromBytes(
          bytes,
          filename: imageFile.name,
          contentType: MediaType.parse(mimeType),
        );
        
        multipartFiles.add(multipartFile);
      }

      // Créer FormData
      final formData = FormData.fromMap({
        'images': multipartFiles,
      });

      // Faire la requête
      final response = await dio.post(
        '$baseUrl/service-request-images',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final imageUrls = List<String>.from(data['imageUrls'] ?? []);
        print('Upload réussi - URLs: $imageUrls');
        return imageUrls;
      } else {
        throw ServerException(
          message: 'Erreur lors de l\'upload des images: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('Erreur Dio lors de l\'upload des images: $e');
      
      if (e.response?.statusCode == 400) {
        final errorMessage = e.response?.data?['message'] ?? 'Erreur de validation';
        throw ServerException(message: errorMessage);
      } else if (e.response?.statusCode == 401) {
        throw ServerException(message: 'Non autorisé');
      } else if (e.response?.statusCode == 413) {
        throw ServerException(message: 'Fichiers trop volumineux');
      } else if (e.response?.statusCode == 500) {
        throw ServerException(message: 'Erreur serveur');
      } else {
        throw ServerException(
          message: 'Erreur réseau: ${e.message}',
        );
      }
    } catch (e) {
      print('Erreur inattendue lors de l\'upload des images: $e');
      throw ServerException(
        message: 'Erreur inattendue: $e',
      );
    }
  }
}
