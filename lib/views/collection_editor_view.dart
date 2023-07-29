import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:list_timer/models/collection_model.dart';

// MODELS
import 'package:list_timer/models/timer_model.dart';

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

  late int _timersCount;
  late TextEditingController _collectionTitleController;
  late List<TextEditingController> _timersTitleListController;
  late List<TextEditingController> _timersDurationListController;
  late List<TimerUnit> _timersDurationUnitList;

  bool _isUpdating() {
    return widget.currentCollection != null;
  }

  void _editCollection() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      // Get the list of all timers.
      final List<Timer> timersList = [
        for (var i = 0; i < _timersCount; i++)
          Timer(
              title: _timersTitleListController[i].text,
              duration: int.parse(_timersDurationListController[i].text),
              unit: _timersDurationUnitList[i])
      ];

      if (_isUpdating()) {
        // Update an existing collection.
        Collection replacementCollection = Collection(
            id: widget.currentCollection!.id,
            title: _collectionTitleController.text,
            timersList: timersList);
        ref.read(collectionProvider.notifier).replaceCollection(
            widget.currentCollection!.id, replacementCollection);
      } else {
        // Add a new collection.
        Collection newCollection = Collection(
            title: _collectionTitleController.text, timersList: timersList);
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

      _timersCount = collection.timersList.length;
      _collectionTitleController =
          TextEditingController(text: collection.title);

      _timersTitleListController = [
        for (final timer in collection.timersList)
          TextEditingController(text: timer.title)
      ];
      _timersDurationListController = [
        for (final timer in collection.timersList)
          TextEditingController(text: timer.duration.toString())
      ];
      _timersDurationUnitList = [
        for (final timer in collection.timersList) timer.unit
      ];
    } else {
      // Add a new collection.
      _timersCount = 0;
      _collectionTitleController = TextEditingController();
      _timersTitleListController = [];
      _timersDurationListController = [];
      _timersDurationUnitList = [];
    }
  }

  @override
  void dispose() {
    super.dispose();

    _collectionTitleController.dispose();
    for (var i = 0; i < _timersCount; i++) {
      _timersTitleListController[i].dispose();
      _timersDurationListController[i].dispose();
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
                controller: _collectionTitleController,
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
                  const Text("Add timers to collection"),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _timersCount++;
                          _timersTitleListController
                              .add(TextEditingController());
                          _timersDurationListController
                              .add(TextEditingController());
                          _timersDurationUnitList.add(TimerUnit.second);
                        });
                      },
                      icon: const Icon(
                        Icons.add_circle,
                        color: Colors.green,
                      )),
                ],
              ),

              // TIMER LIST VIEW
              Expanded(
                child: ListView.builder(
                  itemCount: _timersCount,
                  itemBuilder: (context, index) => Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // TIMER TITLE TEXT FORM FIELD
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _timersTitleListController[index],
                          decoration: const InputDecoration(
                            label: Text("Title"),
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

                      // TIMER DURATION TEXT FORM FIELD
                      Expanded(
                        flex: 3,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // DURATION TEXT FORM FIELD
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller:
                                    _timersDurationListController[index],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  label: Text("Duration"),
                                  hintText: "0",
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

                            // UNIT DROPDOWN MENU
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField(
                                  value: _timersDurationUnitList[index],
                                  items: TimerUnit.values
                                      .map(
                                        (unit) => DropdownMenuItem(
                                          value: unit,
                                          child: Text(unit.name),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _timersDurationUnitList[index] = value!;
                                    });
                                  }),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      // ADD ICON BUTTON
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _timersCount--;
                            _timersTitleListController.removeAt(index);
                            _timersDurationListController.removeAt(index);
                            _timersDurationUnitList.removeAt(index);
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
