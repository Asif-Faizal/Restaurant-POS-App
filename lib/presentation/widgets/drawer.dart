import 'package:flutter/material.dart';

import '../pages/passcode_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    super.key,
  });

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool _inclusiveTax = true;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/bb.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'User ID: 123456',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
                title: const Text(
                  'Tax Type',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                trailing: SizedBox(
                  height: 40,
                  child: ToggleButtons(
                    borderWidth: 3,
                    borderColor: Colors.white,
                    disabledBorderColor: Colors.white,
                    selectedBorderColor: Colors.white,
                    onPressed: (int index) {
                      setState(() {
                        if (index == 0) {
                          _inclusiveTax = true;
                          print('Inclusive Tax selected');
                        } else {
                          _inclusiveTax = false;
                          print('Exclusive Tax selected');
                        }
                      });
                    },
                    isSelected: [_inclusiveTax, !_inclusiveTax],
                    borderRadius: BorderRadius.circular(10),
                    selectedColor: Colors.white,
                    fillColor: Colors.white,
                    children: [
                      Container(
                        height: 20,
                        width: 60,
                        alignment: Alignment.center,
                        child: Text(
                          'Inclusive',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _inclusiveTax ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        height: 20,
                        width: 60,
                        alignment: Alignment.center,
                        child: Text(
                          'Exclusive',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: !_inclusiveTax ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            const Divider(
              color: Colors.white,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PasscodeScreen()));
              },
              child: const ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Divider(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
