import 'package:flutter/material.dart';
import 'package:flutter_hive_crud/screens/widgets/text_action.dart';

import '../../constants/enums/yes_no.dart';
import '../../model/item.dart';

class SingleListItem extends StatelessWidget {
  const SingleListItem({
    super.key,
    required this.index,
    required this.item,
    required this.items,
    required this.deleteItem,
    required this.editHandle,
    required this.deleteDialog,
    required this.itemKey,
  });

  final int index;
  final Item item;
  final List<Map<String, dynamic>> items;
  final Function deleteItem;
  final Function editHandle;
  final Function deleteDialog;
  final int itemKey;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
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
            'Do you want to remove ${item.title} from list?',
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
      onDismissed: (direction) => deleteItem(key: itemKey),
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
              item.title,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              item.quantity.toString(),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: Wrap(
              children: [
                IconButton(
                  onPressed: () =>
                      editHandle(item: item, key:itemKey),
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () => deleteDialog(key: itemKey),
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
    );
  }
}
