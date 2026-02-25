import 'dart:async';
import 'package:agroapp_mobile/presentation/screens/asignacion_detail_screen.dart';
import 'package:agroapp_mobile/presentation/screens/home_screen.dart';
import 'package:agroapp_mobile/presentation/screens/login_screen.dart';
import 'package:agroapp_mobile/presentation/screens/maquina_detail_screen.dart';
import 'package:agroapp_mobile/presentation/screens/nueva_reserva_screen.dart';
import 'package:agroapp_mobile/presentation/screens/registrar_incidencia_screen.dart';
import 'package:agroapp_mobile/presentation/screens/historial_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:agroapp_mobile/presentation/blocs/auth/auth_bloc.dart';

class AppRouter {
  static GoRouter createRouter(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: '/login',
      refreshListenable: GoRouterRefreshStream(authBloc.stream),

      redirect: (context, state) {
        final authState = authBloc.state;
        final isAuthenticated = authState is AuthAuthenticated;
        final isGoingToLogin = state.matchedLocation == '/login';

        if (!isAuthenticated && !isGoingToLogin) {
          return '/login';
        }

        if (isAuthenticated && isGoingToLogin) {
          return '/home';
        }

        return null;
      },

      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/nueva-reserva',
          name: 'nuevaReserva',
          builder: (context, state) => const NuevaReservaScreen(),
        ),

        GoRoute(
          path: '/historial',
          name: 'historial',
          builder: (context, state) => const HistorialScreen(),
        ),

        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/maquina/:id',
          name: 'maquinaDetail',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return MaquinaDetailScreen(maquinaId: id);
          },
        ),
        GoRoute(
          path: '/asignacion/:id',
          name: 'asignacionDetail',
          builder: (context, state) {
            final asignacion = state.extra;
            return AsignacionDetailScreen(asignacion: asignacion);
          },
        ),
        GoRoute(
          path: '/registrar-incidencia',
          name: 'registrarIncidencia',
          builder: (context, state) => const RegistrarIncidenciaScreen(),
        ),
      ],

      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.red),
              const SizedBox(height: 20),
              Text(
                'Página no encontrada',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              Text('${state.uri}'),
            ],
          ),
        ),
      ),
    );
  }
}

// Mtodo para escuchar cambios en el AuthBloc y refrescar la navegación
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
