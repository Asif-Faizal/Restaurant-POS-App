abstract class OrderEvent {}

class LoadOrders extends OrderEvent {}

class DeleteOrder extends OrderEvent {}

class LoadOrderImages extends OrderEvent {
  final int orderId;

  LoadOrderImages(this.orderId);
}
