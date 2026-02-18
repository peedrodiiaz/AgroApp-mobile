part of 'asignacion_bloc.dart';

@immutable
sealed class AsignacionState {}

final class AsignacionInitial extends AsignacionState {}

class AsignacionLoading extends AsignacionState {}

class AsignacionLoaded extends AsignacionState {
  final List<Asignacion> asignaciones;
  AsignacionLoaded(this.asignaciones);
}

class AsignacionError extends AsignacionState {
  final String mensaje;
  AsignacionError(this.mensaje);
}
