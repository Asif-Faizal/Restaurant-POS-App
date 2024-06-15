import 'package:bloc/bloc.dart';

import '../../../data/models/order_model.dart';
import '../../../data/repositories/order_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;

  OrderBloc(this._orderRepository) : super(OrderInitial()) {
    on<LoadOrders>(_mapLoadOrdersToState);
  }

  void _mapLoadOrdersToState(LoadOrders event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final List<Order> orders = await _orderRepository.fetchOrders();
      emit(OrderLoaded(orders));
    } catch (e) {
      emit(OrderError());
    }
  }
}
