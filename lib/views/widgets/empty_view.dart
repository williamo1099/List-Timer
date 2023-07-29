import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // QUESTION MARK IMAGE
          Image.asset(
            "assets/images/question_mark.png",
            width: 120,
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color.fromARGB(255, 246, 244, 235)
                : null,
          ),
          const SizedBox(height: 20),

          // MESSAGE TEXT
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
