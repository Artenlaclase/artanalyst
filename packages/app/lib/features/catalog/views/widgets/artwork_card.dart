import 'package:flutter/material.dart';
import 'package:art_analyst_shared/shared.dart';
import '../../licensing/widgets/license_badge.dart';

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
                    Image.network(
                      image!.thumbnailUrl ?? image!.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, st) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.broken_image, size: 36, color: Colors.grey),
                      ),
                    )
                  else
                    Container(
                      color: const Color(0xFF2B2020),
                      padding: const EdgeInsets.all(16),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shield_outlined, size: 36, color: Color(0xFFE57373)),
                          SizedBox(height: 8),
                          Text(
                            'Reproducción protegida',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFFFCDD2),
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Solo enlace a museo',
                            style: TextStyle(color: Colors.white70, fontSize: 10),
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
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          artwork.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          artwork.artistName ?? 'Artista desconocido',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                        ),
                        if (artwork.dateDisplay != null)
                          Text(
                            artwork.dateDisplay!,
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Método Panofsky',
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
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
