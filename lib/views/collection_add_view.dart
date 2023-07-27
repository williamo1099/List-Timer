import 'package:flutter/material.dart';

class CollectionAddView extends StatefulWidget {
  const CollectionAddView({super.key});

  @override
  State<CollectionAddView> createState() => _CollectionAddViewState();
}

class _CollectionAddViewState extends State<CollectionAddView> {
  final _formKey = GlobalKey<FormState>();

  final List _itemsList = [];

  final TextEditingController _titleController = TextEditingController();
  final List<TextEditingController> _itemTitleListController = [];
  final List<TextEditingController> _itemDurationListController = [];

  void _addNewCollection() {
    _formKey.currentState!.validate();
    _formKey.currentState!.save();
  }

  @override
  void dispose() {
    super.dispose();

    _titleController.dispose();
    for (final controller in _itemTitleListController) {
      controller.dispose();
    }
    for (final controller in _itemDurationListController) {
      controller.dispose();
    }
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

              const SizedBox(height: 20),
              Row(
                children: [
                  const Text("Add items to collection"),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _itemsList.add(null);
                          _itemTitleListController.add(TextEditingController());
                          _itemDurationListController
                              .add(TextEditingController());
                        });
                      },
                      icon: const Icon(
                        Icons.add_circle,
                        color: Colors.green,
                      )),
                ],
              ),

              // ITEM LIST VIEW

              Expanded(
                child: ListView.builder(
                  itemCount: _itemsList.length,
                  itemBuilder: (context, index) => Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // ITEM TITLE TEXT FORM FIELD
                      Expanded(
                        child: TextFormField(
                          controller: _itemTitleListController[index],
                          decoration: const InputDecoration(
                            label: Text("Item"),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please input a valid title.";
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(width: 20),

                      // ITEM DURATION TEXT FORM FIELD
                      Expanded(
                        child: TextFormField(
                          controller: _itemDurationListController[index],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            label: Text("Duration"),
                            hintText: "0",
                            suffixText: "minutes",
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                int.tryParse(value) == null) {
                              return "Please input a valid duration.";
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(width: 10),

                      // ADD ICON BUTTON
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _itemsList.removeAt(index);
                            _itemTitleListController.removeAt(index);
                            _itemDurationListController.removeAt(index);
                          });
                        },
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
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
