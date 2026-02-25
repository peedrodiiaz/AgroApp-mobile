part of 'asignacion_bloc.dart';

@immutable
sealed class AsignacionEvent {}

class AsignacionLoadByTrabajador extends AsignacionEvent {}
class AsignacionCreate extends AsignacionEvent {
  final String fechaInicio;
  final String fechaFin;
  final String descripcion;
  final int maquinaId;

  AsignacionCreate({
    required this.fechaInicio,
    required this.fechaFin,
    required this.descripcion,
    required this.maquinaId,
  });
}