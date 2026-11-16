/// Traffic light colors for intellectual property and digital reproduction rights.
enum LicenseSemaphore {
  /// Dominio público explícito o CC0.
  /// La institución renunció a los derechos de la reproducción digital.
  /// Se puede mostrar, descargar y reutilizar sin restricciones.
  green('G', 'Dominio Público / CC0', 'Uso libre y descarga permitida'),

  /// Creative Commons con atribución (CC BY, CC BY-SA, etc.).
  /// Se muestra con atribución automática visible.
  yellow('Y', 'Creative Commons', 'Requiere atribución obligatoria'),

  /// Derechos reservados o reproducción con copyright.
  /// No se muestra la imagen en la app; enlace a la fuente oficial.
  red('R', 'Derechos Reservados', 'Solo consulta en fuente oficial');

  final String code;
  final String label;
  final String description;

  const LicenseSemaphore(this.code, this.label, this.description);

  static LicenseSemaphore fromCode(String code) {
    switch (code.toUpperCase()) {
      case 'G':
      case 'GREEN':
        return LicenseSemaphore.green;
      case 'Y':
      case 'YELLOW':
        return LicenseSemaphore.yellow;
      case 'R':
      case 'RED':
      default:
        return LicenseSemaphore.red;
    }
  }
}

/// Normalized canonical license types
enum LicenseType {
  cc0(
    code: 'CC0',
    name: 'Creative Commons Zero (CC0 1.0)',
    uri: 'https://creativecommons.org/publicdomain/zero/1.0/',
    semaphore: LicenseSemaphore.green,
    allowsCommercialUse: true,
    allowsDerivatives: true,
    requiresAttribution: false,
    requiresShareAlike: false,
  ),
  publicDomainMark(
    code: 'PD',
    name: 'Public Domain Mark 1.0',
    uri: 'https://creativecommons.org/publicdomain/mark/1.0/',
    semaphore: LicenseSemaphore.green,
    allowsCommercialUse: true,
    allowsDerivatives: true,
    requiresAttribution: false,
    requiresShareAlike: false,
  ),
  ccBy(
    code: 'CC_BY',
    name: 'Creative Commons Attribution (CC BY 4.0)',
    uri: 'https://creativecommons.org/licenses/by/4.0/',
    semaphore: LicenseSemaphore.yellow,
    allowsCommercialUse: true,
    allowsDerivatives: true,
    requiresAttribution: true,
    requiresShareAlike: false,
  ),
  ccBySa(
    code: 'CC_BY_SA',
    name: 'Creative Commons Attribution-ShareAlike (CC BY-SA 4.0)',
    uri: 'https://creativecommons.org/licenses/by-sa/4.0/',
    semaphore: LicenseSemaphore.yellow,
    allowsCommercialUse: true,
    allowsDerivatives: true,
    requiresAttribution: true,
    requiresShareAlike: true,
  ),
  copyright(
    code: 'COPYRIGHT',
    name: 'Todos los derechos reservados',
    uri: '',
    semaphore: LicenseSemaphore.red,
    allowsCommercialUse: false,
    allowsDerivatives: false,
    requiresAttribution: true,
    requiresShareAlike: false,
  ),
  unknown(
    code: 'UNKNOWN',
    name: 'Licencia no especificada o ambigua',
    uri: '',
    semaphore: LicenseSemaphore.red,
    allowsCommercialUse: false,
    allowsDerivatives: false,
    requiresAttribution: true,
    requiresShareAlike: false,
  );

  final String code;
  final String name;
  final String uri;
  final LicenseSemaphore semaphore;
  final bool allowsCommercialUse;
  final bool allowsDerivatives;
  final bool requiresAttribution;
  final bool requiresShareAlike;

  const LicenseType({
    required this.code,
    required this.name,
    required this.uri,
    required this.semaphore,
    required this.allowsCommercialUse,
    required this.allowsDerivatives,
    required this.requiresAttribution,
    required this.requiresShareAlike,
  });

  static LicenseType fromCode(String? code) {
    if (code == null) return LicenseType.unknown;
    final normalized = code.trim().toUpperCase();
    for (final type in LicenseType.values) {
      if (type.code == normalized) return type;
    }
    if (normalized.contains('CC0') || normalized.contains('ZERO')) {
      return LicenseType.cc0;
    }
    if (normalized.contains('PUBLIC DOMAIN') || normalized == 'PDM') {
      return LicenseType.publicDomainMark;
    }
    if (normalized.contains('CC-BY-SA') || normalized.contains('CC_BY_SA')) {
      return LicenseType.ccBySa;
    }
    if (normalized.contains('CC-BY') || normalized.contains('CC_BY')) {
      return LicenseType.ccBy;
    }
    return LicenseType.copyright;
  }
}
