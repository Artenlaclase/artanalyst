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
                        hintText: 'Buscar por obra, artista o época...',
                        prefixIcon: Icon(Icons.search),
                        isDense: true,
                      ),
                      onChanged: (val) => context.read<CatalogCubit>().search(val),
                    ),
                    const SizedBox(height: 12),
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

              // Artworks Grid
              Expanded(
                child: artworks.isEmpty
                    ? const Center(child: Text('No se encontraron obras con los filtros seleccionados.'))
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
