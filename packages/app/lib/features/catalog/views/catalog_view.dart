import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:art_analyst_shared/shared.dart';
import '../cubit/catalog_cubit.dart';
import '../cubit/catalog_state.dart';
import 'widgets/artwork_card.dart';

class CatalogView extends StatefulWidget {
  const CatalogView({super.key});

  @override
  State<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  bool _isFiltersExpanded = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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

          final activeFilterCount = (loaded.filterMovement != null ? 1 : 0) +
              (loaded.filterArtist != null ? 1 : 0) +
              (loaded.filterSemaphore != null ? 1 : 0);

          return Column(
            children: [
              // Barra de búsqueda compacta con botón de menú desplegable de filtros
              Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                color: Theme.of(context).cardColor,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(fontSize: 14.5),
                        decoration: InputDecoration(
                          hintText: 'Buscar obra, artista o movimiento...',
                          hintStyle: TextStyle(
                            fontSize: 13.5,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
                          ),
                          prefixIcon: const Icon(Icons.search, size: 20),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    context.read<CatalogCubit>().search('');
                                    setState(() {});
                                  },
                                )
                              : null,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).dividerColor.withOpacity(0.4),
                            ),
                          ),
                        ),
                        onChanged: (val) {
                          context.read<CatalogCubit>().search(val);
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Botón para desplegar / plegar menú de filtros
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() {
                          _isFiltersExpanded = !_isFiltersExpanded;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: _isFiltersExpanded || activeFilterCount > 0
                              ? const Color(0xFF8B4513)
                              : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _isFiltersExpanded || activeFilterCount > 0
                                ? const Color(0xFF8B4513)
                                : Theme.of(context).dividerColor.withOpacity(0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isFiltersExpanded ? Icons.tune_rounded : Icons.tune_outlined,
                              size: 19,
                              color: _isFiltersExpanded || activeFilterCount > 0
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              activeFilterCount > 0 ? 'Filtros ($activeFilterCount)' : 'Filtros',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: _isFiltersExpanded || activeFilterCount > 0
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Icon(
                              _isFiltersExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: _isFiltersExpanded || activeFilterCount > 0
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // MENÚ DESPLEGABLE DE FILTROS (ANIMADO)
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: _isFiltersExpanded
                    ? Container(
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF261E19) : const Color(0xFFFFFBF7),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFF8B4513).withOpacity(0.35),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Cabecera del menú desplegable
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.filter_list_rounded, size: 18, color: Color(0xFF8B4513)),
                                    SizedBox(width: 6),
                                    Text(
                                      'Filtros por Movimiento y Artista',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                  ],
                                ),
                                if (activeFilterCount > 0 || loaded.searchQuery.isNotEmpty)
                                  InkWell(
                                    onTap: () {
                                      _searchController.clear();
                                      context.read<CatalogCubit>().resetFilters();
                                      setState(() {});
                                    },
                                    child: const Row(
                                      children: [
                                        Icon(Icons.refresh_rounded, size: 15, color: Color(0xFF8B4513)),
                                        SizedBox(width: 3),
                                        Text(
                                          'Limpiar todo',
                                          style: TextStyle(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF8B4513),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const Divider(height: 18),

                            // Fila 1: Filtro por Movimiento
                            const Text('Movimiento Estético:', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  FilterChip(
                                    label: const Text('Todos'),
                                    selected: loaded.filterMovement == null,
                                    onSelected: (_) => context.read<CatalogCubit>().filterByMovement(null),
                                  ),
                                  const SizedBox(width: 6),
                                  ...[
                                    'Renacimiento',
                                    'Manierismo',
                                    'Barroco',
                                    'Rococó',
                                    'Romanticismo',
                                    'Realismo',
                                    'Impresionismo',
                                    'Postimpresionismo',
                                    'Expresionismo',
                                    'Ukiyo-e',
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
                            const SizedBox(height: 10),

                            // Fila 2: Filtro por Artista
                            const Text('Artista:', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  FilterChip(
                                    label: const Text('Todos los artistas'),
                                    selected: loaded.filterArtist == null,
                                    onSelected: (_) => context.read<CatalogCubit>().filterByArtist(null),
                                  ),
                                  const SizedBox(width: 6),
                                  ...[
                                    'Alberto Durero',
                                    'Parmigianino',
                                    'Sofonisba Anguissola',
                                    'Leonardo da Vinci',
                                    'Tiziano',
                                    'Peter Paul Rubens',
                                    'Judith Leyster',
                                    'Artemisia Gentileschi',
                                    'Diego Velázquez',
                                    'Rembrandt van Rijn',
                                    'Élisabeth Vigée Le Brun',
                                    'Francisco de Goya',
                                    'Gustave Courbet',
                                    'Caspar David Friedrich',
                                    'Paul Cézanne',
                                    'Mary Cassatt',
                                    'Claude Monet',
                                    'Vincent van Gogh',
                                    'Paul Gauguin',
                                    'Egon Schiele',
                                    'Sandro Botticelli',
                                    'Edgar Degas',
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
                            const SizedBox(height: 10),

                            // Fila 3: Semáforo Legal
                            const Text('Semáforo de Licencia:', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  FilterChip(
                                    label: const Text('Todos'),
                                    selected: loaded.filterSemaphore == null,
                                    onSelected: (_) => context.read<CatalogCubit>().filterBySemaphore(null),
                                  ),
                                  const SizedBox(width: 6),
                                  FilterChip(
                                    avatar: const Icon(Icons.circle, size: 12, color: Color(0xFF2E7D32)),
                                    label: const Text('Verde (Dominio Público)'),
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
                            const SizedBox(height: 12),

                            // Botón para cerrar menú y ver resultados
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.tonal(
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  visualDensity: VisualDensity.compact,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isFiltersExpanded = false;
                                  });
                                },
                                child: Text('Cerrar menú y ver ${artworks.length} obras'),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              // Chips activos compactos cuando el menú está plegado
              if (!_isFiltersExpanded && activeFilterCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const Text('Filtros: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        if (loaded.filterMovement != null) ...[
                          Chip(
                            label: Text(loaded.filterMovement!, style: const TextStyle(fontSize: 11.5)),
                            deleteIcon: const Icon(Icons.close, size: 14),
                            onDeleted: () => context.read<CatalogCubit>().filterByMovement(null),
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                          const SizedBox(width: 6),
                        ],
                        if (loaded.filterArtist != null) ...[
                          Chip(
                            label: Text(loaded.filterArtist!, style: const TextStyle(fontSize: 11.5)),
                            deleteIcon: const Icon(Icons.close, size: 14),
                            onDeleted: () => context.read<CatalogCubit>().filterByArtist(null),
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                          const SizedBox(width: 6),
                        ],
                        if (loaded.filterSemaphore != null) ...[
                          Chip(
                            avatar: Icon(Icons.circle, size: 10, color: loaded.filterSemaphore == LicenseSemaphore.green ? Colors.green : Colors.orange),
                            label: Text(
                              loaded.filterSemaphore == LicenseSemaphore.green ? 'Verde' : 'Amarillo',
                              style: const TextStyle(fontSize: 11.5),
                            ),
                            deleteIcon: const Icon(Icons.close, size: 14),
                            onDeleted: () => context.read<CatalogCubit>().filterBySemaphore(null),
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                          const SizedBox(width: 6),
                        ],
                        TextButton(
                          onPressed: () => context.read<CatalogCubit>().resetFilters(),
                          style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                          child: const Text('Limpiar', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                ),

              // Contador de resultados compacto
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mostrando ${artworks.length} de $totalMatching obras maestras',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.65),
                      ),
                    ),
                  ],
                ),
              ),

              // GRID DE OBRAS DE ARTE (OCUPA INMEDIATAMENTE LA PANTALLA)
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
                                onPressed: () {
                                  _searchController.clear();
                                  context.read<CatalogCubit>().resetFilters();
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          // Adaptabilidad: 1 columna en móvil, 2 en tablet, 3-4 en desktop/web
                          int crossAxisCount = 1;
                          double aspectRatio = 0.95; // Proporción óptima para que la imagen se aprecie grande en móvil
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
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
