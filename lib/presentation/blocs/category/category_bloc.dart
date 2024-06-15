import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ballast_machn_test/domain/usecases/fetch_categories.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final FetchCategories fetchCategories;

  CategoryBloc({required this.fetchCategories}) : super(CategoryInitial()) {
    on<FetchCategoriesEvent>((event, emit) async {
      emit(CategoryLoading());
      try {
        final categories = await fetchCategories();
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });
  }
}
