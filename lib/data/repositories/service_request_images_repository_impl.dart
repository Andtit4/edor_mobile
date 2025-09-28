import 'package:image_picker/image_picker.dart';
import '../../domain/repositories/service_request_images_repository.dart';
import '../datasources/remote/service_request_images_remote_data_source.dart';

class ServiceRequestImagesRepositoryImpl implements ServiceRequestImagesRepository {
  final ServiceRequestImagesRemoteDataSource remoteDataSource;

  ServiceRequestImagesRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<String>> uploadServiceRequestImages(
    List<XFile> imageFiles,
    String token,
  ) async {
    return await remoteDataSource.uploadServiceRequestImages(imageFiles, token);
  }
}

