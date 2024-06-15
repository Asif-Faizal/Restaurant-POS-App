import 'package:ballast_machn_test/presentation/widgets/order_details_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/providers/menu_api_providers.dart';
import '../../data/repositories/menu_repository.dart';
import '../../domain/usecases/fetch_menu_items.dart';
import '../../domain/usecases/delete_menu_item.dart';
import '../blocs/fetch-menu/menu_bloc.dart';
import '../blocs/fetch-menu/menu_event.dart';
import '../blocs/fetch-menu/menu_state.dart';

class OrderDetails extends StatelessWidget {
  final String table;
  final String customerName;
  final String customerNumber;

  const OrderDetails(
      {super.key,
      required this.table,
      required this.customerName,
      required this.customerNumber});

  @override
  Widget build(BuildContext context) {
    final tableId = int.parse(table);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 228, 147),
        title: Text(
          'Table $table',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocProvider(
        create: (context) {
          final apiProvider = MenuApiProvider(baseUrl: 'http://10.0.2.2:3000');
          final repository = MenuRepository(apiProvider: apiProvider);
          return MenuBloc(
            fetchMenuItems: FetchMenuItems(repository: repository),
            deleteMenuItem: DeleteMenuItem(repository: repository),
          )..add(FetchMenuItemsEvent(tableId));
        },
        child: BlocBuilder<MenuBloc, MenuState>(
          builder: (context, state) {
            if (state is MenuLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MenuLoaded) {
              final menuItems = state.menuItems;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        final item = menuItems[index];
                        return OrderDetailsCard(item: item);
                      },
                    ),
                  ),
                ],
              );
            } else if (state is MenuError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('No menu found'));
            }
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 255, 228, 147),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              customerName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              customerNumber,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
