/// A region of interest (ROI) marked by a student or educator on the artwork.
class AnnotationRegion {
  final String id;
  final double x; // Normalized 0.0 to 1.0 (relative to artwork width)
  final double y; // Normalized 0.0 to 1.0 (relative to artwork height)
  final double width; // Normalized width
  final double height; // Normalized height
  final String label;
  final String notes;
  final String category; // 'composition', 'symbol', 'color', 'brushwork', 'focal_point'
  final String colorHex;
  final DateTime createdAt;

  const AnnotationRegion({
    required this.id,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.label,
    required this.notes,
    this.category = 'composition',
    this.colorHex = '#2196F3',
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'label': label,
      'notes': notes,
      'category': category,
      'color_hex': colorHex,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory AnnotationRegion.fromJson(Map<String, dynamic> json) {
    return AnnotationRegion(
      id: json['id'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      label: json['label'] as String,
      notes: (json['notes'] as String?) ?? '',
      category: (json['category'] as String?) ?? 'composition',
      colorHex: (json['color_hex'] as String?) ?? '#2196F3',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}
