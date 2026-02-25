import 'package:agroapp_mobile/data/repositories/incidencia_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'incidencias_event.dart';
part 'incidencias_state.dart';

class IncidenciasBloc extends Bloc<IncidenciasEvent, IncidenciasState> {
  final IncidenciaRepository incidenciaRepository;

  IncidenciasBloc({required this.incidenciaRepository}) : super(IncidenciasInitial()) {
    on<IncidenciaCreate>(_onCreate);
  }

  Future<void> _onCreate(
    IncidenciaCreate event,
    Emitter<IncidenciasState> emit,
  ) async {
    emit(IncidenciaLoading());
    try {
      await incidenciaRepository.createIncidencia(
        titulo: event.titulo,
        descripcion: event.descripcion,
        estadoIncidencia: event.estadoIncidencia,
        maquinaId: event.maquinaId,
        trabajadorId: event.trabajadorId,
        prioridad: event.prioridad,
      );
      emit(IncidenciaCreated());
    } catch (e) {
      emit(IncidenciaError(e.toString()));
    }
  }
}
