part of 'incidencias_bloc.dart';



@immutable
sealed class IncidenciasState {}

final class IncidenciasInitial extends IncidenciasState {}

class IncidenciaInitial extends IncidenciasState {}

class IncidenciaLoading extends IncidenciasState {}

class IncidenciaCreated extends IncidenciasState {}

class IncidenciaError extends IncidenciasState {
  final String mensaje;
  IncidenciaError(this.mensaje);
}