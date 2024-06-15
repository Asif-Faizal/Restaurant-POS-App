import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddToCartEvent extends CartEvent {
  final Map<String, dynamic> cartItem;

  AddToCartEvent(this.cartItem);

  @override
  List<Object?> get props => [cartItem];
}
