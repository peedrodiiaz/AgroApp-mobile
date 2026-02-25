import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:agroapp_mobile/presentation/blocs/incidencias/incidencias_bloc.dart';
import 'package:agroapp_mobile/presentation/blocs/maquina/maquina_bloc.dart';

class RegistrarIncidenciaScreen extends StatefulWidget {
  const RegistrarIncidenciaScreen({super.key});

  @override
  State<RegistrarIncidenciaScreen> createState() =>
      _RegistrarIncidenciaScreenState();
}

class _RegistrarIncidenciaScreenState
    extends State<RegistrarIncidenciaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();

  String _prioridad = 'MEDIA';
  final String _estadoIncidencia = 'ABIERTA';
  int? _maquinaIdSeleccionada;

  @override
  void initState() {
    super.initState();
    context.read<MaquinaBloc>().add(MaquinaLoadAll());
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        title: const Text(
          'Reportar Incidencia',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocListener<IncidenciasBloc, IncidenciasState>(
        listener: (context, state) {
          if (state is IncidenciaCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Incidencia creada correctamente'),
                backgroundColor: Color(0xFF2E7D32),
              ),
            );
            context.pop();
          } else if (state is IncidenciaError) {
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
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Título de la incidencia *'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _tituloController,
                        hint: 'Ej: Fallo en el motor',
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Campo obligatorio' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Descripción *'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _descripcionController,
                        hint: 'Describe el problema con detalle...',
                        maxLines: 4,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Campo obligatorio' : null,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Máquina afectada *'),
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

                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Prioridad'),
                      const SizedBox(height: 8),
                      Row(
                        children: ['BAJA', 'MEDIA', 'ALTA'].map((p) {
                          final isSelected = _prioridad == p;
                          Color color = p == 'ALTA'
                              ? Colors.red
                              : p == 'MEDIA'
                                  ? Colors.orange
                                  : Colors.green;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _prioridad = p),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? color
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected ? color : Colors.grey[300]!,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Text(
                                  p,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isSelected ? color : Colors.grey,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                BlocBuilder<IncidenciasBloc, IncidenciasState>(
                  builder: (context, state) {
                    final isLoading = state is IncidenciaLoading;
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
                                    'ENVIAR REPORTE',
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
      context.read<IncidenciasBloc>().add(
            IncidenciaCreate(
              titulo: _tituloController.text.trim(),
              descripcion: _descripcionController.text.trim(),
              estadoIncidencia: _estadoIncidencia,
              maquinaId: _maquinaIdSeleccionada!,
              trabajadorId: 0, // lo saca el backend del token
              prioridad: _prioridad,
            ),
          );
    }
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: _inputDecoration(hint),
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
