import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class PhotoViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final String? title;

  const PhotoViewer({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
    this.title,
  });

  @override
  State<PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  late PageController _pageController;
  late int _currentIndex;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // Images
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: widget.imageUrls.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Hero(
                    tag: 'image_$index',
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrls[index],
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Container(
                        color: Colors.black,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.black,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_not_supported,
                                color: Colors.white,
                                size: 64,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Impossible de charger l\'image',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Controls
            if (_showControls) _buildControls(),

            // Close button
            if (_showControls)
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 16,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            if (widget.title != null) ...[
              Text(
                widget.title!,
                style: AppTextStyles.h5.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],

            // Image counter
            if (widget.imageUrls.length > 1)
              Text(
                '${_currentIndex + 1} / ${widget.imageUrls.length}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white70,
                ),
              ),

            // Navigation dots
            if (widget.imageUrls.length > 1) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.imageUrls.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == _currentIndex
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
            ],

            // Action buttons
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Previous button
                if (widget.imageUrls.length > 1)
                  IconButton(
                    onPressed: _currentIndex > 0 ? _previousImage : null,
                    icon: Icon(
                      Icons.chevron_left,
                      color: _currentIndex > 0 ? Colors.white : Colors.white30,
                      size: 32,
                    ),
                  ),

                // Download button (placeholder)
                IconButton(
                  onPressed: _downloadImage,
                  icon: const Icon(
                    Icons.download,
                    color: Colors.white,
                    size: 24,
                  ),
                ),

                // Share button (placeholder)
                IconButton(
                  onPressed: _shareImage,
                  icon: const Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 24,
                  ),
                ),

                // Next button
                if (widget.imageUrls.length > 1)
                  IconButton(
                    onPressed: _currentIndex < widget.imageUrls.length - 1
                        ? _nextImage
                        : null,
                    icon: Icon(
                      Icons.chevron_right,
                      color: _currentIndex < widget.imageUrls.length - 1
                          ? Colors.white
                          : Colors.white30,
                      size: 32,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _previousImage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextImage() {
    if (_currentIndex < widget.imageUrls.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _downloadImage() {
    // TODO: Implement image download
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonction de téléchargement à implémenter'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareImage() {
    // TODO: Implement image sharing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonction de partage à implémenter'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

// Fonction utilitaire pour ouvrir le visualiseur
void showPhotoViewer(
  BuildContext context, {
  required List<String> imageUrls,
  int initialIndex = 0,
  String? title,
}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => PhotoViewer(
        imageUrls: imageUrls,
        initialIndex: initialIndex,
        title: title,
      ),
    ),
  );
}

