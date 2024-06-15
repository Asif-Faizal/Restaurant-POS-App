import 'package:ballast_machn_test/presentation/pages/menu_screen.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/menu_repository.dart';

class ShoppingCartButton extends StatefulWidget {
  final String table;
  final MenuRepository menuRepository;

  ShoppingCartButton({required this.table, required this.menuRepository});

  @override
  _ShoppingCartButtonState createState() => _ShoppingCartButtonState();
}

class _ShoppingCartButtonState extends State<ShoppingCartButton> {
  int itemCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchMenuItems();
  }

  Future<void> _fetchMenuItems() async {
    try {
      final tableId = int.parse(widget.table);
      final menuItems = await widget.menuRepository.getMenuItems(tableId);
      setState(() {
        itemCount = menuItems.length;
      });
    } catch (e) {
      print("Error fetching menu items: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        padding: const EdgeInsets.all(5),
        shape: const CircleBorder(),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuPage(
              table: widget.table,
            ),
          ),
        );
      },
      child: const Icon(Icons.menu_book_rounded),
    );
  }
}
