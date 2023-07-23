import 'package:flutter/material.dart';

class CollectionAddView extends StatefulWidget {
  const CollectionAddView({super.key});

  @override
  State<CollectionAddView> createState() => _CollectionAddViewState();
}

class _CollectionAddViewState extends State<CollectionAddView> {
  final _formKey = GlobalKey<FormState>();

  final List _itemsList = [true];

  final _titleController = TextEditingController();

  void _addNewCollection() {
    _formKey.currentState!.validate();
    _formKey.currentState!.save();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APPBAR
      appBar: AppBar(
        title: const Text("Add a new Collection"),
      ),

      // BODY
      body: Form(
        // KEY
        key: _formKey,

        // CHILD
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30, left: 10, right: 10),
          child: Column(
            children: [
              // TITLE TEXT FORM FIELD
              TextFormField(
                controller: _titleController,
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

              // ITEM LIST VIEW
              Expanded(
                child: ListView.separated(
                  itemCount: _itemsList.length,
                  itemBuilder: (context, index) => Row(
                    children: [
                      // ITEM TITLE TEXT FORM FIELD
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            label: Text("Item"),
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      // ITEM DURATION TEXT FORM FIELD
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            label: Text("Duration"),
                          ),
                        ),
                      ),

                      // ADD ICON BUTTON
                      IconButton(
                        onPressed: () {
                          if (index == _itemsList.length - 1) {
                            setState(() {
                              _itemsList.insert(index, true);
                            });
                          } else {
                            setState(() {
                              _itemsList.removeAt(index);
                            });
                          }
                        },
                        icon: index == _itemsList.length - 1
                            ? const Icon(Icons.add_circle)
                            : const Icon(Icons.remove_circle),
                      ),
                    ],
                  ),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 20,
                  ),
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              // ADD BUTTON
              ElevatedButton(
                onPressed: _addNewCollection,
                child: const Text("Add"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
