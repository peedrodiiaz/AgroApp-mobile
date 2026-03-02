import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agroapp_mobile/presentation/blocs/maquina/maquina_bloc.dart';
import 'package:agroapp_mobile/presentation/blocs/asignacion/asignacion_bloc.dart';
import 'package:agroapp_mobile/presentation/blocs/auth/auth_bloc.dart';
import 'package:agroapp_mobile/data/models/asignacion_model.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<MaquinaBloc>().add(MaquinaLoadAll());
    context.read<AsignacionBloc>().add(AsignacionLoadByTrabajador());
  }

  String _fmtDate(String? date) {
    if (date == null || date.isEmpty) return '-';
    try {
      final dt = DateTime.parse(date);
      return DateFormat('d MMM', 'es').format(dt);
    } catch (_) {
      return date;
    }
  }

  Future<void> _onRefresh() async {
    context.read<MaquinaBloc>().add(MaquinaLoadAll());
    context.read<AsignacionBloc>().add(AsignacionLoadByTrabajador());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: RefreshIndicator(
        color: const Color(0xFF2E7D32),
        onRefresh: _onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(child: _buildNuevaReservaBtn()),
            SliverToBoxAdapter(child: _buildStatsCards()),
            SliverToBoxAdapter(child: _buildReservasActivas()),
            SliverToBoxAdapter(child: _buildQuickActions()),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }



  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: const Color(0xFF2E7D32),
      elevation: 0,
      automaticallyImplyLeading: false,
      expandedHeight: 88,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final nombre = (state is AuthAuthenticated)
                        ? (state.authResponse.user?.nombre ?? '')
                        : '';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'AgroApp',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Bienvenido${nombre.isNotEmpty ? ', $nombre' : ''}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  tooltip: 'Cerrar sesiÃ³n',
                  onPressed: () =>
                      context.read<AuthBloc>().add(LogoutRequested()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildNuevaReservaBtn() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
          shadowColor: const Color(0xFF2E7D32).withOpacity(0.4),
        ),
        icon: const Icon(Icons.add_rounded, size: 22),
        label: const Text(
          'Nueva Reserva',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        onPressed: () => context.push('/nueva-reserva').then((_) => _onRefresh()),
      ),
    );
  }


  Widget _buildStatsCards() {
    return BlocBuilder<AsignacionBloc, AsignacionState>(
      builder: (context, state) {
        int activas = 0, proximas = 0, vencidas = 0;
        if (state is AsignacionLoaded) {
          final now = DateTime.now().toLocal();
          for (final a in state.asignaciones) {
            final inicio = DateTime.tryParse(a.fechaInicio)?.toLocal();
            final fin =
                a.fechaFin != null ? DateTime.tryParse(a.fechaFin!)?.toLocal() : null;
            if (inicio != null && inicio.isAfter(now)) {
              proximas++;
            } else if (fin == null || fin.isAfter(now)) {
              activas++;
            } else {
              vencidas++;
            }
          }
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            children: [
              _statCard(
                value: '$activas',
                label: 'Activas',
                icon: Icons.calendar_today_rounded,
                color: const Color(0xFF1565C0),
                bg: const Color(0xFFE3F2FD),
              ),
              const SizedBox(width: 12),
              _statCard(
                value: '$proximas',
                label: 'Proximas',
                icon: Icons.schedule_rounded,
                color: const Color(0xFF2E7D32),
                bg: const Color(0xFFE8F5E9),
              ),
              const SizedBox(width: 12),
              _statCard(
                value: '$vencidas',
                label: 'Vencidas',
                icon: Icons.warning_amber_rounded,
                color: const Color(0xFFE65100),
                bg: const Color(0xFFFFF3E0),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statCard({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
    required Color bg,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color.withOpacity(0.7),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildReservasActivas() {
    return BlocBuilder<AsignacionBloc, AsignacionState>(
      builder: (context, state) {
        List<Asignacion> activas = [];
        if (state is AsignacionLoaded) {
          final now = DateTime.now().toLocal();
          activas = state.asignaciones.where((a) {
            final inicio = DateTime.tryParse(a.fechaInicio)?.toLocal();
            final fin = a.fechaFin != null
                ? DateTime.tryParse(a.fechaFin!)?.toLocal()
                : null;
            final noEsProxima = inicio == null || !inicio.isAfter(now);
            final noEsVencida = fin == null || fin.isAfter(now);
            return noEsProxima && noEsVencida;
          }).toList();
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Reservas Activas',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/historial'),
                    child: const Text(
                      'Ver todas',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (state is AsignacionLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: CircularProgressIndicator(
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                )
              else if (state is AsignacionError)
                _errorState(state.mensaje)
              else if (activas.isEmpty)
                _emptyState('No tienes reservas activas')
              else
                ...activas.map(_buildAsignacionCard),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAsignacionCard(Asignacion asignacion) {
    return GestureDetector(
      onTap: () =>
          context.push('/asignacion/${asignacion.id}', extra: asignacion),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8F5E9), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          asignacion.maquina.nombre,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2E7D32),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Activa',
                              style: TextStyle(
                                color: Color(0xFF2E7D32),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (asignacion.descripcion != null &&
                      asignacion.descripcion!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        asignacion.descripcion!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF555555),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${_fmtDate(asignacion.fechaInicio)} - ${_fmtDate(asignacion.fechaFin)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }


  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Row(
        children: [
          _actionCard(
            icon: Icons.warning_amber_rounded,
            iconColor: const Color(0xFFE65100),
            iconBg: const Color(0xFFFFF3E0),
            title: 'Reportar',
            subtitle: 'Incidencia',
            onTap: () => context.push('/registrar-incidencia'),
          ),
          const SizedBox(width: 16),
          _actionCard(
            icon: Icons.build_circle_outlined,
            iconColor: const Color(0xFF1565C0),
            iconBg: const Color(0xFFE3F2FD),
            title: 'Historial',
            subtitle: 'de Uso',
            onTap: () => context.push('/historial'),
          ),
        ],
      ),
    );
  }

  Widget _actionCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _emptyState(String msg) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: Text(msg, style: const TextStyle(color: Colors.grey, fontSize: 14)),
    );
  }

  Widget _errorState(String msg) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: Text(
        'Error: $msg',
        style: const TextStyle(color: Colors.red, fontSize: 14),
      ),
    );
  }


  BottomNavigationBar _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: const Color(0xFF2E7D32),
      unselectedItemColor: const Color(0xFFAAAAAA),
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle:
          const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontSize: 11),
      elevation: 12,
      onTap: (index) {
        if (index == 1) {
          context.push('/maquinas').then((_) {
            setState(() => _selectedIndex = 0);
          });
        } else if (index == 2) {
          context.push('/historial').then((_) {
            setState(() => _selectedIndex = 0);
          });
        } else if (index == 3) {
          context.push('/perfil').then((_) {
            setState(() => _selectedIndex = 0);
          });
        } else {
          setState(() => _selectedIndex = index);
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.agriculture_rounded),
          label: 'Máquinas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: 'Reservas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_rounded),
          label: 'Perfil',
        ),
      ],
    );
  }
}
