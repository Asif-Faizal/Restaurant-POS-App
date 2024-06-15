import 'package:flutter/material.dart';

class OrdersListButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const OrdersListButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 254, 231, 163),
            border: Border.all(width: 0.2),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 8,
            ),
            Icon(icon, size: 20),
          ],
        ),
      ),
    );
  }
}
