import 'package:image_picker/image_picker.dart';

abstract class ServiceRequestImagesRepository {
  Future<List<String>> uploadServiceRequestImages(
    List<XFile> imageFiles,
    String token,
  );
}
