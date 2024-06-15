import 'package:flutter/material.dart';

import '../../domain/entities/category.dart';
import '../pages/fooditem_screen.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.item,
    required this.table,
  });

  final Category item;
  final String table;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(item.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FooditemScreen(
              table: table,
              itemCount: 10,
              category: item.name,
              categoryId: item.id,
            ),
          ),
        );
      },
      child: Card(
        elevation: 5,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 255, 242, 202),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black, Colors.transparent],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
