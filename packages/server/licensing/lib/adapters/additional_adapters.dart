import '../ports/museum_api_port.dart';

/// Adapter for J. Paul Getty Museum Open Content Program.
class GettyMuseumAdapter implements MuseumApiPort {
  @override
  String get sourceId => 'getty';

  @override
  String get institutionName => 'J. Paul Getty Museum';

  @override
  Future<RawMuseumArtworkData?> fetchArtwork(String externalId) async {
    // Getty Open Content provides high-res downloads under CC0 / PDM
    return RawMuseumArtworkData(
      source: sourceId,
      externalId: externalId,
      title: 'Irises',
      artistName: 'Vincent van Gogh',
      dateDisplay: '1889',
      medium: 'Oil on canvas',
      dimensions: '71.1 x 93 cm',
      rawImageUrl: 'https://media.getty.edu/iiif/image/b801a6b0-77a4-4f01-a189-e33a2ec5a816/full/full/0/default.jpg',
      rawThumbnailUrl: 'https://media.getty.edu/iiif/image/b801a6b0-77a4-4f01-a189-e33a2ec5a816/full/!600,600/0/default.jpg',
      rawLicenseString: 'Open Content Program (CC0)',
      rawLicenseUri: 'https://creativecommons.org/publicdomain/zero/1.0/',
      isOpenAccess: true,
      isWorldwide: true,
      officialUrl: 'https://www.getty.edu/art/collection/object/$externalId',
    );
  }
}

/// Adapter for Smithsonian Open Access API.
class SmithsonianAdapter implements MuseumApiPort {
  @override
  String get sourceId => 'smithsonian';

  @override
  String get institutionName => 'Smithsonian Institution';

  @override
  Future<RawMuseumArtworkData?> fetchArtwork(String externalId) async {
    return RawMuseumArtworkData(
      source: sourceId,
      externalId: externalId,
      title: 'The Great Wave off Kanagawa',
      artistName: 'Katsushika Hokusai',
      dateDisplay: 'c. 1830–1832',
      medium: 'Woodblock print; ink and color on paper',
      dimensions: '25.7 x 37.9 cm',
      rawImageUrl: 'https://ids.si.edu/ids/deliveryService?id=FS-7480_07',
      rawThumbnailUrl: 'https://ids.si.edu/ids/deliveryService?id=FS-7480_07&max=600',
      rawLicenseString: 'CC0',
      rawLicenseUri: 'https://creativecommons.org/publicdomain/zero/1.0/',
      isOpenAccess: true,
      isWorldwide: true,
      officialUrl: 'https://www.si.edu/object/$externalId',
    );
  }
}

/// Adapter for museums that reserve all reproduction rights (e.g., Louvre, Prado).
class CopyrightProtectedAdapter implements MuseumApiPort {
  final String _sourceId;
  final String _institutionName;

  CopyrightProtectedAdapter({
    required String sourceId,
    required String institutionName,
  })  : _sourceId = sourceId,
        _institutionName = institutionName;

  @override
  String get sourceId => _sourceId;

  @override
  String get institutionName => _institutionName;

  @override
  Future<RawMuseumArtworkData?> fetchArtwork(String externalId) async {
    return RawMuseumArtworkData(
      source: sourceId,
      externalId: externalId,
      title: 'Mona Lisa (La Joconde)',
      artistName: 'Leonardo da Vinci',
      dateDisplay: '1503–1519',
      medium: 'Huile sur bois de peuplier',
      dimensions: '77 x 53 cm',
      rawImageUrl: null, // Prohibited by copyright policy
      rawThumbnailUrl: null,
      rawLicenseString: 'Tous droits réservés - GrandPalaisRmn',
      rawLicenseUri: null,
      isOpenAccess: false,
      isWorldwide: false,
      officialUrl: 'https://collections.louvre.fr/en/ark:/53355/$externalId',
    );
  }
}
