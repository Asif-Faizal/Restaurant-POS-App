import 'package:flutter/material.dart';

import '../widgets/drawer.dart';
import 'completedpage_view.dart';
import 'homepage_view.dart';
import 'orderspage_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static int tableRow = 3;
  final int totalTables = 21;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: const MyDrawer(),
        backgroundColor: Colors.amber.shade50,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              const SliverAppBar(
                elevation: 10,
                backgroundColor: Color.fromARGB(255, 255, 228, 147),
                title: Text(
                  'Ballast Hotel',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                pinned: true,
                floating: true,
                bottom: TabBar(
                  indicatorWeight: 5,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Color.fromARGB(255, 255, 191, 0),
                  tabs: [
                    Tab(
                      child: Text(
                        'Home',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Orders',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Completed',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: <Widget>[
              HomePageView(tableRow: tableRow, totalTables: totalTables),
              OrdersPageView(
                baseUrl: 'http://10.0.2.2:3000/orders?is_delivered=0',
              ),
              CompletedpageView(
                baseUrl: 'http://10.0.2.2:3000/orders?is_delivered=1',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
