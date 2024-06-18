import 'package:flutter/material.dart';
import 'customerinfo_sheet.dart';

class TableTile extends StatelessWidget {
  final int index;
  const TableTile({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showCustomerForm(context, index); // Pass context and index here
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.blue.shade50, Colors.blue.shade400],
                center: Alignment.center,
                radius: 0.85,
                focal: Alignment.center,
                focalRadius: 0.1,
              ),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.blue.shade900, width: 2)),
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

  void _showCustomerForm(BuildContext context, int index) {
    showModalBottomSheet(
      backgroundColor: Colors.blue.shade900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
      ),
      context: context,
      builder: (context) =>
          CustomerForm(index: index), // Pass index to CustomerForm
    );
  }
}
