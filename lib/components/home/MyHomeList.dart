import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/home/MyBasicStructItem.dart';
import 'package:shopping_app/components/group/MyGroupItem.dart';
import 'package:shopping_app/components/product/MyProductItem.dart';
import 'package:shopping_app/components/search/MySearchBar.dart';
import 'package:shopping_app/functions/providers/items/MyItemsProvider.dart';
import 'package:shopping_app/objects/groups/MyGroup.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';

import '../../functions/providers/floatingbutton/MyFloatingButtonProvider.dart';
import '../../objects/users/MyUsers.dart';

class MyHomeList extends StatefulWidget {

  final Widget isListEmptyWidget;

  const MyHomeList({super.key, required this.isListEmptyWidget});

  @override
  State<MyHomeList> createState() => _MyHomeListState();
}

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

  int selectedGroupIndex = -1;

  @override
  Widget build(BuildContext context) {

    return Consumer<MyItemsProvider>(
        builder: (BuildContext context,
            MyItemsProvider value,
            Widget? child){

          return Column(
            children: [

              value.isGroup == false ?
              const MySearchBar()
                  :
              const SizedBox(),

              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("users").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotUsers) {

                    return StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("groups").snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotGroups) {

                          if (snapshotUsers.hasError || snapshotGroups.hasError) {
                            return const Expanded(
                              child: Text(
                                "Es ist ein Fehler aufgetreten, \nbitte kontaktieren Sie den Support!",
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                            );
                          }

                          if (snapshotUsers.connectionState == ConnectionState.waiting || snapshotGroups.connectionState == ConnectionState.waiting) {
                            return const Expanded(
                              child: CircularProgressIndicator(),
                            );
                          }

                          ///data has no errors and can be used
                          final userData = snapshotUsers.data;
                          final groupsData = snapshotGroups.data;

                          if (userData == null || groupsData == null) {
                            return Expanded(
                              child: widget.isListEmptyWidget,
                            );
                          }

                          ///get users
                          List<MyUser> users = userData.docs.map(
                                  (userDoc) => MyUser.fromMap(userDoc.data() as Map<String, dynamic>)).toList();

                          ///get current user
                          String uuid = FirebaseAuth.instance.currentUser!.uid;
                          MyUser? currentUser = users.where((MyUser user) => user.uuid == uuid).firstOrNull;

                          ///get all groups
                          List<MyGroup> groups = groupsData.docs.map(
                                  (userDoc) => MyGroup.fromMap(userDoc.data() as Map<String, dynamic>)).toList();

                          ///get groups from current user
                          List<MyGroup> groupsFromUser = groups.where((group) => currentUser!.groupUUIDs.contains(group.groupUUID)).toList();

                          ///get index of selected group
                          if (value.selectedGroupUUID != "") {
                            selectedGroupIndex = groupsFromUser.indexWhere((MyGroup group) => group.groupUUID == value.selectedGroupUUID);
                          }

                          ///if there no groups
                          if (groupsFromUser.isEmpty && (value.isGroup || selectedGroupIndex != -1)) {
                            return Expanded(
                              child: Center(
                                child: widget.isListEmptyWidget,
                              ),
                            );
                          }

                          ///if there no products in group
                          if (!value.isGroup && selectedGroupIndex != -1 && groupsFromUser.elementAt(selectedGroupIndex).products.isEmpty) {
                            return Expanded(
                              child: Center(
                                child: widget.isListEmptyWidget,
                              ),
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: value.isGroup ?
                            groupsFromUser.length :
                            (selectedGroupIndex != -1 ? groupsFromUser[selectedGroupIndex].products.length : 0),

                            controller: _controller,
                            itemBuilder: (context, index) {

                              return MyBasicStructItem(///the basic struct of the group, product, ... elements
                                  selectedUUID: currentUser!.groupUUIDs[index],
                                  content:
                                  value.isGroup == true ?
                                  MyGroupItem(///shows all groups of current user
                                      myGroup: groupsFromUser.elementAt(index)
                                  )
                                      :
                                  MyProductItem(///shows products of selected group from current user
                                      myProduct: selectedGroupIndex != -1 ? groupsFromUser.elementAt(selectedGroupIndex).products[index] : MyProduct(productID: "", productName: "", selectedUserUUID: "", productCount: 0, productImageUrl: "")
                                  )
                              );
                            },
                          );
                        });
                  })
            ],
          );
    });
  }
}