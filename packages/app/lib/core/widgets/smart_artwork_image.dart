import 'package:flutter/material.dart';

/// Un widget inteligente y de alto rendimiento para renderizar obras de arte.
/// Prioriza imágenes empaquetadas localmente (0 ms de latencia) para garantizar
/// una carga instantánea y sin bloqueos de red o políticas de Wikimedia,
/// con respaldo automático a URLs remotas y placeholders estéticos de carga.
class SmartArtworkImage extends StatelessWidget {
  final String? artworkId;
  final String? imageUrl;
  final BoxFit fit;
  final int? cacheWidth;
  final String? placeholderTitle;
  final String? placeholderArtist;
  final double? width;
  final double? height;

  const SmartArtworkImage({
    super.key,
    this.artworkId,
    this.imageUrl,
    this.fit = BoxFit.cover,
    this.cacheWidth,
    this.placeholderTitle,
    this.placeholderArtist,
    this.width,
    this.height,
  });

  /// Mapeo de identificadores de obra a activos locales de alta fidelidad empaquetados.
  static const Map<String, String> localAssets = {
    'a1000000-0000-0000-0000-000000000001': 'assets/images/van_gogh.jpg',
    'a2000000-0000-0000-0000-000000000002': 'assets/images/monet.jpg',
    'a3000000-0000-0000-0000-000000000003': 'assets/images/vermeer.jpg',
    'a5000000-0000-0000-0000-000000000005': 'assets/images/friedrich.jpg',
  };

  @override
  Widget build(BuildContext context) {
    // 1. Verificar si existe un activo local pre-cargado para este ID de obra
    final localAsset = artworkId != null ? localAssets[artworkId] : null;

    if (localAsset != null) {
      return Image.asset(
        localAsset,
        fit: fit,
        width: width,
        height: height,
        cacheWidth: cacheWidth,
        errorBuilder: (context, error, stackTrace) {
          // Si el activo local fallara por alguna razón, usar la URL de red
          return _buildFromUrl(context, imageUrl);
        },
      );
    }

    return _buildFromUrl(context, imageUrl);
  }

  Widget _buildFromUrl(BuildContext context, String? url) {
    if (url == null || url.isEmpty) {
      return _buildFallback(context);
    }

    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        fit: fit,
        width: width,
        height: height,
        cacheWidth: cacheWidth,
        errorBuilder: (context, error, stackTrace) => _buildFallback(context),
      );
    }

    return Image.network(
      url,
      fit: fit,
      width: width,
      height: height,
      cacheWidth: cacheWidth,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: const Color(0xFF2E2421),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Theme.of(context).colorScheme.primary,
                    value: progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                        : null,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  progress.expectedTotalBytes != null
                      ? '${((progress.cumulativeBytesLoaded / progress.expectedTotalBytes!) * 100).toInt()}%'
                      : 'Cargando...',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => _buildFallback(context),
    );
  }

  Widget _buildFallback(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF5D4037).withOpacity(0.9),
            const Color(0xFF2E1C14),
          ],
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.palette_rounded, size: 36, color: Colors.amberAccent),
            if (placeholderTitle != null) ...[
              const SizedBox(height: 8),
              Text(
                placeholderTitle!,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
            if (placeholderArtist != null) ...[
              const SizedBox(height: 4),
              Text(
                placeholderArtist!,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
