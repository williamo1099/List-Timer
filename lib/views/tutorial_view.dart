import 'package:flutter/material.dart';

class TutorialView extends StatelessWidget {
  const TutorialView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APPBAR
      appBar: AppBar(
        title: const Text("How to use the app"),
      ),

      // BODY
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              // INTRO TEXT
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text.rich(
                  TextSpan(
                      text:
                          "Haa.. You are desperate enough to use the app? Kiddng! Here are some tutorials on how to use the app properly so check them out!"),
                ),
              ),
              SizedBox(height: 10),

              // WHERE TO START TUTORIAL ITEM VIEW
              _TutorialItemView(
                title: "Where to start?",
                content: [
                  [
                    "So you are a bit confused on where to start? You may follow these steps below."
                  ],
                  [
                    "1. Add a new collection by tapping the add button on top right.",
                    "assets/images/tutorials/adding.png"
                  ],
                  [
                    "2. When you have reached the editor view, enter a new title for your new collection. For example, set the title to 'Treadmill Workout'.",
                    "assets/images/tutorials/adding_title.png"
                  ],
                  [
                    "3. Add as many timers as you need for this collection by tapping the plus green button.",
                    "assets/images/tutorials/adding_collection_add.png"
                  ],
                  [
                    "4. Add title and duration for each timers or you may remove a timer by tapping the minus red button if it is not needed.",
                    "assets/images/tutorials/adding_collection_remove.png"
                  ],
                  [
                    "5. When everything looks good, you can save the collection by tapping the save button.",
                    "assets/images/tutorials/adding_collection_save.png"
                  ]
                ],
              ),

              // HOW TO VIEW AND PLAY A COLLECTION TUTORIAL ITEM VIEW
              _TutorialItemView(
                  title: "How to view and play a collection?",
                  content: [
                    [
                      "Now you have made a collection of your own and you don't know how to see it. Check these steps below."
                    ],
                    [
                      "1. In the main screen, you will see a list of collection that you have made. For this example, there are three collections: 'Treadmill Workout', 'Studying Session' and 'Be Happy'.",
                      "assets/images/tutorials/viewing.png"
                    ],
                    [
                      "2. Click the collection that you want to see and you will see a list of timers in that particular collection.",
                      "assets/images/tutorials/viewing_collection.png"
                    ],
                    [
                      "3. To play all those timers in collection, click the play button.",
                      "assets/images/tutorials/playing.png"
                    ]
                  ]),

              // HOW TO UPDATE A COLLECTION EXPANSION TILE
              _TutorialItemView(title: "How to update a collection?", content: [
                [
                  "Oops, you spot a mistake in your collection. No worries and just update the collection by doing these steps."
                ],
                ["1. Open that particular collection you want to update."],
                [
                  "2. Update the collection by tapping the edit button on the top right.",
                  "assets/images/tutorials/updating.png"
                ],
                [
                  "3. You will reach to the editor view and do as many updates as you want."
                ]
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _TutorialItemView extends StatelessWidget {
  final String title;
  final List<List<String>> content;

  const _TutorialItemView({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title),
      children: [
        for (final item in content) ...[
          // TUTORIAL TEXT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text.rich(
              TextSpan(
                text: item[0],
              ),
            ),
          ),
          const SizedBox(height: 5),

          // TUTORIAL IMAGE
          if (item.length > 1) Image.asset(item[1]),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 10),
      ],
    );
  }
}
