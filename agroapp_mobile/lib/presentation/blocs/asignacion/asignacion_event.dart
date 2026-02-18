part of 'asignacion_bloc.dart';

@immutable
sealed class AsignacionEvent {}

class AsignacionLoadByTrabajador extends AsignacionEvent {}