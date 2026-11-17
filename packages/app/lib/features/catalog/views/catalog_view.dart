import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:art_analyst_shared/shared.dart';
import '../cubit/catalog_cubit.dart';
import '../cubit/catalog_state.dart';
import 'widgets/artwork_card.dart';

class CatalogView extends StatelessWidget {
  const CatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.palette_rounded, color: Color(0xFF8B4513)),
            SizedBox(width: 10),
            Text('ArtAnalyst', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Sesión: 20 Autorretratos en Dominio Público',
            icon: const Icon(Icons.face_retouching_natural_rounded),
            onPressed: () => context.go('/session/self-portraits'),
          ),
          IconButton(
            tooltip: 'Guía Metodológica y Estudio de Arte',
            icon: const Icon(Icons.auto_stories_rounded),
            onPressed: () => context.go('/study'),
          ),
          IconButton(
            tooltip: 'Guía de Licencias y Derechos',
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () => context.go('/licenses-guide'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<CatalogCubit, CatalogState>(
        builder: (context, state) {
          if (state is CatalogLoading || state is CatalogInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CatalogError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(state.message),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.read<CatalogCubit>().loadCatalog(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final loaded = state as CatalogLoaded;
          final artworks = loaded.pagedArtworks;
          final totalMatching = loaded.totalMatchingCount;

          return Column(
            children: [
              // Search & Filters Bar
              Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                color: Theme.of(context).cardColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    TextField(
                      style: const TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                        hintText: 'Buscar por artista (Van Gogh, Monet...), movimiento o título...',
                        hintStyle: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55)),
                        prefixIcon: const Icon(Icons.search),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                      onChanged: (val) => context.read<CatalogCubit>().search(val),
                    ),
                    const SizedBox(height: 10),

                    // Filter by Movement row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const Text('Movimiento: ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 6),
                          FilterChip(
                            label: const Text('Todos'),
                            selected: loaded.filterMovement == null,
                            onSelected: (_) => context.read<CatalogCubit>().filterByMovement(null),
                          ),
                          const SizedBox(width: 6),
                          ...[
                            'Postimpresionismo',
                            'Impresionismo',
                            'Barroco',
                            'Romanticismo',
                            'Renacimiento',
                            'Ukiyo-e',
                            'Expresionismo',
                            'Modernismo',
                          ].map((mov) => Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: FilterChip(
                                  label: Text(mov),
                                  selected: loaded.filterMovement?.toLowerCase() == mov.toLowerCase(),
                                  onSelected: (_) => context.read<CatalogCubit>().filterByMovement(
                                        loaded.filterMovement?.toLowerCase() == mov.toLowerCase() ? null : mov,
                                      ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Filter by Artist row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const Text('Artista: ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 6),
                          FilterChip(
                            label: const Text('Todos los artistas'),
                            selected: loaded.filterArtist == null,
                            onSelected: (_) => context.read<CatalogCubit>().filterByArtist(null),
                          ),
                          const SizedBox(width: 6),
                          ...[
                            'Vincent van Gogh',
                            'Claude Monet',
                            'Johannes Vermeer',
                            'Caspar David Friedrich',
                            'Leonardo da Vinci',
                            'Rembrandt van Rijn',
                            'Francisco de Goya',
                            'Sandro Botticelli',
                            'Edgar Degas',
                            'Paul Cézanne',
                            'Katsushika Hokusai',
                            'Edvard Munch',
                            'Gustav Klimt',
                          ].map((art) => Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: FilterChip(
                                  label: Text(art),
                                  selected: loaded.filterArtist?.toLowerCase() == art.toLowerCase(),
                                  onSelected: (_) => context.read<CatalogCubit>().filterByArtist(
                                        loaded.filterArtist?.toLowerCase() == art.toLowerCase() ? null : art,
                                      ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Traffic light filters
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const Text('Semáforo: ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 6),
                          FilterChip(
                            label: const Text('Todos'),
                            selected: loaded.filterSemaphore == null,
                            onSelected: (_) => context.read<CatalogCubit>().filterBySemaphore(null),
                          ),
                          const SizedBox(width: 6),
                          FilterChip(
                            avatar: const Icon(Icons.circle, size: 12, color: Color(0xFF2E7D32)),
                            label: const Text('Verde (CC0)'),
                            selected: loaded.filterSemaphore == LicenseSemaphore.green,
                            onSelected: (_) => context.read<CatalogCubit>().filterBySemaphore(
                              loaded.filterSemaphore == LicenseSemaphore.green ? null : LicenseSemaphore.green,
                            ),
                          ),
                          const SizedBox(width: 6),
                          FilterChip(
                            avatar: const Icon(Icons.circle, size: 12, color: Color(0xFFEF6C00)),
                            label: const Text('Amarillo (CC BY)'),
                            selected: loaded.filterSemaphore == LicenseSemaphore.yellow,
                            onSelected: (_) => context.read<CatalogCubit>().filterBySemaphore(
                              loaded.filterSemaphore == LicenseSemaphore.yellow ? null : LicenseSemaphore.yellow,
                            ),
                          ),
                          const SizedBox(width: 6),
                          FilterChip(
                            avatar: const Icon(Icons.circle, size: 12, color: Color(0xFFC62828)),
                            label: const Text('Rojo (Copyright)'),
                            selected: loaded.filterSemaphore == LicenseSemaphore.red,
                            onSelected: (_) => context.read<CatalogCubit>().filterBySemaphore(
                              loaded.filterSemaphore == LicenseSemaphore.red ? null : LicenseSemaphore.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Banner de la Sesión de Autorretratos en Dominio Público
              InkWell(
                onTap: () => context.go('/session/self-portraits'),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A2311), Color(0xFF8B4513)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.face_retouching_natural_rounded, size: 24, color: Colors.amberAccent),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '🎨 Sesión Especial: 20 Autorretratos en Dominio Público',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Obras 100% libres de derechos con guía de análisis Panofsky, Wölfflin y 4 estaciones.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FilledButton.tonal(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF4A2311),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: () => context.go('/session/self-portraits'),
                        child: const Text('Entrar a Sesión', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),

              // Educational study & movements banner
              InkWell(
                onTap: () => context.go('/study?tab=1'),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.25)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.palette_rounded, size: 22, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Explora los Movimientos Artísticos y sus Exponentes clave (Renacimiento, Barroco, Impresionismo...).',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/study?tab=1'),
                        child: const Text('Ver Movimientos', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),

              // Results count header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mostrando ${artworks.length} de $totalMatching obras maestras',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    if (loaded.filterMovement != null || loaded.filterArtist != null || loaded.filterSemaphore != null || loaded.searchQuery.isNotEmpty)
                      InkWell(
                        onTap: () => context.read<CatalogCubit>().resetFilters(),
                        child: Text(
                          'Limpiar filtros',
                          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                  ],
                ),
              ),

              // Artworks Grid with infinite scroll / load more
              Expanded(
                child: artworks.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.filter_alt_off_rounded, size: 48, color: Colors.grey),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No se encontraron obras con los criterios seleccionados.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Prueba buscando otro artista o restablece los filtros:',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                              const SizedBox(height: 20),
                              FilledButton.icon(
                                icon: const Icon(Icons.refresh_rounded),
                                label: const Text('Restablecer filtros y ver todo'),
                                onPressed: () => context.read<CatalogCubit>().resetFilters(),
                              ),
                            ],
                          ),
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          // Adaptive columns: 1 for mobile, 2 for tablet, 3-4 for desktop/web
                          int crossAxisCount = 1;
                          double aspectRatio = 0.88; // comfortable proportions for mobile
                          if (constraints.maxWidth > 1200) {
                            crossAxisCount = 4;
                            aspectRatio = 0.76;
                          } else if (constraints.maxWidth > 850) {
                            crossAxisCount = 3;
                            aspectRatio = 0.76;
                          } else if (constraints.maxWidth > 550) {
                            crossAxisCount = 2;
                            aspectRatio = 0.82;
                          }

                          return NotificationListener<ScrollNotification>(
                            onNotification: (scrollInfo) {
                              if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
                                if (loaded.hasMoreToLoad) {
                                  context.read<CatalogCubit>().loadMoreArtworks();
                                }
                              }
                              return false;
                            },
                            child: ListView(
                              padding: const EdgeInsets.all(16),
                              children: [
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    childAspectRatio: aspectRatio,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                                  itemCount: artworks.length,
                                  itemBuilder: (context, index) {
                                    final artwork = artworks[index];
                                    final image = loaded.primaryImages[artwork.id];
                                    return ArtworkCard(
                                      artwork: artwork,
                                      image: image,
                                      onTap: () => context.go('/artwork/${artwork.id}'),
                                    );
                                  },
                                ),
                                if (loaded.hasMoreToLoad) ...[
                                  const SizedBox(height: 20),
                                  Center(
                                    child: OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                      ),
                                      onPressed: () => context.read<CatalogCubit>().loadMoreArtworks(),
                                      icon: const Icon(Icons.expand_more_rounded),
                                      label: Text(
                                        'Cargar más obras maestras (${totalMatching - artworks.length} restantes)',
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
