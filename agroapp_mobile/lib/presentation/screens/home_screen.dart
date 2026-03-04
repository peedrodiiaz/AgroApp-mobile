import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agroapp_mobile/presentation/blocs/maquina/maquina_bloc.dart';
import 'package:agroapp_mobile/presentation/blocs/asignacion/asignacion_bloc.dart';
import 'package:agroapp_mobile/presentation/blocs/auth/auth_bloc.dart';
import 'package:agroapp_mobile/data/models/asignacion_model.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class _C {
  static const bg = Color(0xFFF1F8F1);          // fondo verde muy suave
  static const surface = Color(0xFFFFFFFF);
  static const dark = Color(0xFF1B5E20);         // verde oscuro cabecera
  static const darkMid = Color(0xFF2E7D32);      // verde medio stats band
  static const accent = Color(0xFF43A047);       // verde brillante (FAB, dots)
  static const accentDeep = Color(0xFF1B5E20);   // verde profundo
  static const accentSurface = Color(0xFFE8F5E9);// superficie verde claro
  static const rust = Color(0xFFE65100);         // naranja incidencias
  static const rustSurface = Color(0xFFFFF3E0);
  static const sky = Color(0xFF1565C0);          // azul historial
  static const skySurface = Color(0xFFE3F2FD);
  static const muted = Color(0xFF5A6A5C);        // texto apagado
  static const mutedLine = Color(0xFFCCE3CC);    // línea divisor
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedNav = 0;
  AnimationController? _slideCtrl;
  Animation<Offset>? _slideAnim;
  Animation<double>? _fadeAnim;

  @override
  void initState() {
    super.initState();
    final ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 560));
    _slideCtrl = ctrl;
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeOutCubic));
    _fadeAnim = CurvedAnimation(parent: ctrl, curve: Curves.easeOut);
    ctrl.forward();

    context.read<MaquinaBloc>().add(MaquinaLoadAll());
    context.read<AsignacionBloc>().add(AsignacionLoadByTrabajador());
  }

  @override
  void dispose() {
    _slideCtrl?.dispose();
    super.dispose();
  }

  String _fmtDate(String? date) {
    if (date == null || date.isEmpty) return '—';
    try {
      return DateFormat('d MMM', 'es').format(DateTime.parse(date));
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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: _C.dark,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: _C.bg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnim ?? const AlwaysStoppedAnimation(1.0),
              child: SlideTransition(
                position: _slideAnim ?? const AlwaysStoppedAnimation(Offset.zero),
                child: RefreshIndicator(
                  color: _C.accent,
                  backgroundColor: _C.dark,
                  strokeWidth: 2,
                  onRefresh: _onRefresh,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 100),
                    children: [
                      _buildStatsBand(),
                      const SizedBox(height: 28),
                      _buildSectionLabel('RESERVAS ACTIVAS'),
                      _buildTimeline(),
                      const SizedBox(height: 28),
                      _buildSectionLabel('ACCESO RÁPIDO'),
                      _buildQuickRow(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _buildNav(),
    );
  }

  // ── Cabecera ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      color: _C.dark,
      child: SafeArea(
        bottom: false,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final user = (state is AuthAuthenticated)
                ? state.authResponse.user
                : null;
            final nombre = user?.nombre ?? '';
            final rol = user?.rol ?? '';
            final initials = nombre.isNotEmpty
                ? nombre
                    .trim()
                    .split(' ')
                    .take(2)
                    .map((w) => w[0].toUpperCase())
                    .join()
                : 'AG';

            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: _C.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 7),
                            const Text(
                              'AGROAPP',
                              style: TextStyle(
                                color: _C.accent,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          nombre.isNotEmpty ? nombre : 'Bienvenido',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          rol.isNotEmpty ? rol.toLowerCase() : 'trabajador',
                          style: const TextStyle(
                            color: Color(0xFFA5C8A5),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => context
                            .push('/perfil')
                            .then((_) => setState(() => _selectedNav = 0)),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _C.accentDeep,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: _C.accent.withOpacity(0.5), width: 1.5),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () =>
                            context.read<AuthBloc>().add(LogoutRequested()),
                        child: const Icon(
                          Icons.logout_rounded,
                          color: Color(0xFF81A882),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Banda de estadísticas ───────────────────────────────────────────────────
  Widget _buildStatsBand() {
    return BlocBuilder<AsignacionBloc, AsignacionState>(
      builder: (context, state) {
        int activas = 0, proximas = 0, vencidas = 0;
        if (state is AsignacionLoaded) {
          final now = DateTime.now().toLocal();
          for (final a in state.asignaciones) {
            final inicio = DateTime.tryParse(a.fechaInicio)?.toLocal();
            final fin = a.fechaFin != null
                ? DateTime.tryParse(a.fechaFin!)?.toLocal()
                : null;
            if (inicio != null && inicio.isAfter(now)) {
              proximas++;
            } else if (fin == null || fin.isAfter(now)) {
              activas++;
            } else {
              vencidas++;
            }
          }
        }

        return Container(
          color: _C.darkMid,
          padding: const EdgeInsets.symmetric(vertical: 22),
          child: Row(
            children: [
              _statBig('$activas', 'activas', const Color(0xFFA5D6A7)),
              _vertDivider(),
              _statBig('$proximas', 'próximas', const Color(0xFF81D4FA)),
              _vertDivider(),
              _statBig('$vencidas', 'vencidas', const Color(0xFFFF8A65)),
            ],
          ),
        );
      },
    );
  }

  Widget _statBig(String value, String label, Color accent) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: accent,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              height: 1,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFFA5C8A5),
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _vertDivider() {
    return Container(width: 1, height: 40, color: const Color(0xFF1A5C1A));
  }

  // ── Etiqueta de sección ─────────────────────────────────────────────────────
  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              color: _C.muted,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.2,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Container(height: 1, color: _C.mutedLine)),
        ],
      ),
    );
  }

  // ── Timeline de reservas ────────────────────────────────────────────────────
  Widget _buildTimeline() {
    return BlocBuilder<AsignacionBloc, AsignacionState>(
      builder: (context, state) {
        if (state is AsignacionLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(
                child: CircularProgressIndicator(
                    color: _C.accent, strokeWidth: 2)),
          );
        }
        if (state is AsignacionError) return _errorWidget(state.mensaje);
        if (state is! AsignacionLoaded) return _emptyWidget('Sin datos');

        final now = DateTime.now().toLocal();
        final activas = state.asignaciones.where((a) {
          final inicio = DateTime.tryParse(a.fechaInicio)?.toLocal();
          final fin = a.fechaFin != null
              ? DateTime.tryParse(a.fechaFin!)?.toLocal()
              : null;
          return (inicio == null || !inicio.isAfter(now)) &&
              (fin == null || fin.isAfter(now));
        }).toList();

        if (activas.isEmpty) return _emptyWidget('No tienes reservas activas');

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            children: [
              for (int i = 0; i < activas.length; i++)
                _timelineItem(activas[i], i == activas.length - 1),
            ],
          ),
        );
      },
    );
  }

  Widget _timelineItem(Asignacion a, bool isLast) {
    return GestureDetector(
      onTap: () => context.push('/asignacion/${a.id}', extra: a),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    color: _C.accent,
                    shape: BoxShape.circle,
                    border: Border.all(color: _C.bg, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                          color: _C.accent.withOpacity(0.35),
                          blurRadius: 6,
                          spreadRadius: 1),
                    ],
                  ),
                ),
                if (!isLast) Container(width: 2, height: 72, color: _C.mutedLine),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: _C.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _C.mutedLine, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.maquina.nombre,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: _C.dark,
                              letterSpacing: -0.2,
                            ),
                          ),
                          if (a.descripcion != null &&
                              a.descripcion!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              a.descripcion!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 12, color: _C.muted),
                            ),
                          ],
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_rounded,
                                  size: 11, color: _C.muted),
                              const SizedBox(width: 4),
                              Text(
                                '${_fmtDate(a.fechaInicio)}  ›  ${_fmtDate(a.fechaFin)}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: _C.muted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _C.accent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'ACTIVA',
                            style: TextStyle(
                              color: _C.accentDeep,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Icon(Icons.arrow_forward_ios_rounded,
                            size: 13, color: _C.mutedLine),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Acceso rápido ───────────────────────────────────────────────────────────
  Widget _buildQuickRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        children: [
          _quickTile(
            icon: Icons.report_problem_outlined,
            label: 'Incidencias',
            color: _C.rust,
            bg: _C.rustSurface,
            onTap: () => context.push('/registrar-incidencia'),
          ),
          const SizedBox(width: 12),
          _quickTile(
            icon: Icons.history_rounded,
            label: 'Historial',
            color: _C.sky,
            bg: _C.skySurface,
            onTap: () => context.push('/historial'),
          ),
          const SizedBox(width: 12),
          _quickTile(
            icon: Icons.agriculture_outlined,
            label: 'Máquinas',
            color: _C.accentDeep,
            bg: _C.accentSurface,
            onTap: () => context.push('/maquinas'),
          ),
        ],
      ),
    );
  }

  Widget _quickTile({
    required IconData icon,
    required String label,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: _C.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _C.mutedLine, width: 1),
          ),
          child: Column(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 9),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _C.darkMid,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── FAB ─────────────────────────────────────────────────────────────────────
  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () =>
          context.push('/nueva-reserva').then((_) => _onRefresh()),
      backgroundColor: _C.accent,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      icon: const Icon(Icons.add_rounded, size: 22),
      label: const Text(
        'Nueva reserva',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 13,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  // ── Nav inferior ────────────────────────────────────────────────────────────
  Widget _buildNav() {
    const icons = [
      Icons.home_outlined,
      Icons.agriculture_outlined,
      Icons.event_note_outlined,
      Icons.person_outline_rounded,
    ];
    const activeIcons = [
      Icons.home_rounded,
      Icons.agriculture_rounded,
      Icons.event_note_rounded,
      Icons.person_rounded,
    ];

    return Container(
      decoration: const BoxDecoration(
        color: _C.dark,
        border: Border(top: BorderSide(color: Color(0xFF0D3B11), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(4, (i) {
              final sel = _selectedNav == i;
              return Expanded(
                child: InkWell(
                  onTap: () {
                    if (i == 1) {
                      context.push('/maquinas')
                          .then((_) => setState(() => _selectedNav = 0));
                    } else if (i == 2) {
                      context.push('/historial')
                          .then((_) => setState(() => _selectedNav = 0));
                    } else if (i == 3) {
                      context.push('/perfil')
                          .then((_) => setState(() => _selectedNav = 0));
                    } else {
                      setState(() => _selectedNav = i);
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        sel ? activeIcons[i] : icons[i],
                        color: sel ? _C.accent : const Color(0xFF5A8A5C),
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: sel ? 18 : 4,
                        height: 3,
                        decoration: BoxDecoration(
                          color: sel ? _C.accent : Colors.transparent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // ── Estados auxiliares ──────────────────────────────────────────────────────
  Widget _emptyWidget(String msg) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36),
        decoration: BoxDecoration(
          color: _C.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _C.mutedLine),
        ),
        child: Column(
          children: [
            Icon(Icons.inbox_rounded, size: 36, color: Colors.grey.shade300),
            const SizedBox(height: 10),
            Text(msg, style: const TextStyle(color: _C.muted, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _errorWidget(String msg) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1EC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFFFCFBF)),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: _C.rust, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(
                    color: _C.rust,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


