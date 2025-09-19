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
        final fileName = imageFile.name.toLowerCase();
        
        if (fileName.endsWith('.png')) {
          mimeType = 'image/png';
        } else if (fileName.endsWith('.gif')) {
          mimeType = 'image/gif';
        } else if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) {
          mimeType = 'image/jpeg';
        } else if (fileName.isEmpty || fileName == 'image_$i.jpg') {
          // Pour Flutter Web avec blob URLs, détecter le type à partir des bytes
          if (bytes.length >= 4) {
            // Vérifier les signatures de fichiers
            if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47) {
              mimeType = 'image/png';
            } else if (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46) {
              mimeType = 'image/gif';
            } else if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
              mimeType = 'image/jpeg';
            }
          }
        }

        print('Upload image $i - Nom: ${imageFile.name}, Taille: ${bytes.length} bytes, MimeType: $mimeType');

        // Générer un nom de fichier approprié
        String filename = imageFile.name;
        if (filename.isEmpty || filename.startsWith('image_')) {
          final ext = mimeType.split('/')[1];
          filename = 'service-request-${DateTime.now().millisecondsSinceEpoch}-$i.$ext';
        }

        final multipartFile = MultipartFile.fromBytes(
          bytes,
          filename: filename,
          contentType: MediaType.parse(mimeType),
        );
        
        multipartFiles.add(multipartFile);
      }

      // Créer FormData
      final formData = FormData.fromMap({
        'images': multipartFiles,
      });

      print('FormData créé avec ${multipartFiles.length} fichiers');
      print('URL de l\'endpoint: $baseUrl/service-request-images');

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

      if (response.statusCode == 200 || response.statusCode == 201) {
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
