import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../data/repositories/order_repository.dart';
import '../blocs/order/order_bloc.dart';
import '../blocs/order/order_event.dart';
import '../blocs/order/order_state.dart';
import '../widgets/completedorder_view_card.dart';

class CompletedpageView extends StatelessWidget {
  final String baseUrl;
  const CompletedpageView({super.key, required this.baseUrl});

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
                      return CompletedOrderViewCard(
                          order: order, imageUrls: imageUrls);
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
}
