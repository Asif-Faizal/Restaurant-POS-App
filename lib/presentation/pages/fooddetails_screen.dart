import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ballast_machn_test/presentation/widgets/drawer.dart';
import '../../data/models/food_model.dart';
import '../blocs/tax_type_bloc.dart';
import '../widgets/custom_button.dart';

class FoodDetailsPage extends StatefulWidget {
  final Food food;

  const FoodDetailsPage({Key? key, required this.food}) : super(key: key);

  @override
  State<FoodDetailsPage> createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      if (_quantity < 10) {
        _quantity++;
      }
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  void _addToMenu() {
    // Perform the action you want when adding to the menu
    print('Adding ${widget.food.pdtName} to the menu');
    // Here you can add more logic, such as adding to a cart or updating a database
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
          drawer: MyDrawer(),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            title: Text(
              widget.food.pdtName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: SizedBox(
                      height: 300,
                      width: 400,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          widget.food.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.food.pdtName,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        '₹ ${widget.food.saleAmt.toInt()}',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Quantity:',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              padding: const EdgeInsets.all(5),
                              shape: const CircleBorder(),
                            ),
                            onPressed: _decrementQuantity,
                            child: const Icon(Icons.remove),
                          ),
                          SizedBox(
                            width: 25,
                            child: Center(
                              child: Text(
                                '$_quantity',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              padding: const EdgeInsets.all(5),
                              shape: const CircleBorder(),
                            ),
                            onPressed: _incrementQuantity,
                            child: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                BlocBuilder<TaxTypeBloc, TaxTypeState>(
                  builder: (context, state) {
                    double subtotal = widget.food.saleAmt * _quantity;
                    double taxAmount = 0;
                    if (state is InclusiveTax) {
                      taxAmount =
                          subtotal * widget.food.tax / (100 + widget.food.tax);
                    } else {
                      taxAmount = subtotal * widget.food.tax / 100;
                    }
                    double totalAmount = subtotal + taxAmount;

                    return Card(
                      color: Colors.blue.shade100,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      elevation: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        height: 115,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                    'Price ( ${widget.food.saleAmt.toInt()} x $_quantity )'),
                                const Spacer(),
                                Text('${subtotal.toInt()}')
                              ],
                            ),
                            Row(
                              children: [
                                Text('Tax'),
                                const Spacer(),
                                Text(
                                  taxAmount.toStringAsFixed(2),
                                )
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Sub-Total',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  '₹ ${totalAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            child: MyButton(
              onPressed: _addToMenu,
              text: 'Add to Menu',
            ),
          ),
        ),
      ],
    );
  }
}
