import 'package:flutter/material.dart';
import 'package:art_analyst_shared/shared.dart';
import 'composition_overlay.dart';
import 'color_palette_overlay.dart';
import 'package:art_analyst_app/features/licensing/widgets/copyright_placeholder.dart';
import 'package:art_analyst_app/core/widgets/smart_artwork_image.dart';

/// The central interactive artwork viewer in ArtAnalyst.
/// Supports deep zoom & pan, composition overlays, and user ROI annotations.
class AnnotatedViewer extends StatefulWidget {
  final Artwork artwork;
  final ArtworkImage? image;
  final List<AnnotationRegion> regions;
  final ValueChanged<AnnotationRegion> onAddRegion;
  final ValueChanged<String> onDeleteRegion;

  const AnnotatedViewer({
    super.key,
    required this.artwork,
    this.image,
    required this.regions,
    required this.onAddRegion,
    required this.onDeleteRegion,
  });

  @override
  State<AnnotatedViewer> createState() => _AnnotatedViewerState();
}

class _AnnotatedViewerState extends State<AnnotatedViewer> {
  final TransformationController _transformationController = TransformationController();
  bool _showComposition = false;
  bool _showPalette = false;
  bool _showAnnotations = true;
  bool _isAnnotatingMode = false;

  // Predefined sample palette for demonstration
  final List<ArtworkColorSwatch> _samplePalette = const [
    ArtworkColorSwatch(color: Color(0xFFD4A017), hex: '#D4A017', name: 'Amarillo Ocre Cálido', role: 'Dominante'),
    ArtworkColorSwatch(color: Color(0xFF1E3F66), hex: '#1E3F66', name: 'Azul Cobalto Profundo', role: 'Complementario'),
    ArtworkColorSwatch(color: Color(0xFF2E6F40), hex: '#2E6F40', name: 'Verde Esmeralda', role: 'Fondo'),
    ArtworkColorSwatch(color: Color(0xFFC84B31), hex: '#C84B31', name: 'Rojo Carmín', role: 'Acento'),
  ];

  void _handleTapDown(TapDownDetails details, BoxConstraints constraints) {
    if (!_isAnnotatingMode) return;

    final localPos = details.localPosition;
    final normalizedX = (localPos.dx / constraints.maxWidth).clamp(0.0, 1.0);
    final normalizedY = (localPos.dy / constraints.maxHeight).clamp(0.0, 1.0);

    _showAddAnnotationDialog(normalizedX, normalizedY);
  }

  void _showAddAnnotationDialog(double x, double y) {
    final labelController = TextEditingController();
    final notesController = TextEditingController();
    String category = 'composition';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Nueva Región de Interés (ROI)'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: labelController,
                decoration: const InputDecoration(
                  labelText: 'Etiqueta (ej. Mirada, Sombrero, Punto focal)',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notas de análisis formal o iconográfico',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: category,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: const [
                  DropdownMenuItem(value: 'composition', child: Text('Composición y Líneas')),
                  DropdownMenuItem(value: 'symbol', child: Text('Símbolo o Atributo')),
                  DropdownMenuItem(value: 'color', child: Text('Gama Cromática')),
                  DropdownMenuItem(value: 'brushwork', child: Text('Técnica y Pincelada')),
                ],
                onChanged: (val) {
                  if (val != null) setDialogState(() => category = val);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                if (labelController.text.trim().isEmpty) return;
                final newRegion = AnnotationRegion(
                  id: 'reg-${DateTime.now().millisecondsSinceEpoch}',
                  x: x - 0.08,
                  y: y - 0.08,
                  width: 0.16,
                  height: 0.16,
                  label: labelController.text.trim(),
                  notes: notesController.text.trim(),
                  category: category,
                  createdAt: DateTime.now(),
                );
                widget.onAddRegion(newRegion);
                setState(() => _isAnnotatingMode = false);
                Navigator.of(ctx).pop();
              },
              child: const Text('Guardar Región'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final image = widget.image;

    // Red semaphore: strictly prohibit direct image rendering
    if (image == null || !image.canDisplayDirectly) {
      return Center(
        child: CopyrightPlaceholder(
          title: widget.artwork.title,
          artistName: widget.artwork.artistName,
          institution: widget.artwork.source.toUpperCase(),
          officialSourceUrl: widget.artwork.officialUrl,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // 1. Zoomable Artwork Canvas
            InteractiveViewer(
              transformationController: _transformationController,
              minScale: 1.0,
              maxScale: 6.0,
              boundaryMargin: const EdgeInsets.all(40),
              child: GestureDetector(
                onTapDown: (details) => _handleTapDown(details, constraints),
                child: Center(
                  child: AspectRatio(
                    aspectRatio: (image.width != null && image.height != null)
                        ? (image.width! / image.height!)
                        : 0.8,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Base Artwork Image
                        SmartArtworkImage(
                          artworkId: widget.artwork.id,
                          imageUrl: image.imageUrl,
                          fit: BoxFit.contain,
                          cacheWidth: 1400,
                          placeholderTitle: widget.artwork.title,
                          placeholderArtist: widget.artwork.artistName,
                        ),

                        // Composition Guides Overlay
                        if (_showComposition)
                          const CompositionOverlay(showThirds: true, showDiagonals: true),

                        // Annotated Regions ROI Overlay
                        if (_showAnnotations)
                          ...widget.regions.map((region) {
                            return Positioned(
                              left: region.x * constraints.maxWidth,
                              top: region.y * constraints.maxHeight,
                              width: region.width * constraints.maxWidth,
                              height: region.height * constraints.maxHeight,
                              child: Tooltip(
                                message: '${region.label}\n${region.notes}',
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.amberAccent, width: 2),
                                    color: Colors.amber.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                      color: Colors.black87,
                                      child: Text(
                                        region.label,
                                        style: const TextStyle(color: Colors.white, fontSize: 10),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 2. Color Palette Bar (if active)
            if (_showPalette)
              Positioned(
                bottom: 60,
                left: 16,
                right: 16,
                child: ColorPaletteOverlay(swatches: _samplePalette),
              ),

            // 3. Floating Analysis Toolbar (Toggles)
            Positioned(
              top: 16,
              right: 16,
              child: Card(
                elevation: 4,
                color: Colors.black.withOpacity(0.75),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Composition lines toggle
                      IconButton(
                        tooltip: 'Capa de Composición (Regla de tercios y diagonales)',
                        icon: Icon(
                          Icons.grid_on_rounded,
                          color: _showComposition ? Colors.amber : Colors.white70,
                        ),
                        onPressed: () => setState(() => _showComposition = !_showComposition),
                      ),
                      // Color palette toggle
                      IconButton(
                        tooltip: 'Capa de Color & Armonía',
                        icon: Icon(
                          Icons.palette_rounded,
                          color: _showPalette ? Colors.amber : Colors.white70,
                        ),
                        onPressed: () => setState(() => _showPalette = !_showPalette),
                      ),
                      // Regions of interest toggle
                      IconButton(
                        tooltip: 'Capa de Anotaciones y Regiones ROI',
                        icon: Icon(
                          Icons.layers_rounded,
                          color: _showAnnotations ? Colors.amber : Colors.white70,
                        ),
                        onPressed: () => setState(() => _showAnnotations = !_showAnnotations),
                      ),
                      const SizedBox(width: 4),
                      // Add annotation mode
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: _isAnnotatingMode ? Colors.amber : Colors.white24,
                          foregroundColor: _isAnnotatingMode ? Colors.black : Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        icon: Icon(_isAnnotatingMode ? Icons.touch_app : Icons.add_comment_rounded, size: 16),
                        label: Text(_isAnnotatingMode ? 'Toca la obra' : 'Anotar'),
                        onPressed: () {
                          setState(() => _isAnnotatingMode = !_isAnnotatingMode);
                          if (_isAnnotatingMode) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Modo de anotación activo: pulsa en cualquier zona de la obra para marcar una región.'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                      ),
                      // Reset Zoom
                      IconButton(
                        tooltip: 'Restablecer zoom',
                        icon: const Icon(Icons.zoom_out_map_rounded, color: Colors.white70),
                        onPressed: () => _transformationController.value = Matrix4.identity(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
