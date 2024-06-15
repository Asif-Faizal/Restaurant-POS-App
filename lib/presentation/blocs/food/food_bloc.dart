import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/fetch_foods_from_category.dart';
import 'food_event.dart';
import 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final FetchFoodsByCategory fetchFoodsByCategory;

  FoodBloc({required this.fetchFoodsByCategory}) : super(FoodInitial()) {
    on<FetchFoodsEvent>((event, emit) async {
      emit(FoodLoading());
      try {
        final foods = await fetchFoodsByCategory(event.categoryId);
        emit(FoodLoaded(foods));
      } catch (e) {
        emit(FoodError(e.toString()));
      }
    });
  }
}
