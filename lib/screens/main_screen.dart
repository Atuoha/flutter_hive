import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController title = TextEditingController();
  final TextEditingController quantity = TextEditingController();

  // delete item
  void deleteItem(String itemId) {}

  // edit item
  void editItem(String itemId) {}

  // submit new item
  void submitNewItem() {
    var valid = _formKey.currentState!.validate();

    if (!valid) {
      return;
    }
  }

  // modal for new item
  Future newItem() {
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
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown.withOpacity(0.5)),
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
        onPressed: () => newItem(),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Hive Flutter'),
      ),
      body: ListView(
        children: List.generate(
          30,
          (index) => Padding(
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
                trailing: const Wrap(
                  children: [
                    IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: null,
                      icon: Icon(
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
    );
  }
}
