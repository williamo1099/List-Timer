import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:list_timer/models/collection_model.dart';

// MODELS
import 'package:list_timer/models/item_model.dart';

// PROVIDERS
import 'package:list_timer/providers/collection_provider.dart';

class CollectionAddView extends ConsumerStatefulWidget {
  const CollectionAddView({super.key, required this.currentCollection});

  final Collection? currentCollection;

  @override
  ConsumerState<CollectionAddView> createState() => _CollectionAddViewState();
}

class _CollectionAddViewState extends ConsumerState<CollectionAddView> {
  late int itemsCount;

  // FORM PROPERTIES
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late List<TextEditingController> _itemTitleListController;
  late List<TextEditingController> _itemDurationListController;

  @override
  void initState() {
    super.initState();

    if (_isAdding()) {
      itemsCount = 0;
      _titleController = TextEditingController();
      _itemTitleListController = [];
      _itemDurationListController = [];
    } else {
      Collection collection = widget.currentCollection!;

      itemsCount = collection.itemsList.length;
      _titleController = TextEditingController(text: collection.title);
      _itemTitleListController = [
        for (final item in collection.itemsList)
          TextEditingController(text: item.title)
      ];
      _itemDurationListController = [
        for (final item in collection.itemsList)
          TextEditingController(text: item.duration.toString())
      ];
    }
  }

  bool _isAdding() {
    if (widget.currentCollection == null) {
      return true;
    } else {
      return false;
    }
  }

  void _addNewCollection() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final List<Item> itemsList = [];
      for (var i = 0; i < itemsCount; i++) {
        Item newItem = Item(
            title: _itemTitleListController[i].text,
            duration: int.parse(_itemDurationListController[i].text));

        itemsList.add(newItem);
      }

      Collection newCollection =
          Collection(title: _titleController.text, itemsList: itemsList);

      if (_isAdding()) {
        ref.read(collectionProvider.notifier).addNewCollection(newCollection);
      } else {
        ref
            .read(collectionProvider.notifier)
            .replaceCollection(widget.currentCollection!.id, newCollection);
      }

      Navigator.of(context).pop();
    } else {
      return;
    }
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
        title: _isAdding()
            ? const Text("Add a new Collection")
            : const Text("Update Collection"),
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
                          itemsCount++;
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
                  itemCount: itemsCount,
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
                            itemsCount--;
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
                child: _isAdding() ? const Text("Add") : const Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
