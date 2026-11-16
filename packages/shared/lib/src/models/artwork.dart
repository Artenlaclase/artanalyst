/// Representation of an artwork metadata record in ArtAnalyst.
class Artwork {
  final String id;
  final String externalId;
  final String source; // 'met', 'cleveland', 'getty', 'smithsonian', 'louvre', 'wikimedia'
  final String title;
  final String? artistName;
  final String? dateDisplay;
  final String? medium;
  final String? dimensions;
  final String? description;
  final String metadataLicense;
  final String? officialUrl;
  final String? culture;
  final String? department;

  const Artwork({
    required this.id,
    required this.externalId,
    required this.source,
    required this.title,
    this.artistName,
    this.dateDisplay,
    this.medium,
    this.dimensions,
    this.description,
    this.metadataLicense = 'CC0',
    this.officialUrl,
    this.culture,
    this.department,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'external_id': externalId,
      'source': source,
      'title': title,
      'artist_name': artistName,
      'date_display': dateDisplay,
      'medium': medium,
      'dimensions': dimensions,
      'description': description,
      'metadata_license': metadataLicense,
      'official_url': officialUrl,
      'culture': culture,
      'department': department,
    };
  }

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      id: json['id'] as String,
      externalId: json['external_id'] as String,
      source: json['source'] as String,
      title: json['title'] as String,
      artistName: json['artist_name'] as String?,
      dateDisplay: json['date_display'] as String?,
      medium: json['medium'] as String?,
      dimensions: json['dimensions'] as String?,
      description: json['description'] as String?,
      metadataLicense: (json['metadata_license'] as String?) ?? 'CC0',
      officialUrl: json['official_url'] as String?,
      culture: json['culture'] as String?,
      department: json['department'] as String?,
    );
  }

  Artwork copyWith({
    String? id,
    String? externalId,
    String? source,
    String? title,
    String? artistName,
    String? dateDisplay,
    String? medium,
    String? dimensions,
    String? description,
    String? metadataLicense,
    String? officialUrl,
    String? culture,
    String? department,
  }) {
    return Artwork(
      id: id ?? this.id,
      externalId: externalId ?? this.externalId,
      source: source ?? this.source,
      title: title ?? this.title,
      artistName: artistName ?? this.artistName,
      dateDisplay: dateDisplay ?? this.dateDisplay,
      medium: medium ?? this.medium,
      dimensions: dimensions ?? this.dimensions,
      description: description ?? this.description,
      metadataLicense: metadataLicense ?? this.metadataLicense,
      officialUrl: officialUrl ?? this.officialUrl,
      culture: culture ?? this.culture,
      department: department ?? this.department,
    );
  }
}
