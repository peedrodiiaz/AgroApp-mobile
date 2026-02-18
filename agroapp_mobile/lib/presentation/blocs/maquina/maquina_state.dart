part of 'maquina_bloc.dart';

@immutable
sealed class MaquinaState {}

final class MaquinaInitial extends MaquinaState {}

class MaquinaLoading extends MaquinaState {}

class MaquinaLoaded extends MaquinaState {
  final List<Maquina> maquinas;
  MaquinaLoaded(this.maquinas);
}

class MaquinaDetailLoaded extends MaquinaState {
  final Maquina maquina;
  MaquinaDetailLoaded(this.maquina);
}

class MaquinaError extends MaquinaState {
  final String mensaje;
  MaquinaError(this.mensaje);
}