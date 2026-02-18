import 'package:agroapp_mobile/data/models/maquina_model.dart';
import 'package:agroapp_mobile/data/repositories/maquina_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'maquina_event.dart';
part 'maquina_state.dart';

class MaquinaBloc extends Bloc<MaquinaEvent, MaquinaState> {
  final MaquinaRepository maquinaRepository;

  MaquinaBloc({required this.maquinaRepository}) : super(MaquinaInitial()) {
    on<MaquinaLoadAll>(_onLoadAll);
    on<MaquinaLoadById>(_onLoadById);
  }

  Future<void> _onLoadAll(
    MaquinaLoadAll event,
    Emitter<MaquinaState> emit,
  ) async {
    emit(MaquinaLoading());
    try {
      final maquinas = await maquinaRepository.getMaquinas();
      emit(MaquinaLoaded(maquinas));
    } catch (e) {
      emit(MaquinaError(e.toString()));
    }
  }

  Future<void> _onLoadById(
    MaquinaLoadById event,
    Emitter<MaquinaState> emit,
  ) async {
    emit(MaquinaLoading());
    try {
      final maquina = await maquinaRepository.getMaquinaById(event.id);
      emit(MaquinaDetailLoaded(maquina));
    } catch (e) {
      emit(MaquinaError(e.toString()));
    }
  }
}
