import 'package:ballast_machn_test/presentation/pages/catogory_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/table_tile.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({
    super.key,
    required this.tableRow,
    required this.totalTables,
  });

  final int tableRow;
  final int totalTables;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategoryPage(
                            table: '0',
                          )));
            },
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              color: Colors.amber.shade300,
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Take Out',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: tableRow,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
            ),
            itemBuilder: (context, index) {
              return TableTile(
                index: index,
              );
            },
            itemCount: totalTables,
          ),
        ),
      ],
    );
  }
}
