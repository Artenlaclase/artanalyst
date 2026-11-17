import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:art_analyst_app/features/catalog/views/catalog_view.dart';
import 'package:art_analyst_app/features/catalog/cubit/catalog_cubit.dart';
import 'package:art_analyst_app/features/catalog/cubit/catalog_state.dart';
import 'package:art_analyst_app/features/analysis/views/analysis_view.dart';
import 'package:art_analyst_app/features/analysis/cubit/analysis_cubit.dart';
import 'package:art_analyst_app/features/guide/views/license_guide_view.dart';
import 'package:art_analyst_app/features/study/views/study_view.dart';
import 'package:art_analyst_app/features/session/views/self_portraits_session_view.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppRouter {
  static GoRouter createRouter() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/catalog',
      routes: [
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return ScaffoldWithNavigation(child: child);
          },
          routes: [
            GoRoute(
              path: '/catalog',
              builder: (context, state) => const CatalogView(),
            ),
            GoRoute(
              path: '/artwork/:id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                // Trigger load in AnalysisCubit
                final catalogState = context.read<CatalogCubit>().state;
                if (catalogState is CatalogLoaded) {
                  final artwork = catalogState.artworks.cast<dynamic>().firstWhere(
                        (a) => a.id == id,
                        orElse: () => null,
                      );
                  if (artwork != null) {
                    final image = catalogState.primaryImages[id];
                    context.read<AnalysisCubit>().loadArtworkAnalysis(artwork, image);
                  }
                }
                return AnalysisView(artworkId: id);
              },
            ),
            GoRoute(
              path: '/study',
              builder: (context, state) {
                final tabStr = state.uri.queryParameters['tab'];
                final tab = int.tryParse(tabStr ?? '0') ?? 0;
                return StudyView(initialTab: tab);
              },
            ),
            GoRoute(
              path: '/session/self-portraits',
              builder: (context, state) {
                final tabStr = state.uri.queryParameters['tab'];
                final tab = int.tryParse(tabStr ?? '0') ?? 0;
                return SelfPortraitsSessionView(initialTab: tab);
              },
            ),
            GoRoute(
              path: '/licenses-guide',
              builder: (context, state) => const LicenseGuideView(),
            ),
          ],
        ),
      ],
    );
  }
}

/// Adaptive shell: NavigationRail on Desktop/Web (>700px), NavigationBar on Mobile
class ScaffoldWithNavigation extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavigation({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/session/self-portraits')) return 1;
    if (location.startsWith('/study')) return 2;
    if (location.startsWith('/licenses-guide')) return 3;
    if (location.startsWith('/catalog') || location.startsWith('/artwork')) return 0;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.read<CatalogCubit>().filterBySemaphore(null);
        context.read<CatalogCubit>().search('');
        context.go('/catalog');
        break;
      case 1:
        context.go('/session/self-portraits');
        break;
      case 2:
        context.go('/study');
        break;
      case 3:
        context.go('/licenses-guide');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 700;
        final selectedIndex = _calculateSelectedIndex(context);

        if (isDesktop) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) => _onItemTapped(index, context),
                  labelType: NavigationRailLabelType.all,
                  leading: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Icon(Icons.palette_rounded, size: 32, color: Color(0xFF8B4513)),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.grid_view_rounded),
                      selectedIcon: Icon(Icons.grid_view_sharp),
                      label: Text('Catálogo'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.face_retouching_natural_rounded),
                      selectedIcon: Icon(Icons.portrait_rounded),
                      label: Text('Autorretratos'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.auto_stories_outlined),
                      selectedIcon: Icon(Icons.auto_stories_rounded),
                      label: Text('Estudio'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.policy_outlined),
                      selectedIcon: Icon(Icons.policy),
                      label: Text('Semáforo Legal'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: child),
              ],
            ),
          );
        }

        return Scaffold(
          body: child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) => _onItemTapped(index, context),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.grid_view_rounded),
                label: 'Catálogo',
              ),
              NavigationDestination(
                icon: Icon(Icons.face_retouching_natural_rounded),
                label: 'Autorretratos',
              ),
              NavigationDestination(
                icon: Icon(Icons.auto_stories_outlined),
                selectedIcon: Icon(Icons.auto_stories_rounded),
                label: 'Estudio',
              ),
              NavigationDestination(
                icon: Icon(Icons.policy_outlined),
                label: 'Semáforo Legal',
              ),
            ],
          ),
        );
      },
    );
  }
}
