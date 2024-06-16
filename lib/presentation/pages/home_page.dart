import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/bb.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          drawer: const MyDrawer(),
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                const SliverAppBar(
                  foregroundColor: Colors.white,
                  elevation: 10,
                  backgroundColor: Colors.transparent,
                  title: Text(
                    'Ballast Hotel',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  pinned: true,
                  floating: true,
                  bottom: TabBar(
                    indicatorWeight: 5,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: Color.fromARGB(255, 93, 150, 255),
                    tabs: [
                      Tab(
                        child: Text(
                          'Home',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Orders',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Completed',
                          style: TextStyle(color: Colors.white, fontSize: 16),
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
                const OrdersPageView(
                  baseUrl: 'http://10.0.2.2:3000/orders?is_delivered=0',
                ),
                const CompletedpageView(
                  baseUrl: 'http://10.0.2.2:3000/orders?is_delivered=1',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
