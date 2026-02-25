import 'package:agroapp_mobile/data/models/asignacion_model.dart';
import 'package:agroapp_mobile/data/repositories/asignacion_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'asignacion_event.dart';
part 'asignacion_state.dart';

class AsignacionBloc extends Bloc<AsignacionEvent, AsignacionState> {
  final AsignacionRepository asignacionRepository;

  AsignacionBloc({required this.asignacionRepository})
    : super(AsignacionInitial()) {
    on<AsignacionLoadByTrabajador>(_onLoadByTrabajador);
    on<AsignacionCreate>(_onCreate);
  }

  Future<void> _onLoadByTrabajador(
    AsignacionLoadByTrabajador event,
    Emitter<AsignacionState> emit,
  ) async {
    emit(AsignacionLoading());
    try {
      final asignaciones = await asignacionRepository.getMisAsignaciones();
      emit(AsignacionLoaded(asignaciones));
    } catch (e) {
      emit(AsignacionError(e.toString()));
    }
  }

  Future<void> _onCreate(
    AsignacionCreate event,
    Emitter<AsignacionState> emit,
  ) async {
    emit(AsignacionLoading());
    try {
      await asignacionRepository.createAsignacion(
        fechaInicio: event.fechaInicio,
        fechaFin: event.fechaFin,
        descripcion: event.descripcion,
        maquinaId: event.maquinaId,
      );
      emit(AsignacionCreated());
    } catch (e) {
      emit(AsignacionError(e.toString()));
    }
  }
}
