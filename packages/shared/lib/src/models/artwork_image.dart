import 'license_type.dart';

/// Digital reproduction image associated with an artwork.
/// Maintains clear separation between artwork antiquity and digital reproduction rights.
class ArtworkImage {
  final String id;
  final String artworkId;
  final String? imageUrl;
  final String? thumbnailUrl;
  final String? deepZoomManifestUrl; // DZI or IIIF info.json
  final LicenseType licenseType;
  final String? licenseUri;
  final String? attributionText;
  final bool isWorldwide;
  final LicenseSemaphore semaphoreColor;
  final int? width;
  final int? height;

  const ArtworkImage({
    required this.id,
    required this.artworkId,
    this.imageUrl,
    this.thumbnailUrl,
    this.deepZoomManifestUrl,
    required this.licenseType,
    this.licenseUri,
    this.attributionText,
    this.isWorldwide = false,
    required this.semaphoreColor,
    this.width,
    this.height,
  });

  /// Whether the app is legally allowed to display and host the image locally/directly
  bool get canDisplayDirectly => semaphoreColor != LicenseSemaphore.red && imageUrl != null;

  /// Whether the user can download and freely reuse offline without attribution
  bool get isPublicDomainOrCc0 => semaphoreColor == LicenseSemaphore.green;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'artwork_id': artworkId,
      'image_url': imageUrl,
      'thumbnail_url': thumbnailUrl,
      'deep_zoom_manifest_url': deepZoomManifestUrl,
      'license_type': licenseType.code,
      'license_uri': licenseUri ?? licenseType.uri,
      'attribution_text': attributionText,
      'is_worldwide': isWorldwide,
      'semaphore_color': semaphoreColor.code,
      'width': width,
      'height': height,
    };
  }

  factory ArtworkImage.fromJson(Map<String, dynamic> json) {
    final licenseCode = json['license_type'] as String?;
    final licenseType = LicenseType.fromCode(licenseCode);
    final semaphoreCode = json['semaphore_color'] as String? ?? 'R';
    final semaphoreColor = LicenseSemaphore.fromCode(semaphoreCode);

    return ArtworkImage(
      id: json['id'] as String,
      artworkId: json['artwork_id'] as String,
      imageUrl: json['image_url'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      deepZoomManifestUrl: json['deep_zoom_manifest_url'] as String?,
      licenseType: licenseType,
      licenseUri: json['license_uri'] as String?,
      attributionText: json['attribution_text'] as String?,
      isWorldwide: (json['is_worldwide'] as bool?) ?? false,
      semaphoreColor: semaphoreColor,
      width: json['width'] as int?,
      height: json['height'] as int?,
    );
  }
}
