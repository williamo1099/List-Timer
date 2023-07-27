import 'package:flutter/material.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(child: Text("header")),
          Text("Blabla"),
          Text("Blabla"),
        ],
      ),
    );
  }
}
