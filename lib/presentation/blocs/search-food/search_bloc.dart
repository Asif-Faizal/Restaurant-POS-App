import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/food_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final FoodRepository foodRepository;

  SearchBloc({required this.foodRepository}) : super(SearchInitial());

  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchFoodEvent) {
      yield SearchLoading();
      try {
        final food = await foodRepository.fetchFoodsByName(event.foodName);
        yield SearchLoaded(food);
      } catch (e) {
        yield SearchError(e.toString());
      }
    }
  }
}
