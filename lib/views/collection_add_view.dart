import 'package:flutter/material.dart';

class CollectionAddView extends StatefulWidget {
  const CollectionAddView({super.key});

  @override
  State<CollectionAddView> createState() => _CollectionAddViewState();
}

class _CollectionAddViewState extends State<CollectionAddView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APPBAR
      appBar: AppBar(
        title: const Text("Add a new Collection"),
      ),

      // BODY
      body: Form(
        child: Column(
          children: [
            // TITLE TEXT FORM FIELD
            TextFormField(
              decoration: const InputDecoration(
                label: Text("Title"),
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.trim().length >= 20) {
                  return "Title must be between one and 20 characters long.";
                }

                return null;
              },
            ),

            //
            const SizedBox(
              height: 12,
            ),

            // ADD BUTTON
            ElevatedButton(
              onPressed: () {},
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}
