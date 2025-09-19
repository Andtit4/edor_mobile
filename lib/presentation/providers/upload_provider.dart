// lib/presentation/providers/upload_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/datasources/remote/upload_remote_data_source.dart';
import '../../core/network/network_info.dart';

final uploadRemoteDataSourceProvider = Provider<UploadRemoteDataSource>((ref) {
  return UploadRemoteDataSourceImpl(
    dio: Dio(),
    networkInfo: ref.read(networkInfoProvider),
  );
});

final uploadProvider = StateNotifierProvider<UploadNotifier, UploadState>((ref) {
  return UploadNotifier(ref.read(uploadRemoteDataSourceProvider));
});

class UploadState {
  final bool isUploading;
  final String? error;
  final String? uploadedImageUrl;

  UploadState({
    this.isUploading = false,
    this.error,
    this.uploadedImageUrl,
  });

  UploadState copyWith({
    bool? isUploading,
    String? error,
    String? uploadedImageUrl,
  }) {
    return UploadState(
      isUploading: isUploading ?? this.isUploading,
      error: error,
      uploadedImageUrl: uploadedImageUrl ?? this.uploadedImageUrl,
    );
  }
}

class UploadNotifier extends StateNotifier<UploadState> {
  final UploadRemoteDataSource _remoteDataSource;

  UploadNotifier(this._remoteDataSource) : super(UploadState());

  Future<String?> uploadProfileImage(XFile imageFile, String token) async {
    state = state.copyWith(isUploading: true, error: null);
    
    try {
      // Utiliser XFile directement (compatible avec Flutter Web)
      final imageUrl = await _remoteDataSource.uploadProfileImage(imageFile, token);
      state = state.copyWith(
        isUploading: false,
        uploadedImageUrl: imageUrl,
      );
      return imageUrl;
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearUploadedImage() {
    state = state.copyWith(uploadedImageUrl: null);
  }
}
