import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/dismissible/MyDismissibleWidget.dart';
import 'package:shopping_app/components/home/MyBasicStructItem.dart';
import 'package:shopping_app/components/group/MyGroupItem.dart';
import 'package:shopping_app/components/product/MyProductItem.dart';
import 'package:shopping_app/functions/animations/MyScrollAnimation.dart';
import 'package:shopping_app/functions/home/MyHomeErrorWidgetHandler.dart';
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

  late MyScrollAnimation myScrollAnimation;
  late ScrollController _controller;
  late double actualScrollPosition = 0;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();
    myScrollAnimation = MyScrollAnimation(context, _controller, actualScrollPosition);
    _controller.addListener(myScrollAnimation.scrollListener);
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

                        MyHomeErrorWidgetHandler myHomeErrorWidgetHandler = MyHomeErrorWidgetHandler();

                        ///data has no errors and can be used
                        final userData = snapshotUsers.data;
                        final groupsData = snapshotGroups.data;

                        ///Error Handling for null variables
                        Widget? streamErrorWidget = myHomeErrorWidgetHandler.getStreamErrorWidget(
                            snapshotUsers,
                            snapshotGroups,
                            userData,
                            groupsData,
                            widget.isListEmptyWidget
                        );

                        if (streamErrorWidget != null) {
                          return streamErrorWidget;
                        }

                        ///get users
                        List<MyUser> users = userData!.docs.map(
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
                        List<MyGroup> groups = groupsData!.docs.map(
                                (userDoc) => MyGroup.fromMap(userDoc.data() as Map<String, dynamic>)).toList();

                        ///get groups from current user
                        List<MyGroup> groupsFromUser = groups.where((group) => currentUser.groupUUIDs.contains(group.groupUUID)).toList();
                        groupsFromUser.sort((a, b) => a.groupUUID!.compareTo(b.groupUUID!));

                        List<String> groupUUIDs = currentUser.groupUUIDs;
                        groupUUIDs.sort((a, b) => a.compareTo(b));

                        ///get index of selected group
                        if (itemsValue.selectedGroupUUID != "") {
                          selectedGroupIndex = groupsFromUser.indexWhere((MyGroup group) => group.groupUUID == itemsValue.selectedGroupUUID);
                        }

                        ///Error Handling for empty lists
                        Widget? emptyErrorWidget = myHomeErrorWidgetHandler.getEmptyErrorWidget(
                            groupsFromUser,
                            widget.isGroup,
                            selectedGroupIndex,
                            widget.isListEmptyWidget
                        );
                        if (emptyErrorWidget != null) {
                          return emptyErrorWidget;
                        }

                        int itemLength = widget.isGroup ?
                        groupsFromUser.length :
                        (selectedGroupIndex != -1 ? groupsFromUser[selectedGroupIndex].products.length : 0);

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: itemLength,
                          controller: _controller,
                          itemBuilder: (context, index) {

                            return MyDismissibleWidget(
                                isGroup: widget.isGroup,
                                groupsFromUser: groupsFromUser,
                                itemIndex: index,
                                selectedGroupIndex: selectedGroupIndex,
                                itemsValue: itemsValue,
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