import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hive_crud/constants/string_constants.dart';
import 'package:flutter_hive_crud/screens/widgets/toast.dart';

import '../constants/enums/status.dart';
import '../model/item.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveController {
  final BuildContext context;
  final Function fetchDataFunction;

  HiveController({required this.context, required this.fetchDataFunction});

  final hiveBox = Hive.box(StringConstants.hiveBox);

  // fetch data
  List<Map<String, dynamic>> fetchData() {
    final data = hiveBox.keys.map((key) {
      final item = hiveBox.get(key);
      return {
        'key': key,
        'id': item['id'],
        'title': item['title'],
        'quantity': item['quantity']
      };
    }).toList();

    return data.reversed.toList();
  }

  Future<void> createItem({
    required Item item,
  }) async {
    try {
      await hiveBox.add(item.toMap());
      afterAction(keyword: 'saved');
    } catch (e) {
      toastInfo(
        msg: 'An error occurred while trying to create item',
        status: Status.error,
      );
      if (kDebugMode) {
        print('Error occurred $e');
      }
    }
  }

  Future<void> editItem({required Item item, required int itemKey}) async {
    try {
      hiveBox.put(itemKey, item.toMap());
      afterAction(keyword: 'edited');
    } catch (e) {
      toastInfo(
        msg: 'An error occurred while trying to edit item',
        status: Status.error,
      );
      if (kDebugMode) {
        print('Error occurred $e');
      }
    }
  }

  Future<void> deleteItem({required int key}) async {
    try {
      await hiveBox.delete(key);
      afterAction(keyword: 'deleted');
    } catch (e) {
      toastInfo(
        msg: 'An error occurred while trying to delete item',
        status: Status.error,
      );
      if (kDebugMode) {
        print('Error occurred $e');
      }
    }
  }

  Future<void> clearItems() async {
    try {
      await hiveBox.clear();
      afterAction(keyword: 'deleted');
    } catch (e) {
      toastInfo(
        msg: 'An error occurred while trying to delete item',
        status: Status.error,
      );
      if (kDebugMode) {
        print('Error occurred $e');
      }
    }
  }

  void afterAction({required String keyword}) {
    toastInfo(
      msg: 'Successfully $keyword item',
      status: Status.success,
    );
    fetchDataFunction();
    Navigator.of(context).pop();
  }
}
