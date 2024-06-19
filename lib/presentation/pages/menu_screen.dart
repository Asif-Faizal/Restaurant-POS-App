import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ballast_machn_test/presentation/widgets/Custom_button.dart';
import '../../data/models/order_details_model.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late Future<List<Order>> futureOrders;
  String? orderNumber;
  String? tableName;
  String? KOTno;
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    futureOrders = fetchOrders();
  }

  Future<List<Order>> fetchOrders() async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3000/api/order-details/ORD1'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        List<Order> orders =
            jsonData.map((json) => Order.fromJson(json)).toList();
        if (orders.isNotEmpty) {
          setState(() {
            orderNumber = orders.first.orderNumber;
            tableName = orders.first.tableName;
            KOTno = orders.first.kotNo;
            totalAmount = calculateTotalAmount(orders);
          });
        }
        return orders;
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      print('Error fetching orders: $e');
      throw Exception('Failed to connect to the server');
    }
  }

  double calculateTotalAmount(List<Order> orders) {
    double total = 0.0;
    for (var order in orders) {
      total += order.totalSalePrice;
    }
    return total;
  }

  Future<void> printKOT() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/print-kot'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'KOTNo': KOTno,
        }),
      );

      if (response.statusCode == 200) {
        print('KOT printed successfully');
        // Optionally, show a confirmation to the user
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            content: Text('Failed to Print')));
      } else {
        throw Exception('');
      }
    } catch (e) {
      print('Error printing KOT: $e');
      // Optionally, show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          content: Text('KOT printed successfully')));
    }
  }

  void deleteOrder(Order order) {
    setState(() {
      futureOrders = Future.value(
        (futureOrders as Future<List<Order>>).then((orders) {
          orders.remove(order);
          totalAmount = calculateTotalAmount(orders);
          return orders;
        }),
      );
    });
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
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteOrder(order);
                          },
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
          bottomNavigationBar: BottomAppBar(
            height: 125,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                    'Total: ₹${totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MyButton(
                      onPressed: () {
                        printKOT();
                      },
                      text: 'Print KOT',
                    ),
                    MyButton(
                      onPressed: () {},
                      text: 'Take Order',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
