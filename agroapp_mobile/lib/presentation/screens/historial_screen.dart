import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agroapp_mobile/presentation/blocs/asignacion/asignacion_bloc.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AsignacionBloc>().add(AsignacionLoadByTrabajador());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        title: const Text(
          'Historial de Uso',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<AsignacionBloc, AsignacionState>(
        builder: (context, state) {
          if (state is AsignacionLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
            );
          } else if (state is AsignacionLoaded) {
            return _buildContent(state);
          } else if (state is AsignacionError) {
            return Center(child: Text('Error: ${state.mensaje}'));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildContent(AsignacionLoaded state) {
    final total = state.asignaciones.length;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header azul con total
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF1565C0),
            ),
            child: Column(
              children: [
                Text(
                  '$total',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Asignaciones totales',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Lista de asignaciones
          if (state.asignaciones.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'No tienes historial de asignaciones',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.asignaciones.length,
              itemBuilder: (context, index) {
                return _buildAsignacionCard(state.asignaciones[index]);
              },
            ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAsignacionCard(dynamic asignacion) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.agriculture, color: Color(0xFF2E7D32), size: 22),
        ),
        title: Text(
          asignacion.descripcion ?? 'Sin descripción',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          asignacion.fechaInicio ?? '',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                _buildInfoRow(
                  Icons.calendar_today,
                  'Fecha inicio',
                  asignacion.fechaInicio ?? '-',
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.event,
                  'Fecha fin',
                  asignacion.fechaFin ?? '-',
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.description,
                  'Descripción',
                  asignacion.descripcion ?? '-',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF2E7D32), size: 18),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
