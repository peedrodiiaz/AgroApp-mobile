import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agroapp_mobile/data/models/trabajador_response.dart';
import 'package:agroapp_mobile/presentation/blocs/auth/auth_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user =
            state is AuthAuthenticated ? state.authResponse.user : null;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: CustomScrollView(
            slivers: [
              _buildAppBar(context, user),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (user != null) ...[
                        _sectionCard(
                          title: 'Información personal',
                          children: [
                            _infoRow(Icons.badge_outlined, 'Nombre completo',
                                user.nombreCompleto),
                            _infoRow(Icons.credit_card_outlined, 'DNI',
                                user.dni),
                            _infoRow(
                                Icons.email_outlined, 'Email', user.email),
                            _infoRow(Icons.phone_outlined, 'Teléfono',
                                user.telefono),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _sectionCard(
                          title: 'Cuenta',
                          children: [
                            _infoRow(
                              Icons.work_outline_rounded,
                              'Rol',
                              _labelRol(user.rol),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                      _logoutButton(context),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, Trabajador? user) {
    final initials = user != null
        ? '${user.nombre.isNotEmpty ? user.nombre[0] : ''}${user.apellido.isNotEmpty ? user.apellido[0] : ''}'
            .toUpperCase()
        : '?';

    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: const Color(0xFF2E7D32),
      iconTheme: const IconThemeData(color: Colors.white),
      automaticallyImplyLeading: true,
      title: const Text('Mi Perfil', style: TextStyle(color: Colors.white)),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1B5E20), Color.fromARGB(255, 74, 192, 78)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              // Avatar con iniciales
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (user != null) ...[
                Text(
                  user.nombreCompleto,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _labelRol(user.rol),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard(
      {required String title, required List<Widget> children}) {
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
            offset: const Offset(0, 2),
          ),
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
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF2E7D32), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11, color: Colors.grey)),
                Text(
                  value.isNotEmpty ? value : '-',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () =>
            context.read<AuthBloc>().add(LogoutRequested()),
        icon: const Icon(Icons.logout_rounded, color: Color(0xFFD32F2F)),
        label: const Text(
          'Cerrar sesión',
          style: TextStyle(
            color: Color(0xFFD32F2F),
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: Color(0xFFD32F2F)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  String _labelRol(String rol) {
    switch (rol) {
      case 'ADMIN':
        return 'Administrador';
      case 'TRABAJADOR':
        return 'Trabajador';
      default:
        return rol;
    }
  }
}
