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
    return artworks.where((a) {
      if (filterSource != null && filterSource!.isNotEmpty && a.source != filterSource) {
        return false;
      }
      if (filterSemaphore != null) {
        final img = primaryImages[a.id];
        if (img?.semaphoreColor != filterSemaphore) return false;
      }
      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final matchTitle = a.title.toLowerCase().contains(q);
        final matchArtist = (a.artistName ?? '').toLowerCase().contains(q);
        if (!matchTitle && !matchArtist) return false;
      }
      return true;
    }).toList();
  }
}

class CatalogError extends CatalogState {
  final String message;
  const CatalogError(this.message);
}
