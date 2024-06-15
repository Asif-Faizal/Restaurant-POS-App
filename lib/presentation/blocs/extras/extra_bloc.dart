import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/extras_repository.dart';
import 'extras_event.dart';
import 'extras_state.dart';

class ExtraBloc extends Bloc<ExtraEvent, ExtraState> {
  final ExtraRepository extraRepository;

  ExtraBloc({required this.extraRepository}) : super(ExtraLoading()) {
    on<FetchExtrasEvent>(_onFetchExtras);
  }

  Future<void> _onFetchExtras(
      FetchExtrasEvent event, Emitter<ExtraState> emit) async {
    emit(ExtraLoading());
    try {
      final extras = await extraRepository.fetchExtras(event.foodId);
      emit(ExtraLoaded(extras));
    } catch (e) {
      emit(ExtraError('Failed to load extras'));
    }
  }
}
