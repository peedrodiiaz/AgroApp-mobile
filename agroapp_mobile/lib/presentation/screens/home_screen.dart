import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agroapp_mobile/presentation/blocs/maquina/maquina_bloc.dart';
import 'package:agroapp_mobile/presentation/blocs/asignacion/asignacion_bloc.dart';
import 'package:agroapp_mobile/presentation/blocs/auth/auth_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    context.read<MaquinaBloc>().add(MaquinaLoadAll());
    context.read<AsignacionBloc>().add(AsignacionLoadByTrabajador());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2E7D32),
        onPressed: () => context.push('/nueva-reserva'),
        tooltip: 'Nueva Reserva',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF2E7D32),
      elevation: 0,
      title: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AgroApp',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Bienvenido',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: () {
            context.read<AuthBloc>().add(LogoutRequested());
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsHeader(),
          const SizedBox(height: 16),
          _buildAsignacionesSection(),
          const SizedBox(height: 16),
          _buildMaquinasSection(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildStatsHeader() {
    return BlocBuilder<AsignacionBloc, AsignacionState>(
      builder: (context, state) {
        int totalAsignaciones = 0;
        if (state is AsignacionLoaded) {
          totalAsignaciones = state.asignaciones.length;
        }
        return Container(
          color: const Color(0xFF2E7D32),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: Row(
            children: [
              _buildStatCard('$totalAsignaciones', 'Asignaciones'),
              const SizedBox(width: 12),
              BlocBuilder<MaquinaBloc, MaquinaState>(
                builder: (context, mState) {
                  int totalMaquinas = mState is MaquinaLoaded
                      ? mState.maquinas.length
                      : 0;
                  int activas = mState is MaquinaLoaded
                      ? mState.maquinas
                            .where((m) => m.estado == 'ACTIVA')
                            .length
                      : 0;
                  return Row(
                    children: [
                      _buildStatCard('$totalMaquinas', 'Máquinas'),
                      const SizedBox(width: 12),
                      _buildStatCard('$activas', 'Activas'),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAsignacionesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reservas Activas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B1B1B),
            ),
          ),
          const SizedBox(height: 12),
          BlocBuilder<AsignacionBloc, AsignacionState>(
            builder: (context, state) {
              if (state is AsignacionLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
                );
              } else if (state is AsignacionLoaded) {
                if (state.asignaciones.isEmpty) {
                  return _buildEmptyState('No tienes asignaciones activas');
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.asignaciones.length,
                  itemBuilder: (context, index) {
                    return _buildAsignacionCard(state.asignaciones[index]);
                  },
                );
              } else if (state is AsignacionError) {
                return _buildErrorState(state.mensaje);
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAsignacionCard(dynamic asignacion) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          context.push('/asignacion/${asignacion.id}', extra: asignacion);
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.assignment,
            color: Color(0xFF2E7D32),
            size: 22,
          ),
        ),
        title: Text(
          asignacion.descripcion ?? 'Sin descripción',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${asignacion.fechaInicio ?? ''} · ${asignacion.fechaFin ?? ''}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Activa',
            style: TextStyle(
              color: Color(0xFF2E7D32),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMaquinasSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Máquinas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B1B1B),
            ),
          ),
          const SizedBox(height: 12),
          BlocBuilder<MaquinaBloc, MaquinaState>(
            builder: (context, state) {
              if (state is MaquinaLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
                );
              } else if (state is MaquinaLoaded) {
                if (state.maquinas.isEmpty) {
                  return _buildEmptyState('No hay máquinas disponibles');
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.maquinas.length,
                  itemBuilder: (context, index) {
                    return _buildMaquinaCard(state.maquinas[index]);
                  },
                );
              } else if (state is MaquinaError) {
                return _buildErrorState(state.mensaje);
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMaquinaCard(dynamic maquina) {
    final bool isActiva = maquina.estado == 'ACTIVA';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => context.push('/maquina/${maquina.id}'),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.agriculture,
            color: Color(0xFF2E7D32),
            size: 22,
          ),
        ),
        title: Text(
          maquina.nombre,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            maquina.estado,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isActiva ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            maquina.estado,
            style: TextStyle(
              color: isActiva
                  ? const Color(0xFF2E7D32)
                  : const Color(0xFFD32F2F),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String mensaje) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: Text(
        mensaje,
        style: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
    );
  }

  Widget _buildErrorState(String mensaje) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: Text(
        'Error: $mensaje',
        style: const TextStyle(color: Colors.red, fontSize: 14),
      ),
    );
  }

  BottomNavigationBar _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: const Color(0xFF2E7D32),
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == 0) {
          context.push('/registrar-incidencia');
        } else if (index == 2) {
          context.push('/historial');
        } else {
          setState(() => _selectedIndex = index);
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Registrar',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historial'),
      ],
    );
  }
}
