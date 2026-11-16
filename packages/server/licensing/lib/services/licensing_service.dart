import 'dart:collection';
import 'package:art_analyst_shared/shared.dart';
import '../ports/museum_api_port.dart';
import '../adapters/met_museum_adapter.dart';
import '../adapters/cleveland_museum_adapter.dart';
import '../adapters/wikimedia_adapter.dart';
import '../adapters/additional_adapters.dart';

/// Comprehensive response for license resolution in ArtAnalyst.
class ResolvedLicenseResponse {
  final String source;
  final String externalId;
  final String title;
  final String? artistName;
  final LicenseSemaphore semaphore;
  final LicenseType licenseType;
  final String? imageUrl;
  final String? thumbnailUrl;
  final String? attributionText;
  final bool canDisplayImage;
  final bool isWorldwide;
  final String legalReason;
  final String officialSourceUrl;
  final Map<String, dynamic> educationalGuide;
  final bool fromCache;

  const ResolvedLicenseResponse({
    required this.source,
    required this.externalId,
    required this.title,
    this.artistName,
    required this.semaphore,
    required this.licenseType,
    this.imageUrl,
    this.thumbnailUrl,
    this.attributionText,
    required this.canDisplayImage,
    required this.isWorldwide,
    required this.legalReason,
    required this.officialSourceUrl,
    required this.educationalGuide,
    this.fromCache = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'source': source,
      'external_id': externalId,
      'title': title,
      'artist_name': artistName,
      'semaphore': semaphore.code,
      'semaphore_label': semaphore.label,
      'license_type': licenseType.code,
      'license_name': licenseType.name,
      'license_uri': licenseType.uri,
      'image_url': imageUrl,
      'thumbnail_url': thumbnailUrl,
      'attribution_text': attributionText,
      'can_display_image': canDisplayImage,
      'is_worldwide': isWorldwide,
      'legal_reason': legalReason,
      'official_source_url': officialSourceUrl,
      'educational_guide': educationalGuide,
      'from_cache': fromCache,
    };
  }
}

/// Orchestration service for license queries, resolution, and caching.
class LicensingService {
  final Map<String, MuseumApiPort> _adapters = {};
  final Map<String, ResolvedLicenseResponse> _cache = HashMap();

  LicensingService({List<MuseumApiPort>? customAdapters}) {
    final defaultAdapters = [
      MetMuseumAdapter(),
      ClevelandMuseumAdapter(),
      WikimediaAdapter(),
      GettyMuseumAdapter(),
      SmithsonianAdapter(),
      CopyrightProtectedAdapter(sourceId: 'louvre', institutionName: 'Musée du Louvre'),
      CopyrightProtectedAdapter(sourceId: 'prado', institutionName: 'Museo Nacional del Prado'),
    ];

    for (final adapter in (customAdapters ?? defaultAdapters)) {
      _adapters[adapter.sourceId.toLowerCase()] = adapter;
    }
  }

  /// Resolves digital reproduction license according to Section 5.2 workflow.
  Future<ResolvedLicenseResponse?> resolveLicense({
    required String source,
    required String externalId,
    bool bypassCache = false,
  }) async {
    final cacheKey = '${source.toLowerCase()}:$externalId';
    if (!bypassCache && _cache.containsKey(cacheKey)) {
      final cached = _cache[cacheKey]!;
      return ResolvedLicenseResponse(
        source: cached.source,
        externalId: cached.externalId,
        title: cached.title,
        artistName: cached.artistName,
        semaphore: cached.semaphore,
        licenseType: cached.licenseType,
        imageUrl: cached.imageUrl,
        thumbnailUrl: cached.thumbnailUrl,
        attributionText: cached.attributionText,
        canDisplayImage: cached.canDisplayImage,
        isWorldwide: cached.isWorldwide,
        legalReason: cached.legalReason,
        officialSourceUrl: cached.officialSourceUrl,
        educationalGuide: cached.educationalGuide,
        fromCache: true,
      );
    }

    final adapter = _adapters[source.toLowerCase()];
    if (adapter == null) {
      // Unknown source -> default to Red
      final redResult = LicenseEvaluator.evaluate(
        source: source,
        title: 'Obra en institución externa',
        institution: source,
        officialSourceUrl: 'https://google.com/search?q=$source+$externalId',
      );
      final guide = AttributionFormatter.generateEducationalGuide(redResult.licenseType, redResult.semaphore);

      return ResolvedLicenseResponse(
        source: source,
        externalId: externalId,
        title: 'Obra en $source',
        artistName: null,
        semaphore: LicenseSemaphore.red,
        licenseType: LicenseType.copyright,
        imageUrl: null,
        attributionText: null,
        canDisplayImage: false,
        isWorldwide: false,
        legalReason: 'Fuente desconocida o no homologada por ArtAnalyst. Por precaución legal se marca en ROJO.',
        officialSourceUrl: 'https://google.com/search?q=$source+$externalId',
        educationalGuide: guide,
      );
    }

    final rawData = await adapter.fetchArtwork(externalId);
    if (rawData == null) return null;

    final evaluation = LicenseEvaluator.evaluate(
      source: rawData.source,
      rawLicenseUri: rawData.rawLicenseUri,
      rawLicenseText: rawData.rawLicenseString,
      isOpenAccessFlag: rawData.isOpenAccess,
      isWorldwideFlag: rawData.isWorldwide,
      jurisdictionConstraint: rawData.jurisdiction,
      title: rawData.title,
      artistName: rawData.artistName,
      institution: adapter.institutionName,
      officialSourceUrl: rawData.officialUrl,
    );

    final guide = AttributionFormatter.generateEducationalGuide(evaluation.licenseType, evaluation.semaphore);

    final response = ResolvedLicenseResponse(
      source: rawData.source,
      externalId: rawData.externalId,
      title: rawData.title,
      artistName: rawData.artistName,
      semaphore: evaluation.semaphore,
      licenseType: evaluation.licenseType,
      imageUrl: evaluation.canDisplayImage ? rawData.rawImageUrl : null,
      thumbnailUrl: evaluation.canDisplayImage ? rawData.rawThumbnailUrl : null,
      attributionText: evaluation.attributionText,
      canDisplayImage: evaluation.canDisplayImage,
      isWorldwide: evaluation.isWorldwide,
      legalReason: evaluation.legalReason,
      officialSourceUrl: rawData.officialUrl,
      educationalGuide: guide,
      fromCache: false,
    );

    _cache[cacheKey] = response;
    return response;
  }
}
