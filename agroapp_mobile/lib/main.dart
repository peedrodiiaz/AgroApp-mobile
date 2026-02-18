import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agroapp_mobile/config/theme/app_theme.dart';
import 'package:agroapp_mobile/config/router/app_router.dart';
import 'package:agroapp_mobile/core/network/api_client.dart';
import 'package:agroapp_mobile/core/utils/token_manager.dart';
import 'package:agroapp_mobile/data/repositories/auth_repository.dart';
import 'package:agroapp_mobile/data/repositories/maquina_repository.dart';
import 'package:agroapp_mobile/data/repositories/asignacion_repository.dart';
import 'package:agroapp_mobile/presentation/blocs/auth/auth_bloc.dart';
import 'package:agroapp_mobile/presentation/blocs/maquina/maquina_bloc.dart';
import 'package:agroapp_mobile/presentation/blocs/asignacion/asignacion_bloc.dart';
import 'package:go_router/go_router.dart';

void main() {
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

  @override
  void initState() {
    super.initState();
    final tokenManager = TokenManager();
    final apiClient = ApiClient(tokenManager);

    final authRepository = AuthRepository(apiClient);
    final maquinaRepository = MaquinaRepository(apiClient);
    final asignacionRepository = AsignacionRepository(apiClient);

    _authBloc = AuthBloc(
      authRepository: authRepository,
      tokenManager: tokenManager,
    )..add(CheckAuthStatus());

    _maquinaBloc = MaquinaBloc(maquinaRepository: maquinaRepository);
    _asignacionBloc = AsignacionBloc(asignacionRepository: asignacionRepository);

    _router = AppRouter.createRouter(_authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    _maquinaBloc.close();
    _asignacionBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider.value(value: _maquinaBloc),
        BlocProvider.value(value: _asignacionBloc),
      ],
      child: MaterialApp.router(
        title: 'AgroApp',
        theme: AppTheme.lightTheme,
        routerConfig: _router,
      ),
    );
  }
}
