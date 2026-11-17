import 'package:art_analyst_shared/shared.dart';

abstract class CatalogState {
  const CatalogState();
}

class CatalogInitial extends CatalogState {
  const CatalogInitial();
}

class CatalogLoading extends CatalogState {
  const CatalogLoading();
}

class CatalogLoaded extends CatalogState {
  final List<Artwork> artworks;
  final Map<String, ArtworkImage> primaryImages;
  final String? filterSource;
  final LicenseSemaphore? filterSemaphore;
  final String? filterMovement;
  final String? filterArtist;
  final String searchQuery;
  final int visibleCount;

  const CatalogLoaded({
    required this.artworks,
    required this.primaryImages,
    this.filterSource,
    this.filterSemaphore,
    this.filterMovement,
    this.filterArtist,
    this.searchQuery = '',
    this.visibleCount = 6,
  });

  List<Artwork> get filteredArtworks {
    final isSearching = searchQuery.trim().isNotEmpty;
    final explicitlyFilteredRed = filterSemaphore == LicenseSemaphore.red;

    return artworks.where((a) {
      final img = primaryImages[a.id];

      // En la pantalla inicial (sin búsqueda, sin filtro rojo específico):
      // Ocultar obras con derechos reservados solo si no se filtró explícitamente
      if (!isSearching && !explicitlyFilteredRed && filterSemaphore == null && filterMovement == null && filterArtist == null) {
        if (img?.semaphoreColor == LicenseSemaphore.red) {
          return false;
        }
      }

      if (filterSource != null && filterSource!.isNotEmpty && a.source != filterSource) {
        return false;
      }
      if (filterSemaphore != null && img?.semaphoreColor != filterSemaphore) {
        return false;
      }
      if (filterMovement != null && filterMovement!.isNotEmpty) {
        if ((a.department ?? '').toLowerCase() != filterMovement!.toLowerCase()) {
          return false;
        }
      }
      if (filterArtist != null && filterArtist!.isNotEmpty) {
        if (!(a.artistName ?? '').toLowerCase().contains(filterArtist!.toLowerCase())) {
          return false;
        }
      }
      if (isSearching) {
        final q = searchQuery.toLowerCase().trim();
        final matchTitle = a.title.toLowerCase().contains(q);
        final matchArtist = (a.artistName ?? '').toLowerCase().contains(q);
        final matchMovement = (a.department ?? '').toLowerCase().contains(q);
        final matchSource = a.source.toLowerCase().contains(q);
        if (!matchTitle && !matchArtist && !matchMovement && !matchSource) return false;
      }
      return true;
    }).toList();
  }

  /// Paged subset of artworks according to current visibleCount
  List<Artwork> get pagedArtworks {
    final list = filteredArtworks;
    if (list.length <= visibleCount) return list;
    return list.take(visibleCount).toList();
  }

  bool get hasMoreToLoad => filteredArtworks.length > visibleCount;

  int get totalMatchingCount => filteredArtworks.length;
}

class CatalogError extends CatalogState {
  final String message;
  const CatalogError(this.message);
}
