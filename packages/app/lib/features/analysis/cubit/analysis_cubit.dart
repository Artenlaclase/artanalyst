import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:art_analyst_shared/shared.dart';
import '../../../data/repositories/artwork_repository.dart';
import 'analysis_state.dart';

class AnalysisCubit extends Cubit<AnalysisState> {
  final ArtworkRepository _repository;
  final String userId;

  AnalysisCubit({
    required ArtworkRepository repository,
    this.userId = 'estudiante-demo-01',
  })  : _repository = repository,
        super(const AnalysisInitial());

  Future<void> loadArtworkAnalysis(Artwork artwork, ArtworkImage? image) async {
    emit(const AnalysisLoading());
    try {
      final guides = await _repository.fetchGuides(artwork.id);
      final progressList = await _repository.fetchUserProgress(userId, artwork.id);

      // Collect initial regions from progress or provide defaults
      final regions = <AnnotationRegion>[];
      for (final p in progressList) {
        regions.addAll(p.regions);
      }

      emit(AnalysisLoaded(
        artwork: artwork,
        image: image,
        guides: guides,
        regions: regions,
        userProgress: progressList,
      ));
    } catch (e) {
      emit(AnalysisError('Error al cargar guías de análisis: $e'));
    }
  }

  void addRegion(AnnotationRegion region) {
    if (state is AnalysisLoaded) {
      final current = state as AnalysisLoaded;
      final updated = List<AnnotationRegion>.from(current.regions)..add(region);
      emit(current.copyWith(regions: updated));
    }
  }

  void deleteRegion(String regionId) {
    if (state is AnalysisLoaded) {
      final current = state as AnalysisLoaded;
      final updated = current.regions.where((r) => r.id != regionId).toList();
      emit(current.copyWith(regions: updated));
    }
  }

  Future<void> saveStepResponse(PanofskyLevel level, String response, bool isCompleted) async {
    if (state is AnalysisLoaded) {
      final current = state as AnalysisLoaded;
      final progress = UserAnalysisProgress(
        id: 'prog-${current.artwork.id}-${level.code}',
        userId: userId,
        artworkId: current.artwork.id,
        level: level,
        userResponse: response,
        regions: current.regions,
        isCompleted: isCompleted,
        updatedAt: DateTime.now(),
      );

      final updatedList = List<UserAnalysisProgress>.from(current.userProgress)
        ..removeWhere((p) => p.level == level)
        ..add(progress);

      emit(current.copyWith(userProgress: updatedList));
      await _repository.saveProgress(progress);
    }
  }
}
