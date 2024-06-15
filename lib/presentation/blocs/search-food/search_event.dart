import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object> get props => [];
}

class SearchFoodEvent extends SearchEvent {
  final String foodName;

  const SearchFoodEvent(this.foodName);

  @override
  List<Object> get props => [foodName];
}
