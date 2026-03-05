import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:agroapp_mobile/config/theme/app_colors.dart';
import 'package:agroapp_mobile/presentation/blocs/asignacion/asignacion_bloc.dart';
import 'package:agroapp_mobile/data/models/asignacion_model.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  @override
  void initState() {
    super.initState();
    // Cargamos las asignaciones del trabajador al iniciar
    context.read<AsignacionBloc>().add(AsignacionLoadByTrabajador());
  }

  String _getDay(String? date) => 
      date != null ? DateFormat('dd').format(DateTime.parse(date)) : '--';
  
  String _getMonth(String? date) => 
      date != null ? DateFormat('MMM', 'es').format(DateTime.parse(date)).toUpperCase() : '---';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'HISTORIAL DE USO',
          style: TextStyle(
            color: AppColors.textPrimary, 
            fontSize: 14, 
            fontWeight: FontWeight.w900, 
            letterSpacing: 2
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: BlocBuilder<AsignacionBloc, AsignacionState>(
        builder: (context, state) {
          if (state is AsignacionLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (state is AsignacionLoaded) {
            return _buildModernList(state.todas);
          } else if (state is AsignacionError) {
            return Center(child: Text('Error: ${state.mensaje}', style: const TextStyle(color: AppColors.error)));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildModernList(List<Asignacion> asignaciones) {
    if (asignaciones.isEmpty) {
      return const Center(
        child: Text('No hay registros de actividad', style: TextStyle(color: AppColors.textSecondary))
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: asignaciones.length,
      itemBuilder: (context, index) {
        final a = asignaciones[index];
        
        return GestureDetector(
          // Al pulsar la tarjeta, navegamos al detalle
          onTap: () => context.push('/asignacion/${a.id}', extra: a),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.04),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Lado izquierdo: Fecha estilizada
                  Container(
                    width: 75,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.07),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        bottomLeft: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getDay(a.fechaInicio), 
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)
                        ),
                        Text(
                          _getMonth(a.fechaInicio), 
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primary)
                        ),
                      ],
                    ),
                  ),
                  // Lado derecho: Información
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                a.maquina.nombre,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                              ),
                              // Los 3 puntos ahora tienen acción: abrir detalle
                              Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.border.withOpacity(0.8)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            a.descripcion?.isNotEmpty == true ? a.descripcion! : 'Uso de maquinaria agrícola',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 16),
                          // Badges informativos (Sin IDs)
                          Row(
                            children: [
                              _infoBadge(Icons.calendar_month_outlined, 'Fin: ${DateFormat('dd/MM').format(DateTime.parse(a.fechaFin!))}'),
                              const SizedBox(width: 8),
                              _infoBadge(Icons.timer_outlined, 'Completado'),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _infoBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            label, 
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)
          ),
        ],
      ),
    );
  }
}