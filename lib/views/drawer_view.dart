import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// VIEWS
import 'package:list_timer/views/tutorial_view.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // DRAWER HEADER
          const DrawerHeader(
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
          const SizedBox(height: 20),

          // DRAWER ITEMS
          ListTile(
            leading: const Icon(Icons.question_mark),
            title: const Text("How to use the app"),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const TutorialView(),
            )),
          ),

          ListTile(
            leading: const Icon(Icons.north_east),
            title: const Text("Check the app repo!"),
            onTap: () async {
              final _url =
                  Uri.parse("https://github.com/williamo1099/List-Timer");
              if (!await launchUrl(_url)) {
                throw Exception("Could not launch $_url");
              }
            },
          ),
        ],
      ),
    );
  }
}
