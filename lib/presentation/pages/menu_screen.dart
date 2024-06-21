import 'package:ballast_machn_test/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../data/models/order_details_model.dart';

class MenuPage extends StatefulWidget {
  final String customerNumber;
  final int table;
  const MenuPage({Key? key, required this.customerNumber, required this.table})
      : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    bool canPlaceOrder = calculateTotalAmount() > 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(orderNumber.isEmpty ? 'Loading...' : 'Order: $orderNumber'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  color: Colors.blue.shade100,
                  child: ListTile(
                    title: Text(order.itemName),
                    subtitle: Text(
                        'Qty: ${order.quantity}, Tax: \$${order.gstAmount}, Total: \$${order.totalSalePrice.toStringAsFixed(2)}'),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        height: 150,
        child: Column(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${calculateTotalAmount().toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: canPlaceOrder
                          ? () {
                              if (orders.isNotEmpty) {
                                printKOT(orders.first.KOTNo);
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        minimumSize: const Size.fromHeight(60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text('Print KOT'),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: canPlaceOrder
                          ? () {
                              placeOrder();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        minimumSize: const Size.fromHeight(60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text('Place Order'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String orderNumber = '';
  List<Order> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrderNumber();
  }

  Future<void> fetchOrderNumber() async {
    final response = await http.get(
      Uri.parse(
          'http://10.0.2.2:3000/api/order-number?CustomerName=${widget.customerNumber}&TableName=${widget.table}'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        orderNumber = data['orderNumber'];
      });
      fetchOrderDetails();
    } else {
      setState(() {
        orderNumber = '';
        isLoading = false;
      });
    }
  }

  Future<void> fetchOrderDetails() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/api/order-details/$orderNumber'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        orders = data.map((json) => Order.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  double calculateTotalAmount() {
    double totalAmount = 0;
    for (var order in orders) {
      totalAmount += order.totalSalePrice;
    }
    return totalAmount;
  }

  double calculateTaxableAmount() {
    double totalAmount = calculateTotalAmount();
    return totalAmount + totalAmount * 0.05;
  }

  Future<void> printKOT(String kotNo) async {
    final url = Uri.parse('http://10.0.2.2:3000/print-kot');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'KOTNo': kotNo,
      }),
    );

    if (response.statusCode == 201) {
      print('KOT printed successfully');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Printed KOT as $kotNo'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ));
    } else {
      print('Failed to print KOT. Error: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to print KOT'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  // Function to place order
  Future<void> placeOrder() async {
    final url = Uri.parse('http://10.0.2.2:3000/api/orders');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'OrderNumber': 'ORD1003',
        'UserId': 101,
        'UserName': widget.customerNumber,
        'CustomerId': 101,
        'CustomerName': 'Counter Sale',
        'TableName': widget.table,
        'TaxableAmount': calculateTaxableAmount(),
        'TotalAmount': calculateTotalAmount(),
        'ActiveInnactive': 'Active',
        'CreditOrPaid': 'Credit',
      }),
    );

    if (response.statusCode == 201) {
      print('Order placed successfully');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Order placed successfully'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    } else {
      print('Failed to place order. Error: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to place order'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }
}
