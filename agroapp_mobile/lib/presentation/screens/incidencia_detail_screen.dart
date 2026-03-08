import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:agroapp_mobile/data/models/incidencia_model.dart';

class IncidenciaDetailScreen extends StatelessWidget {
  final Incidencia incidencia;

  const IncidenciaDetailScreen({super.key, required this.incidencia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        title: Text(
          incidencia.titulo,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _statusCard(),
            const SizedBox(height: 12),
            _infoCard(),
            if (incidencia.latitud != null && incidencia.longitud != null) ...[
              const SizedBox(height: 12),
              _mapCard(),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _statusCard() {
    final prioColor = _prioColor(incidencia.prioridad);
    final estadoAbierta = incidencia.estadoIncidencia == 'ABIERTA' ||
        incidencia.estadoIncidencia == 'EN_PROGRESO';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: prioColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child:
                Icon(Icons.warning_amber_rounded, color: prioColor, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  incidencia.titulo,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (incidencia.fechaApertura != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Abierta: ${incidencia.fechaApertura}',
                    style:
                        const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _badge(incidencia.prioridad, prioColor),
              const SizedBox(height: 6),
              _badge(
                _estadoLabel(incidencia.estadoIncidencia),
                estadoAbierta
                    ? const Color(0xFFD32F2F)
                    : const Color(0xFF388E3C),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detalles',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (incidencia.maquinaNombre != null)
            _infoRow(
                Icons.agriculture, 'Máquina', incidencia.maquinaNombre!),
          if (incidencia.descripcion != null &&
              incidencia.descripcion!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.notes_outlined,
                    size: 18, color: Color(0xFF2E7D32)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    incidencia.descripcion!,
                    style: const TextStyle(
                        fontSize: 13, color: Color(0xFF424242)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _mapCard() {
    final lat = incidencia.latitud!;
    final lng = incidencia.longitud!;
    final center = LatLng(lat, lng);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Color(0xFF2E7D32), size: 20),
                SizedBox(width: 8),
                Text(
                  'Ubicación del incidente',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(14),
              bottomRight: Radius.circular(14),
            ),
            child: SizedBox(
              height: 280,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: center,
                  initialZoom: 14,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName:
                        'com.salesianostriana.dam.agroapp',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: center,
                        width: 48,
                        height: 48,
                        child: const Icon(
                          Icons.location_pin,
                          color: Color(0xFFD32F2F),
                          size: 44,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF2E7D32)),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF424242)),
          ),
          Expanded(
            child: Text(
              value,
              style:
                  const TextStyle(fontSize: 13, color: Color(0xFF616161)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Color _prioColor(String prioridad) {
    switch (prioridad) {
      case 'ALTA':
        return const Color(0xFFD32F2F);
      case 'MEDIA':
        return const Color(0xFFE65100);
      default:
        return const Color(0xFF2E7D32);
    }
  }

  String _estadoLabel(String estado) {
    switch (estado) {
      case 'ABIERTA':
        return 'Abierta';
      case 'EN_PROGRESO':
        return 'En progreso';
      case 'RESUELTA':
        return 'Resuelta';
      default:
        return estado;
    }
  }
}
