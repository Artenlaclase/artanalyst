import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LicenseGuideView extends StatelessWidget {
  const LicenseGuideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/catalog'),
        ),
        title: const Text('Guía Educativa de Propiedad Intelectual'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Hero Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B4513), Color(0xFF5D2E0C)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Semáforo de Licencias Transparente',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'En ArtAnalyst la ética y transparencia legal no son una nota al pie, sino un pilar pedagógico esencial para la formación en historia del arte.',
                      style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // The Fundamental Distinction
              const Text(
                '1. La distinción clave: Obra original vs Reproducción Digital',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Un cuadro de Rembrandt o Leonardo da Vinci pintado hace 400 o 500 años está inequívocamente en el dominio público debido a la expiración de los derechos de autor patrimoniales del artista. '
                'Sin embargo, una fotografía digital de alta resolución tomada recientemente por un museo o una agencia fotográfica puede estar sujeta a derechos de autor o derechos afines del fotógrafo y de la institución.\n\n'
                'Por esta razón, ArtAnalyst evalúa exclusivamente los derechos de la reproducción digital, asegurando un uso legalmente intachable.',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),

              const SizedBox(height: 24),

              // The Traffic Light
              const Text(
                '2. Los tres estados del Semáforo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _buildSemaphoreCard(
                color: const Color(0xFF2E7D32),
                icon: Icons.check_circle_outline,
                title: '🟢 Semáforo Verde: Dominio Público / CC0',
                subtitle: 'Acceso Abierto Total',
                description: 'La institución ha renunciado explícitamente a los derechos patrimoniales sobre la reproducción digital (Creative Commons Zero 1.0 o Public Domain Mark mundial).',
                rules: [
                  'La imagen se muestra en altísima resolución y con soporte de teselas/zoom.',
                  'Permite descarga para estudio offline.',
                  'Puede reutilizarse en trabajos, publicaciones o ejercicios.',
                  'Instituciones pioneras: The Met, Cleveland Museum of Art, J. Paul Getty Trust, Smithsonian Open Access.',
                ],
              ),

              const SizedBox(height: 16),

              _buildSemaphoreCard(
                color: const Color(0xFFEF6C00),
                icon: Icons.attribution_rounded,
                title: '🟡 Semáforo Amarillo: Creative Commons con Atribución',
                subtitle: 'Uso Abierto con Crédito Obligatorio',
                description: 'La imagen puede utilizarse, pero la licencia exige atribuir formalmente al autor y a la institución titular.',
                rules: [
                  'La imagen se visualiza en la app junto con el texto de atribución TASL pre-generado.',
                  'Si la licencia es CC BY-SA, cualquier obra derivada debe compartirse bajo la misma licencia.',
                  'No deben aplicarse restricciones tecnológicas que limiten los términos de la licencia.',
                ],
              ),

              const SizedBox(height: 16),

              _buildSemaphoreCard(
                color: const Color(0xFFC62828),
                icon: Icons.shield_outlined,
                title: '🔴 Semáforo Rojo: Derechos Reservados',
                subtitle: 'Solo Enlace a Fuente Oficial',
                description: 'La institución retiene todos los derechos sobre la fotografía digital (ej. Louvre, Prado, agencias privadas).',
                rules: [
                  'ArtAnalyst NO aloja ni distribuye la imagen para proteger el copyright.',
                  'Se ofrece una ficha técnica completa con un botón directo para consultar la obra en el catálogo oficial del museo.',
                  'El estudiante puede realizar el análisis formal usando como referencia la ventana del museo.',
                ],
              ),

              const SizedBox(height: 24),

              // Wikimedia and Europeana Strict Filter
              const Text(
                '3. Criterio riguroso en Agregadores (Wikimedia Commons y Europeana)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Muchos archivos en repositorios colaborativos poseen licencias territoriales ambiguas (como "pd-us", válida únicamente en los Estados Unidos pero posiblemente protegida en la Unión Europea o América Latina). '
                'ArtAnalyst descarta por defecto cualquier reproducción que no cuente con una renuncia mundial inequívoca (CC0 o PDM mundial), asignándole semáforo Rojo por precaución jurídica.',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSemaphoreCard({
    required Color color,
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    required List<String> rules,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 11.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(description, style: const TextStyle(fontSize: 13, height: 1.4)),
          const SizedBox(height: 10),
          ...rules.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.arrow_right, size: 18, color: color),
                    const SizedBox(width: 4),
                    Expanded(child: Text(r, style: const TextStyle(fontSize: 12.5))),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
