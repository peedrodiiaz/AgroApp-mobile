import 'dart:async';
import 'package:agroapp_mobile/data/services/incidencia_service.dart';
import 'package:agroapp_mobile/presentation/blocs/incidencias/incidencias_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agroapp_mobile/config/theme/app_theme.dart';
import 'package:agroapp_mobile/config/router/app_router.dart';
import 'package:agroapp_mobile/core/network/api_client.dart';
import 'package:agroapp_mobile/core/utils/token_manager.dart';
import 'package:agroapp_mobile/data/services/auth_service.dart';
import 'package:agroapp_mobile/data/services/maquina_service.dart';
import 'package:agroapp_mobile/data/services/asignacion_service.dart';
import 'package:agroapp_mobile/presentation/blocs/auth/auth_bloc.dart';
import 'package:agroapp_mobile/presentation/blocs/maquina/maquina_bloc.dart';
import 'package:agroapp_mobile/presentation/blocs/asignacion/asignacion_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthBloc _authBloc;
  late final MaquinaBloc _maquinaBloc;
  late final AsignacionBloc _asignacionBloc;
  late final GoRouter _router;
  late final IncidenciasBloc _incidenciaBloc;
  late final AuthRepository _authRepository;
  late final MaquinaRepository _maquinaRepository;
  late final AsignacionRepository _asignacionRepository;
  late final IncidenciaRepository _incidenciaRepository;
  late final ApiClient _apiClient;
  late final StreamSubscription<void> _unauthorizedSubscription;

  @override
  void initState() {
    super.initState();
    final tokenManager = TokenManager();
    _apiClient = ApiClient(tokenManager);

    final authRepository = AuthRepository(_apiClient);
    final maquinaRepository = MaquinaRepository(_apiClient);
    final asignacionRepository = AsignacionRepository(_apiClient);
    final incidenciaRepository = IncidenciaRepository(_apiClient);

    _authRepository = authRepository;
    _maquinaRepository = maquinaRepository;
    _asignacionRepository = asignacionRepository;
    _incidenciaRepository = incidenciaRepository;

    _authBloc = AuthBloc(
      authRepository: authRepository,
      tokenManager: tokenManager,
    )..add(CheckAuthStatus());

    _unauthorizedSubscription = _apiClient.onUnauthorized.listen((_) {
      _authBloc.add(LogoutRequested());
    });

    _maquinaBloc = MaquinaBloc(maquinaRepository: maquinaRepository);
    _asignacionBloc = AsignacionBloc(asignacionRepository: asignacionRepository);
    _incidenciaBloc = IncidenciasBloc(incidenciaRepository: incidenciaRepository);

    _router = AppRouter.createRouter(_authBloc);
  }

  @override
  void dispose() {
    _unauthorizedSubscription.cancel();
    _apiClient.dispose();
    _authBloc.close();
    _maquinaBloc.close();
    _asignacionBloc.close();
    _incidenciaBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider.value(value: _maquinaBloc),
        BlocProvider.value(value: _asignacionBloc),
        BlocProvider.value(value: _incidenciaBloc),
        RepositoryProvider.value(value: _maquinaRepository),
        RepositoryProvider.value(value: _asignacionRepository),
        RepositoryProvider.value(value: _incidenciaRepository),
        RepositoryProvider.value(value: _authRepository),
      ],
      child: MaterialApp.router(
        title: 'AgroApp',
        theme: AppTheme.lightTheme,
        routerConfig: _router,
      ),
    );
  }
}
