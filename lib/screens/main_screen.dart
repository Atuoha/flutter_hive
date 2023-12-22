import 'package:flutter/material.dart';
import 'package:flutter_hive_crud/screens/widgets/are_you_sure.dart';
import 'package:flutter_hive_crud/screens/widgets/single_list_tile.dart';
import 'package:hive/hive.dart';
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
  late HiveController hiveController;
  final hiveBox = Hive.box(StringConstants.hiveBox);
  List<Map<String, dynamic>> items = [];
  int editKey = 0;
  bool isCreate = true;

  @override
  void initState() {
    super.initState();
    hiveController = HiveController(
      context: context,
      fetchDataFunction: fetchData,
    );
    fetchData();
  }

  // fetch data
  void fetchData() {
    setState(() {
      items = hiveController.fetchData();
    });
  }

  // delete dialog
  void deleteDialog({required int key}) {
    areYouSureDialog(
      title: 'Delete item',
      content: 'Are you sure you want to delete item',
      key: key,
      isKeyInvolved: true,
      context: context,
      action: hiveController.deleteItem,
    );
  }

  // edit handle
  void editHandle({required Item item, required int key}) {
    Item item = Item.fromMap(hiveBox.get(key));
    print(item.title);

    setState(() {
      title.text = item.title;
      quantity.text = item.quantity.toString();
      editKey = key;
      isCreate = false;
    });

    // modal for editing
    itemModal();
  }

  // clear all dialog
  void clearAllDialog() {
    areYouSureDialog(
      title: 'Clear items',
      content: 'Are you sure you want to clear items',
      context: context,
      action: hiveController.clearItems,
    );
  }

  // submit item
  void submitItem() {
    FocusScope.of(context).unfocus();
    var valid = _formKey.currentState!.validate();

    if (!valid) {
      return;
    }
    Item item = Item(
      title: title.text,
      quantity: int.parse(quantity.text),
    );
    if (isCreate) {
      hiveController.createItem(item: item);
      title.clear();
      quantity.clear();
    } else {
      hiveController.editItem(item: item, itemKey: editKey);

      // resetting data
      setState(() {
        title.clear();
        quantity.clear();
        editKey = 0;
        isCreate = true;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData();
  }

  // modal for new/edit item
  Future itemModal() {
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
                autofocus: true,
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
                onPressed: () => submitItem(),
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
        onPressed: () => itemModal(),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Hive Flutter'),
        actions: [
          items.isNotEmpty
              ? IconButton(
                  onPressed: () => clearAllDialog(),
                  icon: const Icon(Icons.delete_forever),
                )
              : const SizedBox.shrink()
        ],
      ),
      body: items.isNotEmpty
          ? ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                Item item = Item.fromMap(items[index]);
                return SingleListItem(
                  index: index,
                  item: item,
                  items: items,
                  deleteItem: hiveController.deleteItem,
                  editHandle: editHandle,
                  itemKey: items[index]['key'],
                  deleteDialog: deleteDialog,
                );
              })
          : const Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 10),
                  Text(
                    'Items are empty',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
