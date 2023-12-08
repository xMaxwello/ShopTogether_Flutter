import 'package:flutter/material.dart';
import 'package:shopping_app/exceptions/MyCustomException.dart';
import 'package:shopping_app/functions/dialog/MyDialog.dart';
import 'package:shopping_app/functions/services/firestore/MyFirestoreService.dart';
import 'package:shopping_app/functions/services/snackbars/MySnackBarService.dart';
import 'package:shopping_app/objects/groups/MyGroup.dart';

void newGroupDialog(BuildContext context) {
  final TextEditingController groupNameController = TextEditingController();

  MyDialog.showCustomDialog(
    context: context,
    title: 'Neue Gruppe erstellen',
    contentBuilder: (dialogContext) => [
      TextField(
        controller: groupNameController,
        decoration: InputDecoration(
          hintText: 'Gruppenname',
          hintStyle: Theme.of(dialogContext).textTheme.labelMedium,
          labelStyle: Theme.of(dialogContext).textTheme.labelMedium,
        ),
        style: Theme.of(dialogContext).textTheme.bodyMedium,
      ),
    ],

  onConfirm: () async {
    final String groupName = groupNameController.text;
    if (groupName.isNotEmpty) {
      try {
        MyFirestoreService.groupService.addGroup(
          MyGroup(
            groupName: groupName,
            products: [],
          ),
        );
        Navigator.of(context).pop();
      } on MyCustomException catch(e) {
        switch(e.keyword) {
          case "snapchot-not-exists":
          //print(e.message);
            break;
          case "error":
            print(e.message);
            break;
          case "no-user":
            print(e.message);
            break;
        }
      }
    } else {
      MySnackBarService.showMySnackBar(context, "Bitte geben Sie einen Gruppennamen ein.", isError: true);
    }
  },
  );
}