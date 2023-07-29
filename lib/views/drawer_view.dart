import 'package:flutter/material.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: Column(
        children: [
          // DRAWER HEADER
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // APP LOGO IMAGE
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/images/logo.png"),
                ),
                SizedBox(height: 15),

                // WELCOME TEXT
                Text("Welcome!"),
              ],
            ),
          ),
          SizedBox(height: 20),

          // DRAWER ITEMS
          ListTile(
            leading: Icon(Icons.question_mark),
            title: Text("How to use the app"),
          ),

          ListTile(
            leading: Icon(Icons.north_east),
            title: Text("Check the app repo!"),
          ),

          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
          ),
        ],
      ),
    );
  }
}
