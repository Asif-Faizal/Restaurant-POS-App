import 'package:flutter/material.dart';

import '../pages/fooddetails_screen.dart';

class FoodImage extends StatelessWidget {
  const FoodImage({
    super.key,
    required this.widget,
  });

  final DetailPage widget;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
            height: 200,
            width: double.infinity,
            child: Hero(
              createRectTween: (Rect? begin, Rect? end) {
                return MaterialRectCenterArcTween(begin: begin, end: end);
              },
              tag: widget.food.id,
              child: Image.network(
                widget.food.image,
                fit: BoxFit.cover,
              ),
            )),
      ),
    );
  }
}
