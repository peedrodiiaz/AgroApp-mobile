part of 'asignacion_bloc.dart';

abstract class AsignacionState {}

class AsignacionInitial extends AsignacionState {}

class AsignacionLoading extends AsignacionState {}

class AsignacionLoaded extends AsignacionState {
  final List<Asignacion> asignaciones;
  AsignacionLoaded(this.asignaciones);
}

class AsignacionCreated extends AsignacionState {}

class AsignacionError extends AsignacionState {
  final String mensaje;
  AsignacionError(this.mensaje);
}
