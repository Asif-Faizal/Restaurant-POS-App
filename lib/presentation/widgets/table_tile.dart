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
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.blue.shade200, Colors.blue.shade600],
                center: Alignment.center,
                radius: 0.85,
                focal: Alignment.center,
                focalRadius: 0.1,
              ),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.blue.shade900, width: 1)),
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
      ),
    );
  }
}
