import 'package:ballast_machn_test/presentation/pages/menu_screen.dart';
import 'package:flutter/material.dart';

class ShoppingCartButton extends StatefulWidget {
  final String table;

  ShoppingCartButton({required this.table});

  @override
  _ShoppingCartButtonState createState() => _ShoppingCartButtonState();
}

class _ShoppingCartButtonState extends State<ShoppingCartButton> {
  int itemCount = 0;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        padding: const EdgeInsets.all(5),
        shape: const CircleBorder(),
      ),
      onPressed: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => MenuPage(
        //       table: widget.table,
        //     ),
        //   ),
        // );
      },
      child: const Icon(Icons.menu_book_rounded),
    );
  }
}
