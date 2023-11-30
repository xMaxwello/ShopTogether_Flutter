import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../objects/groups/MyGroup.dart';

class MyHomeErrorWidgetHandler {

  Widget? getStreamErrorWidget(AsyncSnapshot<QuerySnapshot> snapshotUsers, AsyncSnapshot<QuerySnapshot> snapshotGroups, QuerySnapshot<Object?>? userData, QuerySnapshot<Object?>? groupsData, Widget isListEmptyWidget) {

    if (snapshotUsers.hasError || snapshotGroups.hasError) {
      return const Center(
        child: Text(
          "Es ist ein Fehler aufgetreten, \nbitte kontaktieren Sie den Support!",
          softWrap: true,
          textAlign: TextAlign.center,
        ),
      );
    }

    if (snapshotUsers.connectionState == ConnectionState.waiting || snapshotGroups.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (userData == null || groupsData == null) {
      return Center(
        child: isListEmptyWidget,
      );
    }

    return null;
  }

  Widget? getEmptyErrorWidget(List<MyGroup> groupsFromUser, bool isGroup, int selectedGroupIndex, Widget isListEmptyWidget) {

    ///if there no groups
    if (groupsFromUser.isEmpty && (isGroup || selectedGroupIndex != -1)) {
      return Center(
        child: isListEmptyWidget,
      );
    }

    ///if there no products in group
    if (!isGroup && selectedGroupIndex != -1 && groupsFromUser.elementAt(selectedGroupIndex).products.isEmpty) {
      return Center(
        child: isListEmptyWidget,
      );
    }

    return null;
  }
}