import 'annotation_region.dart';
import 'analysis_guide.dart';

/// Tracks student answers, annotations, and reflections during an artwork analysis.
class UserAnalysisProgress {
  final String id;
  final String userId;
  final String artworkId;
  final PanofskyLevel level;
  final String userResponse;
  final List<AnnotationRegion> regions;
  final bool isCompleted;
  final DateTime updatedAt;

  const UserAnalysisProgress({
    required this.id,
    required this.userId,
    required this.artworkId,
    required this.level,
    required this.userResponse,
    required this.regions,
    this.isCompleted = false,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'artwork_id': artworkId,
      'level': level.code,
      'user_response': userResponse,
      'regions': regions.map((r) => r.toJson()).toList(),
      'is_completed': isCompleted,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory UserAnalysisProgress.fromJson(Map<String, dynamic> json) {
    return UserAnalysisProgress(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      artworkId: json['artwork_id'] as String,
      level: PanofskyLevel.fromCode(json['level'] as String? ?? 'formal'),
      userResponse: (json['user_response'] as String?) ?? '',
      regions: (json['regions'] as List<dynamic>?)
              ?.map((e) => AnnotationRegion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isCompleted: (json['is_completed'] as bool?) ?? false,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  UserAnalysisProgress copyWith({
    String? id,
    String? userId,
    String? artworkId,
    PanofskyLevel? level,
    String? userResponse,
    List<AnnotationRegion>? regions,
    bool? isCompleted,
    DateTime? updatedAt,
  }) {
    return UserAnalysisProgress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      artworkId: artworkId ?? this.artworkId,
      level: level ?? this.level,
      userResponse: userResponse ?? this.userResponse,
      regions: regions ?? this.regions,
      isCompleted: isCompleted ?? this.isCompleted,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
