import '../models/license_type.dart';
import 'attribution_formatter.dart';

/// Evaluation result detailing semaphore color, resolved license, attribution, and display policy.
class LicenseEvaluationResult {
  final LicenseSemaphore semaphore;
  final LicenseType licenseType;
  final String? attributionText;
  final bool isWorldwide;
  final bool canDisplayImage;
  final String legalReason;
  final String? officialSourceUrl;

  const LicenseEvaluationResult({
    required this.semaphore,
    required this.licenseType,
    this.attributionText,
    required this.isWorldwide,
    required this.canDisplayImage,
    required this.legalReason,
    this.officialSourceUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'semaphore': semaphore.code,
      'license_type': licenseType.code,
      'attribution_text': attributionText,
      'is_worldwide': isWorldwide,
      'can_display_image': canDisplayImage,
      'legal_reason': legalReason,
      'official_source_url': officialSourceUrl,
    };
  }
}

/// The core legal rules engine of ArtAnalyst.
/// Evaluates rights of the digital reproduction (not just artwork antiquity).
class LicenseEvaluator {
  /// Evaluates license rights according to source and metadata.
  static LicenseEvaluationResult evaluate({
    required String source,
    String? rawLicenseUri,
    String? rawLicenseText,
    bool isOpenAccessFlag = false,
    bool isWorldwideFlag = true,
    String? jurisdictionConstraint,
    required String title,
    String? artistName,
    required String institution,
    String? officialSourceUrl,
  }) {
    final normalizedSource = source.toLowerCase().trim();
    final normalizedUri = (rawLicenseUri ?? '').toLowerCase().trim();
    final normalizedText = (rawLicenseText ?? '').toLowerCase().trim();

    // 1. High-trust CC0 museum APIs (The Met, Cleveland, Getty, Smithsonian)
    if (normalizedSource == 'met') {
      if (isOpenAccessFlag) {
        return LicenseEvaluationResult(
          semaphore: LicenseSemaphore.green,
          licenseType: LicenseType.cc0,
          attributionText: AttributionFormatter.format(
            title: title,
            artistName: artistName,
            institution: 'The Metropolitan Museum of Art (Open Access)',
            licenseType: LicenseType.cc0,
            officialSourceUrl: officialSourceUrl,
          ),
          isWorldwide: true,
          canDisplayImage: true,
          legalReason: 'The Metropolitan Museum of Art ha liberado esta imagen bajo CC0 (Open Access).',
          officialSourceUrl: officialSourceUrl,
        );
      }
      return _buildRedResult(
        legalReason: 'La obra forma parte de The Met pero no tiene marcado Open Access para su fotografía.',
        officialSourceUrl: officialSourceUrl,
      );
    }

    if (normalizedSource == 'cleveland') {
      if (isOpenAccessFlag || normalizedText.contains('cc0')) {
        return LicenseEvaluationResult(
          semaphore: LicenseSemaphore.green,
          licenseType: LicenseType.cc0,
          attributionText: AttributionFormatter.format(
            title: title,
            artistName: artistName,
            institution: 'Cleveland Museum of Art (Open Access)',
            licenseType: LicenseType.cc0,
            officialSourceUrl: officialSourceUrl,
          ),
          isWorldwide: true,
          canDisplayImage: true,
          legalReason: 'Cleveland Museum of Art designa la imagen bajo Creative Commons Zero (CC0).',
          officialSourceUrl: officialSourceUrl,
        );
      }
      return _buildRedResult(
        legalReason: 'Cleveland Museum of Art reserva los derechos de reproducción digital para esta pieza.',
        officialSourceUrl: officialSourceUrl,
      );
    }

    if (normalizedSource == 'getty') {
      if (isOpenAccessFlag || normalizedText.contains('open content') || normalizedText.contains('cc0')) {
        return LicenseEvaluationResult(
          semaphore: LicenseSemaphore.green,
          licenseType: LicenseType.cc0,
          attributionText: AttributionFormatter.format(
            title: title,
            artistName: artistName,
            institution: 'J. Paul Getty Museum (Open Content Program)',
            licenseType: LicenseType.cc0,
            officialSourceUrl: officialSourceUrl,
          ),
          isWorldwide: true,
          canDisplayImage: true,
          legalReason: 'Imagen disponible bajo el Open Content Program del J. Paul Getty Trust.',
          officialSourceUrl: officialSourceUrl,
        );
      }
      return _buildRedResult(
        legalReason: 'El Getty Museum protege la fotografía digital bajo derechos reservados.',
        officialSourceUrl: officialSourceUrl,
      );
    }

    if (normalizedSource == 'smithsonian') {
      if (isOpenAccessFlag || normalizedText.contains('cc0')) {
        return LicenseEvaluationResult(
          semaphore: LicenseSemaphore.green,
          licenseType: LicenseType.cc0,
          attributionText: AttributionFormatter.format(
            title: title,
            artistName: artistName,
            institution: 'Smithsonian Open Access',
            licenseType: LicenseType.cc0,
            officialSourceUrl: officialSourceUrl,
          ),
          isWorldwide: true,
          canDisplayImage: true,
          legalReason: 'Smithsonian Institution Open Access designa el medio como CC0.',
          officialSourceUrl: officialSourceUrl,
        );
      }
      return _buildRedResult(
        legalReason: 'Imagen no incluida en Smithsonian Open Access.',
        officialSourceUrl: officialSourceUrl,
      );
    }

    // 2. Strict Filter for Aggregators (Europeana & Wikimedia Commons)
    if (normalizedSource == 'wikimedia' || normalizedSource == 'europeana') {
      // Must NOT have jurisdiction restrictions (e.g. pd-us, pd-1923, pd-italy)
      final hasJurisdictionConstraint = jurisdictionConstraint != null &&
          jurisdictionConstraint.trim().isNotEmpty &&
          !jurisdictionConstraint.toLowerCase().contains('worldwide') &&
          !jurisdictionConstraint.toLowerCase().contains('global');

      if (hasJurisdictionConstraint) {
        return _buildRedResult(
          legalReason: 'Rechazado por ArtAnalyst: Licencia limitada territorialmente ($jurisdictionConstraint). Se requiere dominio público mundial inequívoco.',
          officialSourceUrl: officialSourceUrl,
        );
      }

      final isCc0Uri = normalizedUri.contains('creativecommons.org/publicdomain/zero/1.0');
      final isPdmUri = normalizedUri.contains('creativecommons.org/publicdomain/mark/1.0');

      if (isCc0Uri) {
        return LicenseEvaluationResult(
          semaphore: LicenseSemaphore.green,
          licenseType: LicenseType.cc0,
          attributionText: AttributionFormatter.format(
            title: title,
            artistName: artistName,
            institution: normalizedSource == 'wikimedia' ? 'Wikimedia Commons' : 'Europeana',
            licenseType: LicenseType.cc0,
            officialSourceUrl: officialSourceUrl,
          ),
          isWorldwide: true,
          canDisplayImage: true,
          legalReason: 'Verificado CC0 de alcance mundial en agregador.',
          officialSourceUrl: officialSourceUrl,
        );
      }

      if (isPdmUri && isWorldwideFlag) {
        return LicenseEvaluationResult(
          semaphore: LicenseSemaphore.green,
          licenseType: LicenseType.publicDomainMark,
          attributionText: AttributionFormatter.format(
            title: title,
            artistName: artistName,
            institution: normalizedSource == 'wikimedia' ? 'Wikimedia Commons' : 'Europeana',
            licenseType: LicenseType.publicDomainMark,
            officialSourceUrl: officialSourceUrl,
          ),
          isWorldwide: true,
          canDisplayImage: true,
          legalReason: 'Marca de Dominio Público mundial confirmada sin restricciones.',
          officialSourceUrl: officialSourceUrl,
        );
      }

      // Any other license on Wikimedia/Europeana (CC-BY, non-commercial, copyright) is rejected to maintain absolute legal integrity
      return _buildRedResult(
        legalReason: 'ArtAnalyst rechaza reproducciones de Wikimedia/Europeana que no sean explícitamente CC0 o PDM mundial.',
        officialSourceUrl: officialSourceUrl,
      );
    }

    // 3. Generic Creative Commons evaluation (e.g. partner museums with CC BY / CC BY-SA)
    if (normalizedUri.contains('creativecommons.org/licenses/by-sa/') ||
        normalizedText.contains('cc-by-sa') ||
        normalizedText.contains('cc by-sa')) {
      return LicenseEvaluationResult(
        semaphore: LicenseSemaphore.yellow,
        licenseType: LicenseType.ccBySa,
        attributionText: AttributionFormatter.format(
          title: title,
          artistName: artistName,
          institution: institution,
          licenseType: LicenseType.ccBySa,
          officialSourceUrl: officialSourceUrl,
        ),
        isWorldwide: isWorldwideFlag,
        canDisplayImage: true,
        legalReason: 'Licencia Creative Commons BY-SA. Se muestra con atribución y aviso de ShareAlike.',
        officialSourceUrl: officialSourceUrl,
      );
    }

    if (normalizedUri.contains('creativecommons.org/licenses/by/') ||
        normalizedText.contains('cc-by') ||
        normalizedText.contains('cc by')) {
      return LicenseEvaluationResult(
        semaphore: LicenseSemaphore.yellow,
        licenseType: LicenseType.ccBy,
        attributionText: AttributionFormatter.format(
          title: title,
          artistName: artistName,
          institution: institution,
          licenseType: LicenseType.ccBy,
          officialSourceUrl: officialSourceUrl,
        ),
        isWorldwide: isWorldwideFlag,
        canDisplayImage: true,
        legalReason: 'Licencia Creative Commons Atribución (CC BY). Requiere crédito explícito.',
        officialSourceUrl: officialSourceUrl,
      );
    }

    if (normalizedUri.contains('publicdomain/zero') || normalizedText.contains('cc0')) {
      return LicenseEvaluationResult(
        semaphore: LicenseSemaphore.green,
        licenseType: LicenseType.cc0,
        attributionText: AttributionFormatter.format(
          title: title,
          artistName: artistName,
          institution: institution,
          licenseType: LicenseType.cc0,
          officialSourceUrl: officialSourceUrl,
        ),
        isWorldwide: true,
        canDisplayImage: true,
        legalReason: 'Dominio Público / CC0 confirmado.',
        officialSourceUrl: officialSourceUrl,
      );
    }

    // 4. Fallback: Copyright / All Rights Reserved -> Red
    return _buildRedResult(
      legalReason: 'Derechos reservados por la institución titular. No se autoriza redistribución digital.',
      officialSourceUrl: officialSourceUrl,
    );
  }

  static LicenseEvaluationResult _buildRedResult({
    required String legalReason,
    String? officialSourceUrl,
  }) {
    return LicenseEvaluationResult(
      semaphore: LicenseSemaphore.red,
      licenseType: LicenseType.copyright,
      attributionText: null,
      isWorldwide: false,
      canDisplayImage: false,
      legalReason: legalReason,
      officialSourceUrl: officialSourceUrl,
    );
  }
}
