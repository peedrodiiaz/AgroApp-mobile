import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:agroapp_mobile/config/theme/app_colors.dart';
import 'package:agroapp_mobile/presentation/blocs/maquina/maquina_bloc.dart';
import 'package:agroapp_mobile/presentation/blocs/asignacion/asignacion_bloc.dart';
import 'package:agroapp_mobile/presentation/blocs/auth/auth_bloc.dart';
import 'package:agroapp_mobile/data/models/asignacion_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNav = 0;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() {
    context.read<MaquinaBloc>().add(MaquinaLoadAll());
    context.read<AsignacionBloc>().add(AsignacionLoadByTrabajador());
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '—';
    try {
      return DateFormat('d MMM', 'es').format(DateTime.parse(date));
    } catch (_) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Barra transparente para el nuevo diseño
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Un fondo gris muy sutil para resaltar tarjetas blancas
      body: RefreshIndicator(
        onRefresh: () async => _cargarDatos(),
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCurvedHeaderAndStats(context),
              const SizedBox(height: 20),
              _buildSectionTitle('Tus Tareas Activas'),
              _buildReservasCarousel(),
              const SizedBox(height: 10),
              _buildSectionTitle('Panel de Control'),
              _buildGridActions(),
              const SizedBox(height: 100), // Espacio para que el FAB no tape el contenido
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/nueva-reserva').then((_) => _cargarDatos()),
        backgroundColor: AppColors.secondary,
        elevation: 4,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
      ),
      bottomNavigationBar: _buildModernBottomNav(),
    );
  }

  // --- 1. CABECERA CURVA Y ESTADÍSTICAS FLOTANTES ---
  Widget _buildCurvedHeaderAndStats(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Fondo verde curvo
        Container(
          height: 220,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final nombre = (state is AuthAuthenticated) ? state.authResponse.user?.nombre ?? 'Trabajador' : 'Trabajador';
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('AgroApp Dashboard', style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1.5)),
                          const SizedBox(height: 4),
                          Text('Hola, $nombre 👋', style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                        child: IconButton(
                          icon: const Icon(Icons.logout_rounded, color: Colors.white),
                          onPressed: () => context.read<AuthBloc>().add(LogoutRequested()),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        // Tarjeta de estadísticas flotante
        Positioned(
          top: 130, // La empujamos hacia abajo para que monte sobre el borde
          left: 20,
          right: 20,
          child: BlocBuilder<AsignacionBloc, AsignacionState>(
            builder: (context, state) {
              int activas = 0, proximas = 0;
              if (state is AsignacionLoaded) {
                activas = state.activas.length;
                proximas = state.proximas.length;
              }
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: AppColors.primary.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(child: _buildStatColumn(Icons.play_circle_fill, 'En curso', activas.toString(), AppColors.secondary)),
                    Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.2)),
                    Expanded(child: _buildStatColumn(Icons.upcoming, 'Próximas', proximas.toString(), AppColors.info)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatColumn(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  // --- 2. TÍTULOS DE SECCIÓN ---
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 40.0, bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.5),
      ),
    );
  }

  // --- 3. CARRUSEL HORIZONTAL DE RESERVAS ---
  Widget _buildReservasCarousel() {
    return BlocBuilder<AsignacionBloc, AsignacionState>(
      builder: (context, state) {
        if (state is AsignacionLoading) return const Center(child: CircularProgressIndicator());
        if (state is AsignacionLoaded) {
          if (state.activas.isEmpty) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: const Row(
                children: [
                  Icon(Icons.check_circle_outline, color: AppColors.success, size: 32),
                  SizedBox(width: 16),
                  Expanded(child: Text('Todo al día. No tienes máquinas asignadas en este momento.', style: TextStyle(color: AppColors.textSecondary))),
                ],
              ),
            );
          }

          return SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.activas.length,
              itemBuilder: (context, index) {
                final reserva = state.activas[index];
                return GestureDetector(
                  onTap: () => context.push('/asignacion/${reserva.id}', extra: reserva),
                  child: Container(
                    width: 280,
                    margin: const EdgeInsets.only(right: 16, bottom: 10), // Bottom margin para la sombra
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.agriculture, color: Colors.white, size: 24),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                              child: const Text('ACTIVA', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                        const Spacer(),
                        Text(reserva.maquina.nombre, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text('Hasta el ${_formatDate(reserva.fechaFin)}', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  // --- 4. PANEL DE CONTROL (GRID) ---
  Widget _buildGridActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _ActionTile(icon: Icons.list_alt_rounded, title: 'Maquinaria', color: AppColors.primary, onTap: () => context.push('/maquinas'))),
              const SizedBox(width: 16),
              Expanded(child: _ActionTile(icon: Icons.warning_amber_rounded, title: 'Incidencias', color: AppColors.error, onTap: () => context.push('/registrar-incidencia'))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _ActionTile(icon: Icons.history_rounded, title: 'Historial', color: AppColors.info, onTap: () => context.push('/historial'))),
              const SizedBox(width: 16),
              Expanded(child: _ActionTile(icon: Icons.person_outline_rounded, title: 'Mi Perfil', color: AppColors.secondary, onTap: () => context.push('/perfil'))),
            ],
          ),
        ],
      ),
    );
  }

  // --- 5. BOTTOM NAVIGATION BAR MODERNA ---
  Widget _buildModernBottomNav() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: Colors.white,
      elevation: 10,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavBarIcon(icon: Icons.home_rounded, isSelected: _selectedNav == 0, onTap: () => setState(() => _selectedNav = 0)),
            _NavBarIcon(icon: Icons.agriculture_rounded, isSelected: _selectedNav == 1, onTap: () {
              context.push('/maquinas').then((_) => setState(() => _selectedNav = 0));
            }),
            const SizedBox(width: 48), // Hueco para el FloatingActionButton
            _NavBarIcon(icon: Icons.history, isSelected: _selectedNav == 2, onTap: () {
              context.push('/historial').then((_) => setState(() => _selectedNav = 0));
            }),
            _NavBarIcon(icon: Icons.person_rounded, isSelected: _selectedNav == 3, onTap: () {
              context.push('/perfil').then((_) => setState(() => _selectedNav = 0));
            }),
          ],
        ),
      ),
    );
  }
}

// Widgets Auxiliares privados
class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({required this.icon, required this.title, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}

class _NavBarIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarIcon({required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary.withOpacity(0.5), size: 28),
      onPressed: onTap,
    );
  }
}