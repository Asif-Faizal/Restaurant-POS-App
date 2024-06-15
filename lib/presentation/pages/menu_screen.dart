import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/providers/menu_api_providers.dart';
import '../../data/repositories/menu_repository.dart';
import '../../domain/usecases/fetch_menu_items.dart';
import '../../domain/usecases/delete_menu_item.dart';
import '../blocs/fetch-menu/menu_bloc.dart';
import '../blocs/fetch-menu/menu_event.dart';
import '../blocs/fetch-menu/menu_state.dart';
import '../widgets/menu_card.dart';
import 'home_page.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class MenuPage extends StatelessWidget {
  final String table;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  double total = 0;

  MenuPage({super.key, required this.table});

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
              total = 0;
              for (var item in menuItems) {
                print('Item: $item'); // Debug: Print each item
                total += item['sub_total'];
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        final item = menuItems[index];
                        return MenuCard(item: item);
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 20, left: 20, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹${total.toInt()}',
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ],
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
        height: 100,
        elevation: 0,
        color: Colors.transparent,
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 10,
                backgroundColor: const Color.fromARGB(255, 255, 228, 147),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: const Text('Customer Details'),
                      content: SizedBox(
                        height: 170,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Customer Name'),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              maxLength: 10,
                              controller: _numberController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Customer Number'),
                              textAlign: TextAlign.center,
                            ),
                            const Divider()
                          ],
                        ),
                      ),
                      actionsAlignment: MainAxisAlignment.center,
                      actions: [
                        Column(
                          children: [
                            TextButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          side: const BorderSide(
                                              width: 1, color: Colors.brown)))),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text('Review',
                                        style: TextStyle(fontSize: 20)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 228, 147),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              onPressed: () async {
                                await placeOrder(context, tableId, total);
                                //order
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MyHomePage()));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                      'Placed Order for ${_nameController.text} in $table'),
                                  action: SnackBarAction(
                                    label: 'undo',
                                    onPressed: () {},
                                    textColor: Colors.white,
                                  ),
                                ));
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Text(
                                      'Place Order',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Take order',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    Icon(Icons.dining_rounded)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> placeOrder(
      BuildContext context, int tableId, double total) async {
    final orderData = {
      'table_id': tableId,
      'customer_name': _nameController.text,
      'customer_number': _numberController.text,
      'total_amount': total,
      'is_delivered': false,
    };

    print('Placing order with data: $orderData'); // Debug: Print order data

    final url = Uri.parse('http://10.0.2.2:3000/place-order');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(orderData),
    );

    if (response.statusCode == 200) {
      print('Order placed successfully');
    } else {
      print('Failed to place order: ${response.body}');
    }
  }
}
