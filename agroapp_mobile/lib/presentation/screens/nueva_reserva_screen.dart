import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:agroapp_mobile/presentation/blocs/asignacion/asignacion_bloc.dart';
import 'package:agroapp_mobile/presentation/blocs/maquina/maquina_bloc.dart';

class NuevaReservaScreen extends StatefulWidget {
  const NuevaReservaScreen({super.key});

  @override
  State<NuevaReservaScreen> createState() => _NuevaReservaScreenState();
}

class _NuevaReservaScreenState extends State<NuevaReservaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();

  int? _maquinaIdSeleccionada;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  @override
  void initState() {
    super.initState();
    context.read<MaquinaBloc>().add(MaquinaLoadAll());
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _selectFecha(bool isInicio) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E7D32),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isInicio) {
          _fechaInicio = picked;
        } else {
          _fechaFin = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        title: const Text(
          'Nueva Reserva',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocListener<AsignacionBloc, AsignacionState>(
        listener: (context, state) {
          if (state is AsignacionCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Reserva creada correctamente'),
                backgroundColor: Color(0xFF2E7D32),
              ),
            );
            context.pop();
          } else if (state is AsignacionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.mensaje}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Selección de máquina
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Selecciona Máquina *'),
                      const SizedBox(height: 8),
                      BlocBuilder<MaquinaBloc, MaquinaState>(
                        builder: (context, state) {
                          if (state is MaquinaLoading) {
                            return const CircularProgressIndicator(
                              color: Color(0xFF2E7D32),
                            );
                          } else if (state is MaquinaLoaded) {
                            return DropdownButtonFormField<int>(
                              initialValue: _maquinaIdSeleccionada,
                              decoration: _inputDecoration('Selecciona una máquina'),
                              items: state.maquinas.map((m) {
                                return DropdownMenuItem<int>(
                                  value: m.id,
                                  child: Text(m.nombre),
                                );
                              }).toList(),
                              onChanged: (val) =>
                                  setState(() => _maquinaIdSeleccionada = val),
                              validator: (v) =>
                                  v == null ? 'Selecciona una máquina' : null,
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Fechas
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Fecha Inicio *'),
                                const SizedBox(height: 8),
                                _buildDateButton(
                                  label: _fechaInicio != null
                                      ? _formatDate(_fechaInicio!)
                                      : 'Seleccionar',
                                  onTap: () => _selectFecha(true),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Fecha Fin *'),
                                const SizedBox(height: 8),
                                _buildDateButton(
                                  label: _fechaFin != null
                                      ? _formatDate(_fechaFin!)
                                      : 'Seleccionar',
                                  onTap: () => _selectFecha(false),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Descripción
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Notas adicionales (opcional)'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descripcionController,
                        maxLines: 3,
                        decoration: _inputDecoration(
                          'Añade cualquier detalle relevante...',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                BlocBuilder<AsignacionBloc, AsignacionState>(
                  builder: (context, state) {
                    final isLoading = state is AsignacionLoading;
                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D32),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    'CREAR ASIGNACIÓN',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () => context.pop(),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'CANCELAR',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_fechaInicio == null || _fechaFin == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecciona las fechas'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      if (_fechaFin!.isBefore(_fechaInicio!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La fecha fin debe ser posterior a la fecha inicio'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      context.read<AsignacionBloc>().add(
            AsignacionCreate(
              fechaInicio: _formatDate(_fechaInicio!),
              fechaFin: _formatDate(_fechaFin!),
              descripcion: _descripcionController.text.trim(),
              maquinaId: _maquinaIdSeleccionada!,
            ),
          );
    }
  }

  Widget _buildDateButton({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today,
                color: Color(0xFF2E7D32), size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: label == 'Seleccionar' ? Colors.grey : Colors.black87,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1B1B1B),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
      ),
    );
  }
}
