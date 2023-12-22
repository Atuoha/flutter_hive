import 'package:flutter/material.dart';
import 'package:flutter_hive_crud/screens/widgets/are_you_sure.dart';
import 'package:flutter_hive_crud/screens/widgets/text_action.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../constants/enums/yes_no.dart';
import '../constants/string_constants.dart';
import '../controller/controller.dart';
import '../model/item.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController title = TextEditingController();
  final TextEditingController quantity = TextEditingController();
  late Controller controller;
  final hiveBox = Hive.box(StringConstants.hiveBox);
  final List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    controller = Controller(context: context);
  }

  // delete dialog
  void deleteDialog(int itemId) {
    areYouSureDialog(
      title: 'Delete item',
      content: 'Are you sure you want to delete item',
      id: itemId.toString(),
      isIdInvolved: true,
      context: context,
      action: controller.deleteItem,
    );
  }

  // submit new item
  void submitNewItem() {
    FocusScope.of(context).unfocus();
    var valid = _formKey.currentState!.validate();

    if (!valid) {
      return;
    }
    Item item = Item(
      id: const Uuid().v4(),
      title: title.text,
      quantity: int.parse(quantity.text),
    );
    controller.createItem(item: item);
  }

  // modal for new item
  Future modalForNewItem() {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: title,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Enter Title',
                  label: Text('Title'),
                ),
                validator: (value) {
                  if (value!.isEmpty || value.length < 3) {
                    return 'Title needs to be valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: quantity,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter Quantity',
                  label: Text('Quantity'),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Quantity can not be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.withOpacity(0.5),
                ),
                onPressed: () => submitNewItem(),
                icon: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                label: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => modalForNewItem(),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Hive Flutter'),
      ),
      body: ListView(
        children: List.generate(
          30,
          (index) => Dismissible(
            key: ValueKey(index),
            confirmDismiss: (direction) => showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                elevation: 3,
                title: const Text(
                  'Are you sure?',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                content: Text(
                  'Do you want to remove $index from list?',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                actions: [
                  textAction('Yes', YesNo.yes, context),
                  textAction('No', YesNo.no, context),
                ],
              ),
            ),
            onDismissed: (direction) =>
                controller.deleteItem(id: index.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.red,
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
                size: 40,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.only(left: 5),
                  tileColor: Colors.brown.withOpacity(0.7),
                  leading: CircleAvatar(
                    backgroundColor: Colors.brown.shade500,
                    child: const Icon(
                      Icons.circle_outlined,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    'Index $index',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  subtitle: const Text(
                    'Subtitle',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: Wrap(
                    children: [
                      IconButton(
                        onPressed: () =>
                            controller.editItem(id: index.toString()),
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () => deleteDialog(index),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
