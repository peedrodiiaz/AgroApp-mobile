part of 'incidencias_bloc.dart';

@immutable
sealed class IncidenciasEvent {}

class IncidenciaCreate extends IncidenciasEvent {
  final String titulo;
  final String descripcion;
  final String estadoIncidencia;
  final int maquinaId;
  final int trabajadorId;
  final String prioridad;

  IncidenciaCreate({
    required this.titulo,
    required this.descripcion,
    required this.estadoIncidencia,
    required this.maquinaId,
    required this.trabajadorId,
    required this.prioridad,
  });
}