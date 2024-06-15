import 'package:equatable/equatable.dart';

abstract class FoodEvent extends Equatable {
  const FoodEvent();

  @override
  List<Object> get props => [];
}

class FetchFoodsEvent extends FoodEvent {
  final int categoryId;

  const FetchFoodsEvent(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}
