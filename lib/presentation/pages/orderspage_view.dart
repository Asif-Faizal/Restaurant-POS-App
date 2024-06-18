import 'package:flutter/material.dart';

class OrdersPageView extends StatelessWidget {
  final String baseUrl;
  const OrdersPageView({super.key, required this.baseUrl});

  @override
  Widget build(BuildContext context) {
    return OrdersPageViewBody();
  }
}

class OrdersPageViewBody extends StatefulWidget {
  const OrdersPageViewBody({super.key});

  @override
  State<OrdersPageViewBody> createState() => _OrdersPageViewBodyState();
}

class _OrdersPageViewBodyState extends State<OrdersPageViewBody> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
