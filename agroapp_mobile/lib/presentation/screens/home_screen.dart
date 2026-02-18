import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agroapp_mobile/presentation/blocs/maquina/maquina_bloc.dart';
import 'package:agroapp_mobile/presentation/blocs/asignacion/asignacion_bloc.dart';
import 'package:agroapp_mobile/presentation/blocs/auth/auth_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        title: const Text(
          'AgroApp',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección Mis Asignaciones
            const Text(
              'Mis Asignaciones',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 12),
            BlocBuilder<AsignacionBloc, AsignacionState>(
              builder: (context, state) {
                if (state is AsignacionLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AsignacionLoaded) {
                  if (state.asignaciones.isEmpty) {
                    return const Center(child: Text('No tienes asignaciones'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.asignaciones.length,
                    itemBuilder: (context, index) {
                      final asignacion = state.asignaciones[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(Icons.assignment, color: Color(0xFF2E7D32)),
                          title: Text(asignacion.descripcion ?? 'Sin descripción'),
                          subtitle: Text(
                            '${asignacion.fechaInicio} - ${asignacion.fechaFin}',
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is AsignacionError) {
                  return Center(child: Text('Error: ${state.mensaje}'));
                }
                return const SizedBox();
              },
            ),

            const SizedBox(height: 24),


          //Aqui las masquinas
            const Text(
              'Máquinas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 12),
            BlocBuilder<MaquinaBloc, MaquinaState>(
              builder: (context, state) {
                if (state is MaquinaLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MaquinaLoaded) {
                  if (state.maquinas.isEmpty) {
                    return const Center(child: Text('No hay máquinas'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.maquinas.length,
                    itemBuilder: (context, index) {
                      final maquina = state.maquinas[index];  
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(Icons.agriculture, color: Color(0xFF2E7D32)),
                          title: Text(maquina.nombre),
                          subtitle: Text(maquina.tipo),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: maquina.estado == 'ACTIVA'
                                  ? Colors.green[100]
                                  : Colors.red[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              maquina.estado,
                              style: TextStyle(
                                color: maquina.estado == 'ACTIVA'
                                    ? Colors.green[800]
                                    : Colors.red[800],
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is MaquinaError) {
                  return Center(child: Text('Error: ${state.mensaje}'));
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
