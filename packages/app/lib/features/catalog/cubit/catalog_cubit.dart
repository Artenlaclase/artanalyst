import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:art_analyst_shared/shared.dart';
import '../../../data/repositories/artwork_repository.dart';
import 'catalog_state.dart';

class CatalogCubit extends Cubit<CatalogState> {
  final ArtworkRepository _repository;

  CatalogCubit({required ArtworkRepository repository})
      : _repository = repository,
        super(const CatalogInitial());

  Future<void> loadCatalog() async {
    emit(const CatalogLoading());
    try {
      final artworks = await _repository.fetchArtworks();
      final images = await _repository.fetchPrimaryImages();
      emit(CatalogLoaded(artworks: artworks, primaryImages: images));
    } catch (e) {
      emit(CatalogError('Error al cargar catálogo: $e'));
    }
  }

  void filterBySource(String? source) {
    if (state is CatalogLoaded) {
      final current = state as CatalogLoaded;
      emit(CatalogLoaded(
        artworks: current.artworks,
        primaryImages: current.primaryImages,
        filterSource: source,
        filterSemaphore: current.filterSemaphore,
        filterMovement: current.filterMovement,
        filterArtist: current.filterArtist,
        searchQuery: current.searchQuery,
        visibleCount: 6,
      ));
    }
  }

  void filterBySemaphore(LicenseSemaphore? semaphore) {
    if (state is CatalogLoaded) {
      final current = state as CatalogLoaded;
      emit(CatalogLoaded(
        artworks: current.artworks,
        primaryImages: current.primaryImages,
        filterSource: current.filterSource,
        filterSemaphore: semaphore,
        filterMovement: current.filterMovement,
        filterArtist: current.filterArtist,
        searchQuery: current.searchQuery,
        visibleCount: 6,
      ));
    }
  }

  void filterByMovement(String? movement) {
    if (state is CatalogLoaded) {
      final current = state as CatalogLoaded;
      emit(CatalogLoaded(
        artworks: current.artworks,
        primaryImages: current.primaryImages,
        filterSource: current.filterSource,
        filterSemaphore: current.filterSemaphore,
        filterMovement: movement,
        filterArtist: current.filterArtist,
        searchQuery: current.searchQuery,
        visibleCount: 6,
      ));
    }
  }

  void filterByArtist(String? artist) {
    if (state is CatalogLoaded) {
      final current = state as CatalogLoaded;
      emit(CatalogLoaded(
        artworks: current.artworks,
        primaryImages: current.primaryImages,
        filterSource: current.filterSource,
        filterSemaphore: current.filterSemaphore,
        filterMovement: current.filterMovement,
        filterArtist: artist,
        searchQuery: current.searchQuery,
        visibleCount: 6,
      ));
    }
  }

  void search(String query) {
    if (state is CatalogLoaded) {
      final current = state as CatalogLoaded;
      emit(CatalogLoaded(
        artworks: current.artworks,
        primaryImages: current.primaryImages,
        filterSource: current.filterSource,
        filterSemaphore: current.filterSemaphore,
        filterMovement: current.filterMovement,
        filterArtist: current.filterArtist,
        searchQuery: query,
        visibleCount: 6,
      ));
    }
  }

  void loadMoreArtworks() {
    if (state is CatalogLoaded) {
      final current = state as CatalogLoaded;
      emit(CatalogLoaded(
        artworks: current.artworks,
        primaryImages: current.primaryImages,
        filterSource: current.filterSource,
        filterSemaphore: current.filterSemaphore,
        filterMovement: current.filterMovement,
        filterArtist: current.filterArtist,
        searchQuery: current.searchQuery,
        visibleCount: current.visibleCount + 6,
      ));
    }
  }

  void resetFilters() {
    if (state is CatalogLoaded) {
      final current = state as CatalogLoaded;
      emit(CatalogLoaded(
        artworks: current.artworks,
        primaryImages: current.primaryImages,
        filterSource: null,
        filterSemaphore: null,
        filterMovement: null,
        filterArtist: null,
        searchQuery: '',
        visibleCount: 6,
      ));
    }
  }
}
