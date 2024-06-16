import 'package:flutter/material.dart';

import '../pages/passcode_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 93, 150, 255),
            ),
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 93, 150, 255),
              ),
              accountName: Text(
                "Mohammed Asif",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              accountEmail: Text(
                "moh.asif@protonmail.ch",
                style: TextStyle(color: Colors.white),
              ),
              currentAccountPictureSize: Size.square(30),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PasscodeScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
