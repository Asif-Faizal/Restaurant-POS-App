abstract class MenuState {}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final List<dynamic> menuItems;

  MenuLoaded(this.menuItems);
}

class MenuError extends MenuState {
  final String message;

  MenuError(this.message);
}

class MenuItemDeleted extends MenuState {}
