import 'package:flutter/material.dart';

import '../pages/catogory_screen.dart';

class TableTile extends StatelessWidget {
  final int index;
  const TableTile({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryPage(
                      table: '${index + 1}',
                    )));
      },
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        color: Colors.amber.shade300,
        child: Center(
          child: Text(
            'Table ${index + 1}',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
