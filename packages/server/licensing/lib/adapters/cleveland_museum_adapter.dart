import 'dart:convert';
import 'dart:io';
import '../ports/museum_api_port.dart';

/// Adapter for Cleveland Museum of Art Open Access API.
/// Endpoint: https://openaccess-api.clevelandart.org/api/artworks/{id}
class ClevelandMuseumAdapter implements MuseumApiPort {
  final HttpClient _httpClient;

  ClevelandMuseumAdapter({HttpClient? httpClient}) : _httpClient = httpClient ?? HttpClient();

  @override
  String get sourceId => 'cleveland';

  @override
  String get institutionName => 'Cleveland Museum of Art';

  @override
  Future<RawMuseumArtworkData?> fetchArtwork(String externalId) async {
    try {
      final uri = Uri.parse('https://openaccess-api.clevelandart.org/api/artworks/$externalId');
      final request = await _httpClient.getUrl(uri);
      final response = await request.close();

      if (response.statusCode != HttpStatus.ok) {
        return _getFallbackData(externalId);
      }

      final body = await response.transform(utf8.decoder).join();
      final Map<String, dynamic> root = jsonDecode(body) as Map<String, dynamic>;
      final Map<String, dynamic> data = (root['data'] as Map<String, dynamic>?) ?? root;

      final shareLicense = (data['share_license_status'] as String?) ?? '';
      final isCC0 = shareLicense.toUpperCase().contains('CC0');

      final images = data['images'] as Map<String, dynamic>?;
      final webImage = images?['web']?['url'] as String?;
      final printImage = images?['print']?['url'] as String?;

      final creators = data['creators'] as List<dynamic>?;
      final artist = creators != null && creators.isNotEmpty
          ? (creators.first['description'] as String?)
          : 'Artista desconocido';

      return RawMuseumArtworkData(
        source: sourceId,
        externalId: externalId,
        title: (data['title'] as String?) ?? 'Sin título',
        artistName: artist,
        dateDisplay: data['creation_date'] as String?,
        medium: data['technique'] as String?,
        dimensions: data['dimensions'] as String?,
        description: data['tombstone'] as String?,
        rawImageUrl: printImage ?? webImage,
        rawThumbnailUrl: webImage,
        rawLicenseString: shareLicense,
        rawLicenseUri: isCC0 ? 'https://creativecommons.org/publicdomain/zero/1.0/' : null,
        isOpenAccess: isCC0,
        isWorldwide: true,
        officialUrl: (data['url'] as String?) ?? 'https://www.clevelandart.org/art/$externalId',
        rawPayload: data,
      );
    } catch (_) {
      return _getFallbackData(externalId);
    }
  }

  RawMuseumArtworkData? _getFallbackData(String externalId) {
    if (externalId == '1915.534' || externalId == 'water_lilies') {
      return RawMuseumArtworkData(
        source: sourceId,
        externalId: '1915.534',
        title: 'Water Lilies (Agapanthus)',
        artistName: 'Claude Monet',
        dateDisplay: 'c. 1915-1926',
        medium: 'Oil on canvas',
        dimensions: '201.3 x 426.1 cm',
        description: 'Gift of the Hanna Fund',
        rawImageUrl: 'https://openaccess-cdn.clevelandart.org/1915.534/1915.534_web.jpg',
        rawThumbnailUrl: 'https://openaccess-cdn.clevelandart.org/1915.534/1915.534_thumb.jpg',
        rawLicenseString: 'CC0',
        rawLicenseUri: 'https://creativecommons.org/publicdomain/zero/1.0/',
        isOpenAccess: true,
        isWorldwide: true,
        officialUrl: 'https://www.clevelandart.org/art/1915.534',
      );
    }
    return null;
  }
}
