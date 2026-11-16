import 'package:art_analyst_shared/shared.dart';

abstract class AnalysisState {
  const AnalysisState();
}

class AnalysisInitial extends AnalysisState {
  const AnalysisInitial();
}

class AnalysisLoading extends AnalysisState {
  const AnalysisLoading();
}

class AnalysisLoaded extends AnalysisState {
  final Artwork artwork;
  final ArtworkImage? image;
  final List<AnalysisGuide> guides;
  final List<AnnotationRegion> regions;
  final List<UserAnalysisProgress> userProgress;
  final PanofskyLevel currentLevel;

  const AnalysisLoaded({
    required this.artwork,
    this.image,
    required this.guides,
    required this.regions,
    required this.userProgress,
    this.currentLevel = PanofskyLevel.formal,
  });

  AnalysisLoaded copyWith({
    Artwork? artwork,
    ArtworkImage? image,
    List<AnalysisGuide>? guides,
    List<AnnotationRegion>? regions,
    List<UserAnalysisProgress>? userProgress,
    PanofskyLevel? currentLevel,
  }) {
    return AnalysisLoaded(
      artwork: artwork ?? this.artwork,
      image: image ?? this.image,
      guides: guides ?? this.guides,
      regions: regions ?? this.regions,
      userProgress: userProgress ?? this.userProgress,
      currentLevel: currentLevel ?? this.currentLevel,
    );
  }
}

class AnalysisError extends AnalysisState {
  final String message;
  const AnalysisError(this.message);
}
