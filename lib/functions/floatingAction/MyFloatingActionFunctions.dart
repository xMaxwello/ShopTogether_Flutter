import 'package:flutter/material.dart';
import 'package:shopping_app/components/bottomSheet/MyDraggableScrollableWidget.dart';
import 'package:shopping_app/components/bottomSheetItems/MyGroupBottomSheet.dart';
import 'package:shopping_app/components/bottomSheetItems/MyMemberBottomSheet.dart';
import 'package:shopping_app/functions/services/notification/MyNotificationService.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';
import 'package:timezone/timezone.dart';

import '../services/firestore/MyFirestoreService.dart';

class MyFloatingActionFunctions {

  late BuildContext _context;
  late String _selectedGroupUUID;

  MyFloatingActionFunctions(BuildContext context, String selectedGroupUUID) {
    _context = context;
    _selectedGroupUUID = selectedGroupUUID;
  }

  void addGroup() async {

    showModalBottomSheet(
      context: _context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return MyDraggableScrollableWidget(
            widgets: MyGroupBottomSheet.generateBottomSheet(context)
        );
      },
    );

  }

  void addUserToGroup() {


    showModalBottomSheet(
      context: _context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return MyDraggableScrollableWidget(
            widgets: MyMemberBottomSheet.generateBottomSheet(context, _selectedGroupUUID)
        );
      },
    );
  }

  void addCustomProduct() {

  }
}