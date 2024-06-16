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
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
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
