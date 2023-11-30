import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/home/MyBasicStructItem.dart';
import 'package:shopping_app/components/group/MyGroupItem.dart';
import 'package:shopping_app/components/product/MyProductItem.dart';
import 'package:shopping_app/functions/services/firestore/MyFirestoreService.dart';
import 'package:shopping_app/functions/providers/items/MyItemsProvider.dart';
import 'package:shopping_app/objects/groups/MyGroup.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';
import 'package:shopping_app/pages/MyProductPage.dart';

import '../../functions/providers/floatingbutton/MyFloatingButtonProvider.dart';
import '../../objects/users/MyUsers.dart';

class MyHomeList extends StatefulWidget {

  final Widget isListEmptyWidget;
  final bool isGroup;

  const MyHomeList({super.key, required this.isListEmptyWidget, required this.isGroup});

  @override
  State<MyHomeList> createState() => _MyHomeListState();
}

///TODO: Datei auslagern => übersichtlicher machen

class _MyHomeListState extends State<MyHomeList> {

  late ScrollController _controller;
  late double actualScrollPosition = 0;

  ///FloatingActionButton ScrollAnimation
  void _scrollListener() {

    double activateChange = 30;
    final actualOffset = _controller.offset;

    if (actualOffset < (actualScrollPosition - activateChange)) {
      Provider.of<MyFloatingButtonProvider>(context, listen: false).updateExtended(true);
    } else if (actualOffset > (actualScrollPosition + 10)) {
      Provider.of<MyFloatingButtonProvider>(context, listen: false).updateExtended(false);
    }

    if ((actualOffset - actualScrollPosition).abs() >= activateChange) {
      actualScrollPosition = actualOffset;
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  ///saves the selected index of the group
  int selectedGroupIndex = -1;

  @override
  Widget build(BuildContext context) {

    return Consumer<MyItemsProvider>(
        builder: (BuildContext context,
            MyItemsProvider itemsValue,
            Widget? child) {

            return StreamBuilder(
                stream: FirebaseFirestore.instance.collection("users").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotUsers) {

                  return StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("groups").snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotGroups) {

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

                        ///data has no errors and can be used
                        final userData = snapshotUsers.data;
                        final groupsData = snapshotGroups.data;

                        if (userData == null || groupsData == null) {
                          return Center(
                            child: widget.isListEmptyWidget,
                          );
                        }

                        ///get users
                        List<MyUser> users = userData.docs.map(
                                (userDoc) => MyUser.fromMap(userDoc.data() as Map<String, dynamic>)).toList();

                        ///get current user

                        User? fireUser = FirebaseAuth.instance.currentUser;
                        if (fireUser == null) {
                          return const CircularProgressIndicator();
                        }

                        MyUser? currentUser = users.where((MyUser user) => user.uuid == fireUser.uid).firstOrNull;
                        if (currentUser == null) {
                          return const CircularProgressIndicator();
                        }

                        ///get all groups
                        List<MyGroup> groups = groupsData.docs.map(
                                (userDoc) => MyGroup.fromMap(userDoc.data() as Map<String, dynamic>)).toList();

                        ///get groups from current user
                        List<MyGroup> groupsFromUser = groups.where((group) => currentUser.groupUUIDs.contains(group.groupUUID)).toList();

                        groupsFromUser.sort((a, b) => a.groupUUID.compareTo(b.groupUUID));

                        List<String> groupUUIDs = currentUser.groupUUIDs;
                        groupUUIDs.sort((a, b) => a.compareTo(b));

                        ///get index of selected group
                        if (itemsValue.selectedGroupUUID != "") {
                          selectedGroupIndex = groupsFromUser.indexWhere((MyGroup group) => group.groupUUID == itemsValue.selectedGroupUUID);
                        }

                        ///if there no groups
                        if (groupsFromUser.isEmpty && (widget.isGroup || selectedGroupIndex != -1)) {
                          return Center(
                            child: widget.isListEmptyWidget,
                          );
                        }

                        ///if there no products in group
                        if (!widget.isGroup && selectedGroupIndex != -1 && groupsFromUser.elementAt(selectedGroupIndex).products.isEmpty) {
                          return Center(
                            child: widget.isListEmptyWidget,
                          );
                        }

                        int itemLength = widget.isGroup ?
                        groupsFromUser.length :
                        (selectedGroupIndex != -1 ? groupsFromUser[selectedGroupIndex].products.length : 0);

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: itemLength,

                          controller: _controller,
                          itemBuilder: (context, index) {

                            return Dismissible(
                                key: widget.isGroup ? Key(groupsFromUser[index].groupUUID) : Key(groupsFromUser[selectedGroupIndex].products[index].productID),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red[300],
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                onDismissed: (direction) {
                                  setState(() {

                                    ///TODO: User darf nur Gruppe löschen, wenn dieser der Owner ist

                                    ///TODO: Abfrage ob der User die Gruppe löschen möchte
                                    ///remove group or product if the item is swiped
                                    if (widget.isGroup) {
                                      MyFirestoreService.groupService.removeGroup(groupsFromUser[index].groupUUID);
                                    } else {
                                      MyFirestoreService.productService.removeProductFromGroup(itemsValue.selectedGroupUUID, groupsFromUser[selectedGroupIndex].products[index].productID);
                                    }
                                  });
                                },
                                child: MyBasicStructItem(///the basic struct of the group, product, ... elements ///TODO: Bottomsheet
                                  onTapFunction: () {

                                    if (widget.isGroup) {

                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const MyProductPage()));
                                    }
                                    Provider.of<MyItemsProvider>(context, listen: false).updateItemIndex(widget.isGroup ? groupUUIDs[index] : itemsValue.selectedGroupUUID);
                                    Provider.of<MyFloatingButtonProvider>(context, listen: false).updateExtended(true);
                                  },
                                    content:
                                    widget.isGroup == true ?
                                    MyGroupItem(///shows all groups of current user
                                        myGroup: groupsFromUser.elementAt(index)
                                    )
                                        :
                                    MyProductItem(///shows products of selected group from current user
                                      myProduct: selectedGroupIndex != -1 ? groupsFromUser.elementAt(selectedGroupIndex).products[index] : MyProduct(productID: "", productName: "", selectedUserUUID: "", productCount: 0, productVolumen: 0, productVolumenType: '', productImageUrl: ""),
                                      selectedGroupUUID: itemsValue.selectedGroupUUID,
                                    ),
                                ),
                            );
                          },
                        );
                      });
                });
        });
  }
}