import 'package:ballast_machn_test/presentation/widgets/Custom_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../data/models/order_details_model.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late Future<List<Order>> futureOrders;
  String? orderNumber;
  String? tableName;

  @override
  void initState() {
    super.initState();
    futureOrders = fetchOrders();
  }

  Future<List<Order>> fetchOrders() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:3000/api/order-details/ORDJ'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<Order> orders =
          jsonData.map((json) => Order.fromJson(json)).toList();
      if (orders.isNotEmpty) {
        setState(() {
          orderNumber = orders.first.orderNumber;
          tableName = orders.first.tableName;
        });
      }

      return orders;
    } else {
      throw Exception('Failed to load orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/bb.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text('${orderNumber ?? ''}  - ${tableName ?? ''}'),
          ),
          body: FutureBuilder<List<Order>>(
            future: futureOrders,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No orders found'));
              } else {
                return ListView(
                  children: snapshot.data!.map((order) {
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text('${order.itemName} (x${order.qty})'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Total: ₹${order.totalSalePrice.toStringAsFixed(2)}'),
                            Text('GST: ₹${order.gstAmount.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MyButton(
                  onPressed: () {},
                  text: 'Print KOT',
                ),
                MyButton(
                  onPressed: () {},
                  text: 'Take Order',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
