import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/fetch_food.dart';
import 'food_event.dart';
import 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final FetchFoodUseCase fetchFoodUseCase;

  FoodBloc(this.fetchFoodUseCase) : super(FoodInitial()) {
    on<FetchFood>((event, emit) async {
      emit(FoodLoading());
      try {
        final foods = await fetchFoodUseCase.execute(event.category);
        emit(FoodLoaded(foods));
      } catch (e) {
        emit(FoodError(e.toString()));
      }
    });
  }
}
