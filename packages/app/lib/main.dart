import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:art_analyst_app/core/theme/app_theme.dart';
import 'package:art_analyst_app/core/router/app_router.dart';
import 'package:art_analyst_app/data/repositories/artwork_repository.dart';
import 'package:art_analyst_app/features/catalog/cubit/catalog_cubit.dart';
import 'package:art_analyst_app/features/analysis/cubit/analysis_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = ArtworkRepository();

  runApp(ArtAnalystApp(repository: repository));
}

class ArtAnalystApp extends StatelessWidget {
  final ArtworkRepository repository;

  const ArtAnalystApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CatalogCubit>(
          create: (_) => CatalogCubit(repository: repository)..loadCatalog(),
        ),
        BlocProvider<AnalysisCubit>(
          create: (_) => AnalysisCubit(repository: repository),
        ),
      ],
      child: MaterialApp.router(
        title: 'ArtAnalyst - Análisis Visual & Semáforo de Licencias',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.createRouter(),
      ),
    );
  }
}
