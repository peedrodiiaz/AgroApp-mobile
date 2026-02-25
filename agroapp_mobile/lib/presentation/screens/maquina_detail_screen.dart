import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agroapp_mobile/presentation/blocs/maquina/maquina_bloc.dart';

class MaquinaDetailScreen extends StatefulWidget {
  final int maquinaId;

  const MaquinaDetailScreen({super.key, required this.maquinaId});

  @override
  State<MaquinaDetailScreen> createState() => _MaquinaDetailScreenState();
}

class _MaquinaDetailScreenState extends State<MaquinaDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MaquinaBloc>().add(MaquinaLoadById(widget.maquinaId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        title: const Text(
          'Detalle Máquina',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<MaquinaBloc, MaquinaState>(
        builder: (context, state) {
          if (state is MaquinaLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
            );
          } else if (state is MaquinaDetailLoaded) {
            return _buildDetalle(state.maquina);
          } else if (state is MaquinaError) {
            return Center(child: Text('Error: ${state.mensaje}'));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildDetalle(dynamic maquina) {
    final bool isActiva = maquina.estado == 'ACTIVA';
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.agriculture,
                    color: Color(0xFF2E7D32),
                    size: 36,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  maquina.nombre ?? 'Sin nombre',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: isActiva
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    maquina.estado ?? '',
                    style: TextStyle(
                      color: isActiva
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFD32F2F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Información',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const Divider(height: 20),
                _buildInfoRow(Icons.build, 'Modelo', maquina.modelo ?? '-'),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.numbers, 'Nº Serie', maquina.numSerie ?? '-'),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.calendar_today,
                  'Fecha Compra',
                  maquina.fechaCompra ?? '-',
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
        Icon(icon, color: const Color(0xFF2E7D32), size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
