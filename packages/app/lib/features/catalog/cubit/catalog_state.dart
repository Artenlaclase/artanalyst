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
  final String searchQuery;

  const CatalogLoaded({
    required this.artworks,
    required this.primaryImages,
    this.filterSource,
    this.filterSemaphore,
    this.searchQuery = '',
  });

  List<Artwork> get filteredArtworks {
    final isSearching = searchQuery.trim().isNotEmpty;
    final explicitlyFilteredRed = filterSemaphore == LicenseSemaphore.red;

    return artworks.where((a) {
      final img = primaryImages[a.id];

      // En la pantalla de inicio (sin búsqueda ni filtro rojo explícito):
      // Solo mostrar obras que se pueden ver en la app (con imagen digital autorizada)
      if (!isSearching && !explicitlyFilteredRed && filterSemaphore == null) {
        if (img?.semaphoreColor == LicenseSemaphore.red) {
          return false;
        }
      }

      if (filterSource != null && filterSource!.isNotEmpty && a.source != filterSource) {
        return false;
      }
      if (filterSemaphore != null) {
        if (img?.semaphoreColor != filterSemaphore) return false;
      }
      if (isSearching) {
        final q = searchQuery.toLowerCase().trim();
        final matchTitle = a.title.toLowerCase().contains(q);
        final matchArtist = (a.artistName ?? '').toLowerCase().contains(q);
        final matchSource = a.source.toLowerCase().contains(q);
        if (!matchTitle && !matchArtist && !matchSource) return false;
      }
      return true;
    }).toList();
  }
}

class CatalogError extends CatalogState {
  final String message;
  const CatalogError(this.message);
}
