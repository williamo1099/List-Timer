import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:list_timer/models/collection_model.dart';

// MODELS
import 'package:list_timer/models/item_model.dart';

// PROVIDERS
import 'package:list_timer/providers/collection_provider.dart';

class CollectionEditorView extends ConsumerStatefulWidget {
  const CollectionEditorView({super.key, required this.currentCollection});

  final Collection? currentCollection;

  @override
  ConsumerState<CollectionEditorView> createState() =>
      _CollectionEditorViewState();
}

class _CollectionEditorViewState extends ConsumerState<CollectionEditorView> {
  final _formKey = GlobalKey<FormState>();

  late int _itemsCount;
  late TextEditingController _titleController;
  late List<TextEditingController> _itemTitleListController;
  late List<TextEditingController> _itemDurationListController;

  bool _isUpdating() {
    return widget.currentCollection != null;
  }

  void _editCollection() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      // Get the list of all items.
      final List<Item> itemsList = [
        for (var i = 0; i < _itemsCount; i++)
          Item(
              title: _itemTitleListController[i].text,
              duration: int.parse(_itemDurationListController[i].text))
      ];

      if (_isUpdating()) {
        // Update an existing collection.
        Collection replacementCollection = Collection(
            id: widget.currentCollection!.id,
            title: _titleController.text,
            itemsList: itemsList);
        ref.read(collectionProvider.notifier).replaceCollection(
            widget.currentCollection!.id, replacementCollection);
      } else {
        // Add a new collection.
        Collection newCollection =
            Collection(title: _titleController.text, itemsList: itemsList);
        ref.read(collectionProvider.notifier).addNewCollection(newCollection);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();

    if (_isUpdating()) {
      // Update an existing collection.
      Collection collection = widget.currentCollection!;

      _itemsCount = collection.itemsList.length;
      _titleController = TextEditingController(text: collection.title);

      _itemTitleListController = [
        for (final item in collection.itemsList)
          TextEditingController(text: item.title)
      ];
      _itemDurationListController = [
        for (final item in collection.itemsList)
          TextEditingController(text: item.duration.toString())
      ];
    } else {
      // Add a new collection.
      _itemsCount = 0;
      _titleController = TextEditingController();
      _itemTitleListController = [];
      _itemDurationListController = [];
    }
  }

  @override
  void dispose() {
    super.dispose();

    _titleController.dispose();
    for (var i = 0; i < _itemsCount; i++) {
      _itemTitleListController[i].dispose();
      _itemDurationListController[i].dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APPBAR
      appBar: AppBar(
        title: _isUpdating()
            ? const Text("Update Collection")
            : const Text("Add a new Collection"),
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
                          _itemsCount++;
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
                  itemCount: _itemsCount,
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
                            _itemsCount--;
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
                onPressed: _editCollection,
                child: _isUpdating() ? const Text("Update") : const Text("Add"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
