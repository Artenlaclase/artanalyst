import '../models/license_type.dart';

/// Generates standard, legally compliant Creative Commons and Public Domain attribution texts.
class AttributionFormatter {
  /// Formats attribution according to Creative Commons TASL best practices
  /// (Title, Author, Source, License).
  static String format({
    required String title,
    String? artistName,
    required String institution,
    required LicenseType licenseType,
    String? officialSourceUrl,
  }) {
    final effectiveArtist = (artistName != null && artistName.trim().isNotEmpty)
        ? artistName.trim()
        : 'Autor desconocido';

    final buffer = StringBuffer();
    buffer.write('"$title" por $effectiveArtist. ');
    buffer.write('Colección: $institution. ');

    if (licenseType.semaphore == LicenseSemaphore.green) {
      buffer.write('Licencia: Dominio Público (${licenseType.name}). ');
    } else if (licenseType.semaphore == LicenseSemaphore.yellow) {
      buffer.write('Licencia: ${licenseType.name}. ');
      if (licenseType.requiresShareAlike) {
        buffer.write('Aviso: Cualquier obra derivada debe licenciarse bajo los mismos términos (ShareAlike). ');
      }
    } else {
      buffer.write('Todos los derechos reservados por $institution. ');
    }

    if (officialSourceUrl != null && officialSourceUrl.trim().isNotEmpty) {
      buffer.write('Fuente: $officialSourceUrl');
    }

    return buffer.toString().trim();
  }

  /// Generates educational guidance for the user in the LicenseBadge dialog
  static Map<String, dynamic> generateEducationalGuide(LicenseType licenseType, LicenseSemaphore semaphore) {
    switch (semaphore) {
      case LicenseSemaphore.green:
        return {
          'title': 'Obra de Dominio Público / CC0',
          'semaphore': 'green',
          'summary': 'La institución titular o el autor renunció a los derechos patrimoniales sobre esta reproducción digital.',
          'allowed': [
            'Ver y descargar la imagen en alta resolución.',
            'Usar la imagen libremente en proyectos académicos, comerciales y personales.',
            'Modificar, recortar y crear obras derivadas.',
            'No existe obligación legal de atribuir, aunque en el ámbito educativo siempre se recomienda citar la fuente.',
          ],
          'prohibited': [
            'Afirmar falsamente derechos de autor exclusivos sobre la obra original de dominio público.',
          ],
          'citationAdvice': 'Cita recomendada: Incluye título, autor original, museo de procedencia e indicación de Dominio Público / CC0.',
        };

      case LicenseSemaphore.yellow:
        return {
          'title': 'Creative Commons con Atribución',
          'semaphore': 'yellow',
          'summary': 'La reproducción digital se encuentra bajo una licencia abierta Creative Commons que exige atribución de autoría.',
          'allowed': [
            'Compartir, copiar y redistribuir el material en cualquier medio.',
            'Adaptar y transformar la imagen.',
            if (licenseType.requiresShareAlike)
              'Distribuir adaptaciones siempre que se aplique la misma licencia (BY-SA).',
          ],
          'prohibited': [
            'Usar la imagen sin mencionar al autor, institución y enlace a la licencia.',
            'Aplicar medidas tecnológicas o términos legales que restrinjan a otros hacer lo que la licencia permite.',
            if (!licenseType.allowsCommercialUse)
              'Uso con fines comerciales sin autorización explícita.',
          ],
          'citationAdvice': 'Cita obligatoria: Debes conservar el texto de atribución generado automáticamente por ArtAnalyst.',
        };

      case LicenseSemaphore.red:
        return {
          'title': 'Derechos Reservados / Reproducción Protegida',
          'semaphore': 'red',
          'summary': 'La digitalización o la obra posee derechos reservados por la institución o titular. ArtAnalyst protege los derechos de autor y NO aloja ni muestra directamente esta imagen.',
          'allowed': [
            'Consultar la ficha técnica y contexto educativo.',
            'Visitar la página web oficial del museo mediante el enlace proporcionado.',
            'Realizar anotaciones conceptuales sobre la ficha.',
          ],
          'prohibited': [
            'Descargar o alojar la reproducción digital sin consentimiento de la institución.',
            'Distribuir copias no autorizadas de la fotografía oficial.',
          ],
          'citationAdvice': 'Para referenciar esta obra, enlaza siempre al catálogo web oficial de la institución conservadora.',
        };
    }
  }
}
