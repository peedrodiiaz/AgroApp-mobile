import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agroapp_mobile/presentation/blocs/maquina/maquina_bloc.dart';
import 'package:agroapp_mobile/data/models/maquina_model.dart';
import 'package:go_router/go_router.dart';

class MaquinasListScreen extends StatefulWidget {
  const MaquinasListScreen({super.key});

  @override
  State<MaquinasListScreen> createState() => _MaquinasListScreenState();
}

class _MaquinasListScreenState extends State<MaquinasListScreen> {
  String _filtro = 'TODAS';

  @override
  void initState() {
    super.initState();
    context.read<MaquinaBloc>().add(MaquinaLoadAll());
  }

  Color _estadoColor(String estado) {
    switch (estado) {
      case 'ACTIVA':
        return const Color(0xFF2E7D32);
      case 'MANTENIMIENTO':
        return const Color(0xFFE65100);
      case 'INACTIVA':
        return const Color(0xFFB71C1C);
      default:
        return Colors.grey;
    }
  }

  Color _estadoBg(String estado) {
    switch (estado) {
      case 'ACTIVA':
        return const Color(0xFFE8F5E9);
      case 'MANTENIMIENTO':
        return const Color(0xFFFFF3E0);
      case 'INACTIVA':
        return const Color(0xFFFFEBEE);
      default:
        return Colors.grey[100]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        title: const Text('Máquinas', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: RefreshIndicator(
        color: const Color(0xFF2E7D32),
        onRefresh: () async =>
            context.read<MaquinaBloc>().add(MaquinaLoadAll()),
        child: BlocBuilder<MaquinaBloc, MaquinaState>(
          builder: (context, state) {
            if (state is MaquinaLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
              );
            } else if (state is MaquinaLoaded) {
              return _buildContent(state.maquinas);
            } else if (state is MaquinaError) {
              return Center(
                child: Text('Error: ${state.mensaje}',
                    style: const TextStyle(color: Colors.red)),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildContent(List<Maquina> todas) {
    final activas = todas.where((m) => m.estado == 'ACTIVA').length;
    final mant = todas.where((m) => m.estado == 'MANTENIMIENTO').length;
    final inactivas = todas.where((m) => m.estado == 'INACTIVA').length;

    final filtradas = _filtro == 'TODAS'
        ? todas
        : todas.where((m) => m.estado == _filtro).toList();

    return Column(
      children: [
        // Resumen
        Container(
          color: const Color(0xFF2E7D32),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              _resumenChip('Total', todas.length, Colors.white, Colors.white24),
              const SizedBox(width: 8),
              _resumenChip('Activas', activas, const Color(0xFF2E7D32),
                  const Color(0xFFE8F5E9)),
              const SizedBox(width: 8),
              _resumenChip('Mant.', mant, const Color(0xFFE65100),
                  const Color(0xFFFFF3E0)),
              const SizedBox(width: 8),
              _resumenChip('Inactivas', inactivas, const Color(0xFFB71C1C),
                  const Color(0xFFFFEBEE)),
            ],
          ),
        ),
        // Filtros
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['TODAS', 'ACTIVA', 'MANTENIMIENTO', 'INACTIVA']
                  .map((f) => _filtroBtn(f))
                  .toList(),
            ),
          ),
        ),
        // Lista
        Expanded(
          child: filtradas.isEmpty
              ? const Center(
                  child: Text('No hay máquinas con este filtro',
                      style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: filtradas.length,
                  itemBuilder: (_, i) => _maquinaCard(filtradas[i]),
                ),
        ),
      ],
    );
  }

  Widget _resumenChip(String label, int count, Color textColor, Color bg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(color: textColor, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filtroBtn(String valor) {
    final selected = _filtro == valor;
    return GestureDetector(
      onTap: () => setState(() => _filtro = valor),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF2E7D32) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? const Color(0xFF2E7D32) : Colors.grey[300]!,
          ),
        ),
        child: Text(
          valor == 'TODAS' ? 'Todas' : _labelEstado(valor),
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey[600],
            fontWeight:
                selected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  String _labelEstado(String e) {
    switch (e) {
      case 'ACTIVA':
        return 'Activas';
      case 'MANTENIMIENTO':
        return 'Mantenimiento';
      case 'INACTIVA':
        return 'Inactivas';
      default:
        return e;
    }
  }

  Widget _maquinaCard(Maquina m) {
    final color = _estadoColor(m.estado);
    final bg = _estadoBg(m.estado);

    return GestureDetector(
      onTap: () => context
          .push('/maquina/${m.id}')
          .then((_) => context.read<MaquinaBloc>().add(MaquinaLoadAll())),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.agriculture_rounded, color: color, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m.nombre,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  if (m.modelo != null && m.modelo!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        m.modelo!,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  if (m.numSerie != null && m.numSerie!.isNotEmpty)
                    Text(
                      'S/N: ${m.numSerie}',
                      style: const TextStyle(
                          fontSize: 11, color: Colors.grey),
                    ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _labelEstado(m.estado),
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded,
                color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }
}
