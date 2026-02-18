part of 'maquina_bloc.dart';

@immutable
sealed class MaquinaEvent {}

class MaquinaLoadAll extends MaquinaEvent {}

class MaquinaLoadById extends MaquinaEvent {
  final int id;
  MaquinaLoadById(this.id);
}