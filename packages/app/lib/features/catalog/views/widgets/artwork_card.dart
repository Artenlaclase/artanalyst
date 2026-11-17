import 'package:flutter/material.dart';
import 'package:art_analyst_shared/shared.dart';
import 'package:art_analyst_app/features/licensing/widgets/license_badge.dart';
import 'package:art_analyst_app/core/widgets/smart_artwork_image.dart';

/// Catalog card presenting an artwork with its metadata and license semaphore.
class ArtworkCard extends StatelessWidget {
  final Artwork artwork;
  final ArtworkImage? image;
  final VoidCallback onTap;

  const ArtworkCard({
    super.key,
    required this.artwork,
    this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasDirectImage = image != null && image!.canDisplayDirectly;
    final semaphore = image?.semaphoreColor ?? LicenseSemaphore.red;
    final licenseType = image?.licenseType ?? LicenseType.copyright;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Artwork Image / Red placeholder banner
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (hasDirectImage)
                    SmartArtworkImage(
                      artworkId: artwork.id,
                      imageUrl: image!.thumbnailUrl ?? image!.imageUrl,
                      fit: BoxFit.cover,
                      cacheWidth: 600,
                      placeholderTitle: artwork.title,
                      placeholderArtist: artwork.artistName,
                    )
                  else
                    Container(
                      color: const Color(0xFF261D1D),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC62828).withOpacity(0.18),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.shield_outlined, size: 28, color: Color(0xFFE57373)),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Derechos Reservados',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFFFCDD2),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Disponible para consultar en:\n${artwork.source.toUpperCase()}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70, fontSize: 10.5, height: 1.3),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Ver en web oficial', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                SizedBox(width: 4),
                                Icon(Icons.open_in_new_rounded, size: 10, color: Colors.white),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Semáforo Badge at top-right
                  Positioned(
                    top: 10,
                    right: 10,
                    child: LicenseBadge(
                      semaphore: semaphore,
                      licenseType: licenseType,
                      attributionText: image?.attributionText,
                      officialSourceUrl: artwork.officialUrl,
                      institutionName: artwork.source.toUpperCase(),
                      compact: true,
                    ),
                  ),

                  // Museum Source Tag at top-left
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        artwork.source.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Artwork Details
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Movement badge if available
                        if (artwork.department != null && artwork.department!.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              artwork.department!,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        Text(
                          artwork.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            height: 1.25,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          artwork.artistName ?? 'Artista desconocido',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85),
                          ),
                        ),
                        if (artwork.dateDisplay != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            artwork.dateDisplay!,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Analizar con Panofsky',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
