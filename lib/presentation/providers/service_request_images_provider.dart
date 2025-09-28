import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/datasources/remote/service_request_images_remote_data_source.dart';
import '../../data/repositories/service_request_images_repository_impl.dart';
import '../../domain/repositories/service_request_images_repository.dart';
import 'package:dio/dio.dart';

// Providers
final serviceRequestImagesRemoteDataSourceProvider = Provider<ServiceRequestImagesRemoteDataSource>((ref) {
  return ServiceRequestImagesRemoteDataSourceImpl(
    dio: Dio(),
  );
});

final serviceRequestImagesRepositoryProvider = Provider<ServiceRequestImagesRepository>((ref) {
  return ServiceRequestImagesRepositoryImpl(
    remoteDataSource: ref.read(serviceRequestImagesRemoteDataSourceProvider),
  );
});

// State
class ServiceRequestImagesState {
  final List<String> selectedImages;
  final List<String> uploadedImageUrls;
  final bool isUploading;
  final String? error;

  const ServiceRequestImagesState({
    this.selectedImages = const [],
    this.uploadedImageUrls = const [],
    this.isUploading = false,
    this.error,
  });

  ServiceRequestImagesState copyWith({
    List<String>? selectedImages,
    List<String>? uploadedImageUrls,
    bool? isUploading,
    String? error,
  }) {
    return ServiceRequestImagesState(
      selectedImages: selectedImages ?? this.selectedImages,
      uploadedImageUrls: uploadedImageUrls ?? this.uploadedImageUrls,
      isUploading: isUploading ?? this.isUploading,
      error: error ?? this.error,
    );
  }
}

// Notifier
class ServiceRequestImagesNotifier extends StateNotifier<ServiceRequestImagesState> {
  final ServiceRequestImagesRepository _repository;
  final ImagePicker _imagePicker;

  ServiceRequestImagesNotifier({
    required ServiceRequestImagesRepository repository,
  }) : _repository = repository,
       _imagePicker = ImagePicker(),
       super(const ServiceRequestImagesState());

  Future<void> pickImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        final imagePaths = images.map((image) => image.path).toList();
        state = state.copyWith(
          selectedImages: imagePaths,
          error: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Erreur lors de la sélection des images: $e',
      );
    }
  }

  Future<void> uploadImages(String token) async {
    if (state.selectedImages.isEmpty) return;

    state = state.copyWith(isUploading: true, error: null);

    try {
      // Convertir les chemins en XFile avec gestion spéciale pour Flutter Web
      final imageFiles = <XFile>[];
      
      for (int i = 0; i < state.selectedImages.length; i++) {
        final path = state.selectedImages[i];
        XFile imageFile;
        
        if (path.startsWith('blob:')) {
          // Pour Flutter Web, créer un XFile avec un nom de fichier
          imageFile = XFile(path, name: 'image_$i.jpg');
        } else {
          // Pour les autres plateformes, utiliser le chemin normal
          imageFile = XFile(path);
        }
        
        imageFiles.add(imageFile);
      }
      
      final uploadedUrls = await _repository.uploadServiceRequestImages(
        imageFiles,
        token,
      );

      state = state.copyWith(
        uploadedImageUrls: uploadedUrls,
        isUploading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        error: 'Erreur lors de l\'upload: $e',
      );
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < state.selectedImages.length) {
      final newImages = List<String>.from(state.selectedImages);
      newImages.removeAt(index);
      state = state.copyWith(selectedImages: newImages);
    }
  }

  void clearImages() {
    state = state.copyWith(
      selectedImages: [],
      uploadedImageUrls: [],
      error: null,
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider
final serviceRequestImagesProvider = StateNotifierProvider<ServiceRequestImagesNotifier, ServiceRequestImagesState>((ref) {
  return ServiceRequestImagesNotifier(
    repository: ref.read(serviceRequestImagesRepositoryProvider),
  );
});

