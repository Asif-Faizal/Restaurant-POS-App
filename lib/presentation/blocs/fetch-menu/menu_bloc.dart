import 'package:bloc/bloc.dart';
import 'dart:async';
import '../../../domain/usecases/fetch_menu_items.dart';
import '../../../domain/usecases/delete_menu_item.dart';
import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final FetchMenuItems fetchMenuItems;
  final DeleteMenuItem deleteMenuItem;

  MenuBloc({required this.fetchMenuItems, required this.deleteMenuItem})
      : super(MenuInitial()) {
    on<FetchMenuItemsEvent>((event, emit) async {
      emit(MenuLoading());
      try {
        final menuItems = await fetchMenuItems(event.tableId);
        emit(MenuLoaded(menuItems));
      } catch (e) {
        emit(MenuError(e.toString()));
      }
    });

    on<DeleteMenuItemEvent>((event, emit) async {
      emit(MenuLoading());
      try {
        await deleteMenuItem(event.tableId, event.foodId, event.extrasName);
        await Future.delayed(const Duration(seconds: 5));
        add(FetchMenuItemsEvent(event.tableId));
      } catch (e) {
        emit(MenuError(e.toString()));
      }
    });

    on<RefreshMenuEvent>((event, emit) async {
      emit(MenuLoading());
      try {
        await Future.delayed(const Duration(seconds: 5));
        final menuItems = await fetchMenuItems(event.tableId);
        emit(MenuLoaded(menuItems));
      } catch (e) {
        emit(MenuError(e.toString()));
      }
    });
  }
}
