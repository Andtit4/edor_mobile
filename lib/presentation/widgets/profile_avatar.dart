import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 40.0,
    this.backgroundColor,
    this.textColor,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBackgroundColor = backgroundColor ?? AppColors.purple.withValues(alpha: 0.1);
    final defaultTextColor = textColor ?? AppColors.purple;
    final defaultBorderColor = borderColor ?? AppColors.borderColor;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: defaultBackgroundColor,
        border: showBorder
            ? Border.all(
                color: defaultBorderColor,
                width: borderWidth,
              )
            : null,
      ),
      child: ClipOval(
        child: _buildAvatarContent(defaultTextColor),
      ),
    );
  }

  Widget _buildAvatarContent(Color textColor) {
    print('ProfileAvatar - Building with imageUrl: $imageUrl');
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      print('ProfileAvatar - Loading image: $imageUrl');
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) {
          print('ProfileAvatar - Loading placeholder for: $url');
          return _buildLoadingPlaceholder(textColor);
        },
        errorWidget: (context, url, error) {
          print('ProfileAvatar - Error loading image: $url, Error: $error');
          return _buildErrorWidget(textColor, error.toString());
        },
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 100),
      );
    } else {
      print('ProfileAvatar - No image URL provided (imageUrl: $imageUrl)');
      return _buildFallbackAvatar(textColor);
    }
  }

  Widget _buildLoadingPlaceholder(Color textColor) {
    return Container(
      color: AppColors.lightGray,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size * 0.4,
              height: size * 0.4,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(textColor),
              ),
            ),
            if (size > 60) ...[
              const SizedBox(height: 4),
              Text(
                'Chargement...',
                style: TextStyle(
                  fontSize: 8,
                  color: textColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(Color textColor, String error) {
    return Container(
      color: Colors.red.withValues(alpha: 0.1),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: size * 0.3,
            ),
            if (size > 60) ...[
              const SizedBox(height: 2),
              Text(
                'Erreur',
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.red,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackAvatar(Color textColor) {
    return Container(
      color: AppColors.lightGray,
      child: Center(
        child: Text(
          _getInitials(),
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  String _getInitials() {
    if (name == null || name!.isEmpty) {
      return 'U';
    }

    final words = name!.trim().split(' ');
    if (words.isEmpty) {
      return 'U';
    }

    if (words.length == 1) {
      return words[0][0].toUpperCase();
    }

    return '${words[0][0]}${words[words.length - 1][0]}'.toUpperCase();
  }
}

// Widget spécialisé pour les prestataires
class PrestataireAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final bool showBorder;

  const PrestataireAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 50.0,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileAvatar(
      imageUrl: imageUrl,
      name: name,
      size: size,
      backgroundColor: AppColors.purple.withValues(alpha: 0.1),
      textColor: AppColors.purple,
      showBorder: showBorder,
      borderColor: AppColors.purple.withValues(alpha: 0.3),
    );
  }
}

// Widget spécialisé pour les clients
class ClientAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final bool showBorder;

  const ClientAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 40.0,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileAvatar(
      imageUrl: imageUrl,
      name: name,
      size: size,
      backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
      textColor: AppColors.primaryBlue,
      showBorder: showBorder,
      borderColor: AppColors.primaryBlue.withValues(alpha: 0.3),
    );
  }
}
