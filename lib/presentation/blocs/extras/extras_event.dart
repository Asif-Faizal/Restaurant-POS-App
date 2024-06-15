import 'package:equatable/equatable.dart';

abstract class ExtraEvent extends Equatable {
  const ExtraEvent();

  @override
  List<Object> get props => [];
}

class FetchExtrasEvent extends ExtraEvent {
  final int foodId;

  const FetchExtrasEvent(this.foodId);

  @override
  List<Object> get props => [foodId];
}
