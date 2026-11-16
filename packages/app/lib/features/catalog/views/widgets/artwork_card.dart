import 'package:flutter/material.dart';
import 'package:art_analyst_shared/shared.dart';
import 'package:art_analyst_app/features/licensing/widgets/license_badge.dart';

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
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF8B4513).withOpacity(0.85),
                              const Color(0xFF3E2723),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.palette_rounded, size: 36, color: Colors.amberAccent),
                            const SizedBox(height: 8),
                            Text(
                              artwork.title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              artwork.artistName ?? '',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: const TextStyle(color: Colors.white70, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
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
