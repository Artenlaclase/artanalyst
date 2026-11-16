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
          final artworks = loaded.filteredArtworks;

          return Column(
            children: [
              // Search & License Filters Bar
              Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                color: Theme.of(context).cardColor,
                child: Column(
                  children: [
                    // Search bar
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Buscar por obra, artista o museo (ej. Mona Lisa, Van Gogh)...',
                        prefixIcon: Icon(Icons.search),
                        isDense: true,
                      ),
                      onChanged: (val) => context.read<CatalogCubit>().search(val),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.visibility_outlined, size: 13, color: Colors.grey.shade600),
                        const SizedBox(width: 6),
                        Text(
                          'Mostrando obras con reproducción digital disponible. Si buscas una obra protegida, te indicaremos dónde verla oficialmente.',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Traffic light filters
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const Text('Filtro de Semáforo: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 6),
                          FilterChip(
                            label: const Text('Todos'),
                            selected: loaded.filterSemaphore == null,
                            onSelected: (_) => context.read<CatalogCubit>().filterBySemaphore(null),
                          ),
                          const SizedBox(width: 6),
                          FilterChip(
                            avatar: const Icon(Icons.circle, size: 12, color: Color(0xFF2E7D32)),
                            label: const Text('Verde (CC0 / Dominio Público)'),
                            selected: loaded.filterSemaphore == LicenseSemaphore.green,
                            onSelected: (_) => context.read<CatalogCubit>().filterBySemaphore(
                              loaded.filterSemaphore == LicenseSemaphore.green ? null : LicenseSemaphore.green,
                            ),
                          ),
                          const SizedBox(width: 6),
                          FilterChip(
                            avatar: const Icon(Icons.circle, size: 12, color: Color(0xFFEF6C00)),
                            label: const Text('Amarillo (CC con Atribución)'),
                            selected: loaded.filterSemaphore == LicenseSemaphore.yellow,
                            onSelected: (_) => context.read<CatalogCubit>().filterBySemaphore(
                              loaded.filterSemaphore == LicenseSemaphore.yellow ? null : LicenseSemaphore.yellow,
                            ),
                          ),
                          const SizedBox(width: 6),
                          FilterChip(
                            avatar: const Icon(Icons.circle, size: 12, color: Color(0xFFC62828)),
                            label: const Text('Rojo (Derechos Reservados)'),
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

              // Educational study banner
              InkWell(
                onTap: () => context.go('/study'),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B4513).withOpacity(0.07),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF8B4513).withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_stories_rounded, size: 20, color: Color(0xFF8B4513)),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          '¿Cómo analizar una obra? Descubre el Método de Panofsky, los 5 pares de Wölfflin y el funcionamiento de la app.',
                          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: Color(0xFF5D2E0C)),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/study'),
                        child: const Text('Abrir Estudio', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),

              // Artworks Grid
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
                                  color: (loaded.filterSemaphore != null)
                                      ? (loaded.filterSemaphore == LicenseSemaphore.yellow
                                          ? const Color(0xFFEF6C00).withOpacity(0.12)
                                          : loaded.filterSemaphore == LicenseSemaphore.green
                                              ? const Color(0xFF2E7D32).withOpacity(0.12)
                                              : const Color(0xFFC62828).withOpacity(0.12))
                                      : Colors.grey.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.filter_alt_off_rounded,
                                  size: 48,
                                  color: loaded.filterSemaphore != null
                                      ? (loaded.filterSemaphore == LicenseSemaphore.yellow
                                          ? const Color(0xFFEF6C00)
                                          : loaded.filterSemaphore == LicenseSemaphore.green
                                              ? const Color(0xFF2E7D32)
                                              : const Color(0xFFC62828))
                                      : Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                loaded.filterSemaphore != null
                                    ? 'Filtro activo: "${loaded.filterSemaphore!.label}"'
                                    : 'No se encontraron obras con los criterios actuales.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Puedes pulsar el botón para volver a ver todas las obras del catálogo:',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                              const SizedBox(height: 20),
                              FilledButton.icon(
                                icon: const Icon(Icons.refresh_rounded),
                                label: const Text('Restablecer filtros y ver todas las obras'),
                                onPressed: () {
                                  context.read<CatalogCubit>().filterBySemaphore(null);
                                  context.read<CatalogCubit>().search('');
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          // Adaptive columns: 1 for mobile, 2 for tablet, 3-4 for desktop/web
                          int crossAxisCount = 1;
                          if (constraints.maxWidth > 1200) {
                            crossAxisCount = 4;
                          } else if (constraints.maxWidth > 850) {
                            crossAxisCount = 3;
                          } else if (constraints.maxWidth > 550) {
                            crossAxisCount = 2;
                          }

                          return GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              childAspectRatio: 0.72,
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
