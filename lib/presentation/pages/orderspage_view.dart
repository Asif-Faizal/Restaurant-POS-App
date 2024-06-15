import 'package:ballast_machn_test/presentation/pages/catogory_screen.dart';
import 'package:ballast_machn_test/presentation/pages/order_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import '../../data/repositories/order_repository.dart';
import '../blocs/order/order_bloc.dart';
import '../blocs/order/order_event.dart';
import '../blocs/order/order_state.dart';
import '../widgets/orderlist_button.dart';

class OrdersPageView extends StatelessWidget {
  final String baseUrl;
  const OrdersPageView({super.key, required this.baseUrl});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderBloc(
          OrderRepositoryImpl(httpClient: http.Client(), baseUrl: baseUrl)),
      child: const OrdersPageViewBody(),
    );
  }
}

class OrdersPageViewBody extends StatefulWidget {
  const OrdersPageViewBody({super.key});

  @override
  _OrdersPageViewState createState() => _OrdersPageViewState();
}

class _OrdersPageViewState extends State<OrdersPageViewBody> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<OrderBloc>(context).add(LoadOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderInitial || state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderLoaded) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return FutureBuilder<List<String>>(
                  future: fetchImageUrls(order.tableId.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Icon(Icons.error);
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Icon(Icons.image_not_supported);
                    } else {
                      List<String> imageUrls = snapshot.data!;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderDetails(
                                        table: order.tableId.toString(),
                                        customerName: order.customerName,
                                        customerNumber: order.customerNumber,
                                      )));
                        },
                        child: Card(
                          color: const Color.fromARGB(255, 255, 242, 202),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 110,
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 80,
                                        width: 80,
                                        child: CarouselSlider(
                                          items: imageUrls.map((url) {
                                            return Center(
                                              child: Image.network(
                                                url,
                                                fit: BoxFit.cover,
                                                height: 80,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return const Icon(
                                                      Icons.image);
                                                },
                                              ),
                                            );
                                          }).toList(),
                                          options: CarouselOptions(
                                            enlargeCenterPage: true,
                                            autoPlayInterval: const Duration(
                                                milliseconds: 1000),
                                            autoPlay: true,
                                            aspectRatio: 1.0,
                                            onPageChanged: (index, reason) {},
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Table ${order.tableId}',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            order.customerName,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            '₹ ${order.totalAmount}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            DateFormat.Hm()
                                                .format(order.orderTime),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 15, left: 15, right: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    OrdersListButton(
                                      title: 'Delivered',
                                      icon: Icons.done_all_rounded,
                                      onTap: () async {
                                        await markOrderAsDelivered(
                                            order.orderId);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          elevation: 5,
                                          duration: const Duration(seconds: 10),
                                          showCloseIcon: true,
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.green,
                                          content: Text(
                                              'Completed Delivery on Table ${order.tableId} for Mr/Mrs ${order.customerName}'),
                                          action: SnackBarAction(
                                            label: 'UNDO',
                                            onPressed: () async {
                                              await unMarkOrderAsDelivered(
                                                  order.orderId);
                                            },
                                            textColor: Colors.white,
                                          ),
                                        ));
                                      },
                                    ),
                                    OrdersListButton(
                                      title: 'Edit',
                                      icon: Icons.edit_note_rounded,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CategoryPage(
                                                        table: order.tableId
                                                            .toString())));
                                      },
                                    ),
                                    OrdersListButton(
                                      title: 'Delete',
                                      icon: Icons.delete_forever_rounded,
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              title: const Text(
                                                  'Confirm Deletion'),
                                              content: const Text(
                                                  'Are you sure you want to delete this item?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await deleteOrder(
                                                        order.orderId);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          } else if (state is OrderError) {
            return const Center(child: Text('Failed to load orders'));
          } else {
            return const Center(child: Text('Unknown error'));
          }
        },
      ),
    );
  }

  Future<List<String>> fetchImageUrls(String tableId) async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/images/$tableId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((url) => url.toString()).toList();
    } else {
      throw Exception('Failed to load image URLs');
    }
  }

  Future<void> markOrderAsDelivered(int orderId) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:3000/mark-delivered/$orderId'),
    );

    if (response.statusCode == 200) {
      BlocProvider.of<OrderBloc>(context).add(LoadOrders());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to mark order as delivered'),
      ));
    }
  }

  Future<void> unMarkOrderAsDelivered(int orderId) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:3000/unmark-delivered/$orderId'),
    );

    if (response.statusCode == 200) {
      BlocProvider.of<OrderBloc>(context).add(LoadOrders());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to mark order as delivered'),
      ));
    }
  }

  Future<void> deleteOrder(int orderId) async {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:3000/delete-order/$orderId'),
    );

    if (response.statusCode == 200) {
      BlocProvider.of<OrderBloc>(context).add(LoadOrders());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to delete order'),
      ));
    }
  }
}
