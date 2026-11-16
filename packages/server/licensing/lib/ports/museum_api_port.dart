import 'package:art_analyst_shared/shared.dart';

/// Raw artwork response from a museum or external institution API.
class RawMuseumArtworkData {
  final String source;
  final String externalId;
  final String title;
  final String? artistName;
  final String? dateDisplay;
  final String? medium;
  final String? dimensions;
  final String? description;
  final String? rawImageUrl;
  final String? rawThumbnailUrl;
  final String? rawLicenseString;
  final String? rawLicenseUri;
  final bool isOpenAccess;
  final bool isWorldwide;
  final String? jurisdiction;
  final String officialUrl;
  final Map<String, dynamic> rawPayload;

  const RawMuseumArtworkData({
    required this.source,
    required this.externalId,
    required this.title,
    this.artistName,
    this.dateDisplay,
    this.medium,
    this.dimensions,
    this.description,
    this.rawImageUrl,
    this.rawThumbnailUrl,
    this.rawLicenseString,
    this.rawLicenseUri,
    this.isOpenAccess = false,
    this.isWorldwide = true,
    this.jurisdiction,
    required this.officialUrl,
    this.rawPayload = const {},
  });
}

/// Port for querying diverse museum and repository APIs (Hexagonal Architecture).
abstract class MuseumApiPort {
  /// Unique source identifier (e.g. 'met', 'cleveland', 'wikimedia')
  String get sourceId;

  /// Human-readable institution name
  String get institutionName;

  /// Fetches raw metadata and digital rights from the museum's remote API
  Future<RawMuseumArtworkData?> fetchArtwork(String externalId);
}
