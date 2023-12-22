import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hive_crud/constants/string_constants.dart';
import 'package:flutter_hive_crud/screens/widgets/toast.dart';

import '../constants/enums/status.dart';
import '../model/item.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Controller {
  final BuildContext context;

  Controller({required this.context});

  final hiveBox = Hive.box(StringConstants.hiveBox);

  Future<void> createItem({
    required Item item,
  }) async {
    try {
      await hiveBox.add(
        {
          'id': item.id,
          'title': item.title,
          'quantity': item.quantity,
        },
      );
      print('Items length ${hiveBox.length}');
      toastInfo(
        msg: 'Successfully saved item',
        status: Status.success,
      );
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

  Future<void> editItem({required String id}) async {
    try {} catch (e) {
      toastInfo(
        msg: 'An error occurred while trying to edit item',
        status: Status.error,
      );
      if (kDebugMode) {
        print('Error occurred $e');
      }
    }
  }

  Future<void> deleteItem({required String id}) async {
    try {} catch (e) {
      toastInfo(
        msg: 'An error occurred while trying to delete item',
        status: Status.error,
      );
      if (kDebugMode) {
        print('Error occurred $e');
      }
    }
  }
}
