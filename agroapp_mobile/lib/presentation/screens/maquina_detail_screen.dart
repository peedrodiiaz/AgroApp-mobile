import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:agroapp_mobile/presentation/blocs/maquina/maquina_bloc.dart';
import 'package:agroapp_mobile/data/models/maquina_model.dart';
import 'package:agroapp_mobile/data/models/asignacion_model.dart';
import 'package:agroapp_mobile/data/models/incidencia_model.dart';
import 'package:agroapp_mobile/data/repositories/asignacion_repository.dart';
import 'package:agroapp_mobile/data/repositories/incidencia_repository.dart';

class MaquinaDetailScreen extends StatefulWidget {
  final int maquinaId;

  const MaquinaDetailScreen({super.key, required this.maquinaId});

  @override
  State<MaquinaDetailScreen> createState() => _MaquinaDetailScreenState();
}

class _MaquinaDetailScreenState extends State<MaquinaDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Asignacion>> _reservasFuture;
  late Future<List<Incidencia>> _incidenciasFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<MaquinaBloc>().add(MaquinaLoadById(widget.maquinaId));
    _reservasFuture = context
        .read<AsignacionRepository>()
        .getByMaquina(widget.maquinaId);
    _incidenciasFuture = context
        .read<IncidenciaRepository>()
        .getByMaquina(widget.maquinaId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
      body: BlocBuilder<MaquinaBloc, MaquinaState>(
        builder: (context, state) {
          if (state is MaquinaLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
            );
          } else if (state is MaquinaDetailLoaded) {
            return _buildScaffold(state.maquina);
          } else if (state is MaquinaError) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xFF2E7D32),
                iconTheme: const IconThemeData(color: Colors.white),
                title: const Text('Detalle Máquina',
                    style: TextStyle(color: Colors.white)),
              ),
              body: Center(child: Text('Error: ${state.mensaje}')),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildScaffold(Maquina m) {
    final color = _estadoColor(m.estado);
    final bg = _estadoBg(m.estado);

    return NestedScrollView(
      headerSliverBuilder: (_, _) => [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          backgroundColor: const Color(0xFF2E7D32),
          iconTheme: const IconThemeData(color: Colors.white),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.agriculture_rounded,
                        color: Colors.white, size: 38),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    m.nombre,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      m.estado,
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'Info'),
              Tab(text: 'Reservas'),
              Tab(text: 'Incidencias'),
            ],
          ),
        ),
      ],
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInfoTab(m),
          _buildReservasTab(),
          _buildIncidenciasTab(),
        ],
      ),
    );
  }

  // ─── TAB INFO ─────────────────────────────────────────────────────────────

  Widget _buildInfoTab(Maquina m) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _card(
            title: 'Especificaciones',
            children: [
              _infoRow(Icons.precision_manufacturing_outlined, 'Modelo',
                  m.modelo ?? '-'),
              _infoRow(Icons.numbers_rounded, 'Número de serie',
                  m.numSerie ?? '-'),
              _infoRow(Icons.calendar_today_outlined, 'Fecha de compra',
                  m.fechaCompra ?? '-'),
            ],
          ),
          const SizedBox(height: 12),
          _card(
            title: 'Estado actual',
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _estadoColor(m.estado),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    m.estado,
                    style: TextStyle(
                      color: _estadoColor(m.estado),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── TAB RESERVAS ─────────────────────────────────────────────────────────

  Widget _buildReservasTab() {
    return FutureBuilder<List<Asignacion>>(
      future: _reservasFuture,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2E7D32)));
        }
        if (snap.hasError) {
          return Center(
              child: Text('Error: ${snap.error}',
                  style: const TextStyle(color: Colors.red)));
        }
        final reservas = snap.data ?? [];
        if (reservas.isEmpty) {
          return _emptyState(
              Icons.event_busy_outlined, 'Sin reservas registradas');
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: reservas.length,
          itemBuilder: (_, i) => _reservaCard(reservas[i]),
        );
      },
    );
  }

  Widget _reservaCard(Asignacion a) {
    final isActiva = a.isActiva;
    return GestureDetector(
      onTap: () => context.push('/asignacion/${a.id}', extra: a),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isActiva
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.calendar_month_rounded,
                color: isActiva ? const Color(0xFF2E7D32) : Colors.grey,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a.trabajador.nombre,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${a.fechaInicio} → ${a.fechaFin ?? 'En curso'}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isActiva
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isActiva ? 'Activa' : 'Cerrada',
                style: TextStyle(
                  color: isActiva ? const Color(0xFF2E7D32) : Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── TAB INCIDENCIAS ──────────────────────────────────────────────────────

  Widget _buildIncidenciasTab() {
    return FutureBuilder<List<Incidencia>>(
      future: _incidenciasFuture,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2E7D32)));
        }
        if (snap.hasError) {
          return Center(
              child: Text('Error: ${snap.error}',
                  style: const TextStyle(color: Colors.red)));
        }
        final incidencias = snap.data ?? [];
        if (incidencias.isEmpty) {
          return _emptyState(
              Icons.check_circle_outline, 'Sin incidencias abiertas');
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: incidencias.length,
          itemBuilder: (_, i) => _incidenciaCard(incidencias[i]),
        );
      },
    );
  }

  Widget _incidenciaCard(Incidencia inc) {
    Color prioColor;
    switch (inc.prioridad) {
      case 'ALTA':
        prioColor = const Color(0xFFD32F2F);
        break;
      case 'MEDIA':
        prioColor = const Color(0xFFE65100);
        break;
      default:
        prioColor = const Color(0xFF2E7D32);
    }

    final estadoAbierta = inc.estadoIncidencia == 'ABIERTA' ||
        inc.estadoIncidencia == 'EN_PROGRESO';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: prioColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.warning_amber_rounded,
                color: prioColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inc.titulo,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                if (inc.fechaApertura != null)
                  Text(
                    inc.fechaApertura!,
                    style:
                        const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: prioColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  inc.prioridad,
                  style: TextStyle(
                      color: prioColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                estadoAbierta ? 'Abierta' : 'Resuelta',
                style: TextStyle(
                  fontSize: 11,
                  color: estadoAbierta
                      ? const Color(0xFFD32F2F)
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── HELPERS ──────────────────────────────────────────────────────────────

  Widget _card({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const Divider(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2E7D32), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(IconData icon, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(message,
              style: TextStyle(color: Colors.grey[500], fontSize: 15)),
        ],
      ),
    );
  }
}
