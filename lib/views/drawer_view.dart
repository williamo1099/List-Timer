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

          // DRAWER ITEMS
          ListTile(
            leading: Icon(Icons.water_drop),
            title: Text("Teardrops"),
          ),
        ],
      ),
    );
  }
}
