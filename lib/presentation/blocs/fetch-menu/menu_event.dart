abstract class MenuEvent {}

class FetchMenuItemsEvent extends MenuEvent {
  final int tableId;

  FetchMenuItemsEvent(this.tableId);
}

class DeleteMenuItemEvent extends MenuEvent {
  final int tableId;
  final int foodId;
  final String extrasName;

  DeleteMenuItemEvent(this.tableId, this.foodId, this.extrasName);
}

class RefreshMenuEvent extends MenuEvent {
  final int tableId;

  RefreshMenuEvent(this.tableId);
}
