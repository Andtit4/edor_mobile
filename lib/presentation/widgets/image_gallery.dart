import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ImageGallery extends StatelessWidget {
  final List<String> imageUrls;
  final double? height;
  final int? maxImagesToShow;
  final VoidCallback? onTap;
  final bool showImageCount;
  final bool showFullScreenButton;

  const ImageGallery({
    super.key,
    required this.imageUrls,
    this.height,
    this.maxImagesToShow,
    this.onTap,
    this.showImageCount = true,
    this.showFullScreenButton = true,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    final imagesToShow = maxImagesToShow != null 
        ? imageUrls.take(maxImagesToShow!).toList()
        : imageUrls;
    
    // final remainingCount = imageUrls.length - imagesToShow.length;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 120,
        child: Stack(
          children: [
            // Images grid
            _buildImagesGrid(imagesToShow),
            
            // Overlay with count and full screen button
            if (showImageCount || showFullScreenButton)
              Positioned(
                top: 8,
                right: 8,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showImageCount && imageUrls.length > 1)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '+${imageUrls.length}',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (showImageCount && imageUrls.length > 1 && showFullScreenButton)
                      const SizedBox(width: 8),
                    if (showFullScreenButton)
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.fullscreen,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagesGrid(List<String> images) {
    if (images.length == 1) {
      return _buildSingleImage(images[0]);
    } else if (images.length == 2) {
      return _buildTwoImages(images);
    } else if (images.length == 3) {
      return _buildThreeImages(images);
    } else {
      return _buildFourOrMoreImages(images);
    }
  }

  Widget _buildSingleImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: _buildImageWidget(imageUrl),
    );
  }

  Widget _buildTwoImages(List<String> images) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            child: _buildImageWidget(images[0]),
          ),
        ),
        const SizedBox(width: 2),
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            child: _buildImageWidget(images[1]),
          ),
        ),
      ],
    );
  }

  Widget _buildThreeImages(List<String> images) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            child: _buildImageWidget(images[0]),
          ),
        ),
        const SizedBox(width: 2),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                  ),
                  child: _buildImageWidget(images[1]),
                ),
              ),
              const SizedBox(height: 2),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(8),
                  ),
                  child: _buildImageWidget(images[2]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFourOrMoreImages(List<String> images) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                  ),
                  child: _buildImageWidget(images[0]),
                ),
              ),
              const SizedBox(height: 2),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                  ),
                  child: _buildImageWidget(images[1]),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 2),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                  ),
                  child: _buildImageWidget(images[2]),
                ),
              ),
              const SizedBox(height: 2),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(8),
                  ),
                  child: images.length > 3
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            _buildImageWidget(images[3]),
                            Container(
                              color: Colors.black.withValues(alpha: 0.5),
                              child: Center(
                                child: Text(
                                  '+${images.length - 3}',
                                  style: AppTextStyles.h4.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : _buildImageWidget(images[3]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageWidget(String imageUrl) {
    // Vérifier si c'est un fichier local ou une URL
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      // URL d'image en ligne
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => Container(
          color: AppColors.lightGray,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: AppColors.lightGray,
          child: const Icon(
            Icons.image_not_supported,
            color: Colors.grey,
            size: 24,
          ),
        ),
      );
    } else {
      // Fichier local
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(imageUrl),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) => Container(
            color: AppColors.lightGray,
            child: const Icon(
              Icons.image_not_supported,
              color: Colors.grey,
              size: 24,
            ),
          ),
        ),
      );
    }
  }
}

// Widget pour afficher une galerie compacte (pour les listes)
class CompactImageGallery extends StatelessWidget {
  final List<String> imageUrls;
  final VoidCallback? onTap;

  const CompactImageGallery({
    super.key,
    required this.imageUrls,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.borderColor,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: _buildImageWidget(imageUrls.first),
            ),
            if (imageUrls.length > 1)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.purple,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '+${imageUrls.length}',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(String imageUrl) {
    // Vérifier si c'est un fichier local ou une URL
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      // URL d'image en ligne
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => Container(
          color: AppColors.lightGray,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: AppColors.lightGray,
          child: const Icon(
            Icons.image_not_supported,
            color: Colors.grey,
            size: 24,
          ),
        ),
      );
    } else {
      // Fichier local
      return Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => Container(
          color: AppColors.lightGray,
          child: const Icon(
            Icons.image_not_supported,
            color: Colors.grey,
            size: 24,
          ),
        ),
      );
    }
  }
}

