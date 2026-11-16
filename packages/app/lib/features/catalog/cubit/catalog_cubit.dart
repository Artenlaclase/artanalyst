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
        searchQuery: current.searchQuery,
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
        searchQuery: current.searchQuery,
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
        searchQuery: query,
      ));
    }
  }
}
