part of 'asignacion_bloc.dart';

abstract class AsignacionState {}

class AsignacionInitial extends AsignacionState {}

class AsignacionLoading extends AsignacionState {}

class AsignacionLoaded extends AsignacionState {
  final List<Asignacion> todas;
  final List<Asignacion> activas;
  final List<Asignacion> proximas;
  final List<Asignacion> vencidas;

  AsignacionLoaded({
    required this.todas,
    required this.activas,
    required this.proximas,
    required this.vencidas,
  });
}

class AsignacionCreated extends AsignacionState {}

class AsignacionError extends AsignacionState {
  final String mensaje;
  AsignacionError(this.mensaje);
}