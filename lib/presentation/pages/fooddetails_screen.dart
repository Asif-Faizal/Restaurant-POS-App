import 'package:ballast_machn_test/data/models/food_model.dart';
import 'package:ballast_machn_test/presentation/widgets/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/extras_model.dart';
import '../../data/providers/menu_api_providers.dart';
import '../../data/repositories/menu_repository.dart';
import '../blocs/extras/extra_bloc.dart';
import '../blocs/extras/extras_event.dart';
import '../blocs/extras/extras_state.dart';
import '../blocs/add-to-menu/cart_bloc.dart';
import '../blocs/add-to-menu/cart_event.dart';
import '../blocs/add-to-menu/cart_state.dart';
import '../widgets/food_image.dart';

class DetailPage extends StatefulWidget {
  final String table;
  final Food food;

  const DetailPage({super.key, required this.table, required this.food});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _quantity = 1;
  String? _selectedExtra;
  double _extraPrice = 0.0;

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

  void _updateExtraPrice(String? extra, List<Extra> extras) {
    setState(() {
      _selectedExtra = extra;
      _extraPrice =
          extra != null ? extras.firstWhere((e) => e.name == extra).price : 0.0;
    });
  }

  double _calculateExtrasTotal() {
    return _extraPrice * _quantity;
  }

  double _calculateSubTotal() {
    return (widget.food.price * _quantity) + _calculateExtrasTotal();
  }

  @override
  void initState() {
    super.initState();
    final extraBloc = BlocProvider.of<ExtraBloc>(context);
    extraBloc.add(FetchExtrasEvent(widget.food.id));
  }

  void _addToCart() {
    if (_selectedExtra == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please select an extra before adding to menu'),
        ),
      );
      return;
    }

    final cartItem = {
      'food_id': widget.food.id,
      'food_name': widget.food.name,
      'food_image': widget.food.image,
      'food_price': widget.food.price,
      'quantity': _quantity,
      'extras_name': _selectedExtra,
      'extras_price': _extraPrice,
      'table_id': widget.table,
      'sub_total': _calculateSubTotal(),
      'order_id': 1,
    };

    print('Adding to cart: $cartItem');

    final cartBloc = BlocProvider.of<CartBloc>(context);
    cartBloc.add(AddToCartEvent(cartItem));
  }

  @override
  Widget build(BuildContext context) {
    final MenuRepository menuRepository = MenuRepository(
      apiProvider: MenuApiProvider(
        baseUrl: 'http://10.0.2.2:3000',
      ),
    );
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
          'Table ${widget.table}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          ShoppingCartButton(
            table: widget.table,
            menuRepository: menuRepository,
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: BlocBuilder<ExtraBloc, ExtraState>(
        builder: (context, state) {
          if (state is ExtraLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExtraLoaded) {
            final extras = state.extras;
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FoodImage(widget: widget),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.food.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                          Text(
                            '₹${widget.food.price}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 3,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Quantity:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                                        fontWeight: FontWeight.bold),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Extras:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          DropdownButton<String>(
                            value: _selectedExtra,
                            hint: const Text('Select an extra'),
                            items: extras.map((extra) {
                              return DropdownMenuItem<String>(
                                value: extra.name,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(extra.name,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text('₹${extra.price.toInt()}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ))
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (extra) =>
                                _updateExtraPrice(extra, extras),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        height: 115,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text('${widget.food.price} x'),
                                Text(' $_quantity:'),
                                const Spacer(),
                                Text((widget.food.price * _quantity)
                                    .toStringAsFixed(2))
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                    '${_selectedExtra ?? 'No Extras'} - ${_extraPrice.toInt()} x'),
                                Text(' $_quantity:'),
                                const Spacer(),
                                Text(
                                  _calculateExtrasTotal().toStringAsFixed(2),
                                )
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Sub-total',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  '₹${_calculateSubTotal().toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is ExtraError) {
            return const Center(child: Text('Failed to load extras'));
          } else {
            return const Center(child: Text('No extras available'));
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        height: 85,
        elevation: 0,
        color: Colors.transparent,
        child: BlocListener<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartLoading) {
              // Show a loading indicator
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  content: Text('Adding...'),
                  duration: Duration(seconds: 1),
                ),
              );
            } else {
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                      '$_quantity ${widget.food.name} with ${_selectedExtra ?? 'No Extras'} added'),
                  action: SnackBarAction(
                    label: 'undo',
                    onPressed: () {},
                    textColor: Colors.white,
                  ),
                ),
              );
            }
          },
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 10,
              backgroundColor: const Color.fromARGB(255, 255, 228, 147),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _selectedExtra != null ? _addToCart : null,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add to menu',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  Icon(Icons.bookmark_add_rounded)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
