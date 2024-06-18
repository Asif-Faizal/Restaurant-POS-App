import 'package:equatable/equatable.dart';

abstract class FoodEvent extends Equatable {
  const FoodEvent();
}

class FetchFood extends FoodEvent {
  final String category;

  const FetchFood(this.category);

  @override
  List<Object> get props => [category];
}
