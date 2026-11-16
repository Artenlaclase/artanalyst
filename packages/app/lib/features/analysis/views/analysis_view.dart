import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:art_analyst_shared/shared.dart';
import '../cubit/analysis_cubit.dart';
import '../cubit/analysis_state.dart';
import 'widgets/annotated_viewer.dart';
import 'widgets/panofsky_stepper.dart';
import 'package:art_analyst_app/features/licensing/widgets/license_badge.dart';

class AnalysisView extends StatelessWidget {
  final String artworkId;

  const AnalysisView({super.key, required this.artworkId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/catalog'),
        ),
        title: BlocBuilder<AnalysisCubit, AnalysisState>(
          builder: (context, state) {
            if (state is AnalysisLoaded) {
              return Text(
                state.artwork.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              );
            }
            return const Text('Análisis Formal & Iconográfico');
          },
        ),
        actions: [
          BlocBuilder<AnalysisCubit, AnalysisState>(
            builder: (context, state) {
              if (state is AnalysisLoaded) {
                final image = state.image;
                final semaphore = image?.semaphoreColor ?? LicenseSemaphore.red;
                final licenseType = image?.licenseType ?? LicenseType.copyright;
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Center(
                    child: LicenseBadge(
                      semaphore: semaphore,
                      licenseType: licenseType,
                      attributionText: image?.attributionText,
                      officialSourceUrl: state.artwork.officialUrl,
                      institutionName: state.artwork.source.toUpperCase(),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<AnalysisCubit, AnalysisState>(
        builder: (context, state) {
          if (state is AnalysisLoading || state is AnalysisInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AnalysisError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(state.message),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.go('/catalog'),
                    child: const Text('Volver al catálogo'),
                  ),
                ],
              ),
            );
          }

          final loaded = state as AnalysisLoaded;

          return LayoutBuilder(
            builder: (context, constraints) {
              final isDesktopWeb = constraints.maxWidth >= 900;

              if (isDesktopWeb) {
                // Side-by-Side Dual Pane for Web / Desktop
                return Row(
                  children: [
                    // Left Pane: Interactive Visual Viewer (60% width)
                    Expanded(
                      flex: 6,
                      child: Container(
                        color: Colors.black.withOpacity(0.04),
                        child: AnnotatedViewer(
                          artwork: loaded.artwork,
                          image: loaded.image,
                          regions: loaded.regions,
                          onAddRegion: (r) => context.read<AnalysisCubit>().addRegion(r),
                          onDeleteRegion: (id) => context.read<AnalysisCubit>().deleteRegion(id),
                        ),
                      ),
                    ),

                    // Vertical Divider
                    const VerticalDivider(width: 1, thickness: 1),

                    // Right Pane: Panofsky Stepper & Guiding Questions (40% width)
                    Expanded(
                      flex: 4,
                      child: Container(
                        color: Theme.of(context).cardColor,
                        child: Column(
                          children: [
                            // Technical specs summary
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    loaded.artwork.artistName ?? 'Artista desconocido',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${loaded.artwork.dateDisplay ?? ''} • ${loaded.artwork.medium ?? ''}',
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                  ),
                                  if (loaded.artwork.dimensions != null)
                                    Text(
                                      'Dimensiones: ${loaded.artwork.dimensions}',
                                      style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                                    ),
                                ],
                              ),
                            ),
                            const Divider(height: 1),

                            // Stepper Content
                            Expanded(
                              child: SingleChildScrollView(
                                child: PanofskyStepper(
                                  guides: loaded.guides,
                                  initialProgress: loaded.userProgress,
                                  onSaveProgress: (lvl, resp, comp) {
                                    context.read<AnalysisCubit>().saveStepResponse(lvl, resp, comp);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                // Tabbed / Stacked View for Mobile
                return DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      const TabBar(
                        tabs: [
                          Tab(icon: Icon(Icons.image_search), text: 'Visor Visual'),
                          Tab(icon: Icon(Icons.psychology), text: 'Guía Panofsky'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            AnnotatedViewer(
                              artwork: loaded.artwork,
                              image: loaded.image,
                              regions: loaded.regions,
                              onAddRegion: (r) => context.read<AnalysisCubit>().addRegion(r),
                              onDeleteRegion: (id) => context.read<AnalysisCubit>().deleteRegion(id),
                            ),
                            SingleChildScrollView(
                              child: PanofskyStepper(
                                guides: loaded.guides,
                                initialProgress: loaded.userProgress,
                                onSaveProgress: (lvl, resp, comp) {
                                  context.read<AnalysisCubit>().saveStepResponse(lvl, resp, comp);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
