import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as FireAuth;
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/home/MyListWidget.dart';
import 'package:shopping_app/functions/animations/MyScrollAnimation.dart';
import 'package:shopping_app/functions/home/MyHomeErrorWidgetHandler.dart';
import 'package:shopping_app/functions/providers/items/MyItemsProvider.dart';
import 'package:shopping_app/functions/providers/search/MySearchProvider.dart';
import 'package:shopping_app/functions/services/openfoodfacts/MyOpenFoodFactsService.dart';
import 'package:shopping_app/objects/groups/MyGroup.dart';
import '../../objects/users/MyUsers.dart';

/**
 * Its like the main class of the total project. Here changes every Product- , Group- , SearchItem
 * */
class MyHomeList extends StatefulWidget {

  final Widget isListEmptyWidget;

  const MyHomeList({super.key, required this.isListEmptyWidget});

  @override
  State<MyHomeList> createState() => _MyHomeListState();
}

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

            return Consumer<MySearchProvider>(
                builder: (BuildContext context, MySearchProvider mySearchProvider, Widget? child) {

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
                              FireAuth.User? fireUser = FireAuth.FirebaseAuth.instance.currentUser;
                              if (fireUser == null) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              MyUser? currentUser = users.where((MyUser user) => user.uuid == fireUser.uid).firstOrNull;
                              if (currentUser == null) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              ///get all groups
                              List<MyGroup> groups = groupsData!.docs.map(
                                      (userDoc) => MyGroup.fromMap(userDoc.data() as Map<String, dynamic>)).toList();

                              ///get groups from current user
                              List<MyGroup> groupsFromUser = groups.where((group) => currentUser.groupUUIDs.contains(group.groupUUID)).toList();
                              groupsFromUser.sort((a, b) => a.groupName.compareTo(b.groupName));

                              ///get index of selected group
                              if (itemsValue.selectedGroupUUID != "") {
                                selectedGroupIndex = groupsFromUser.indexWhere((MyGroup group) => group.groupUUID == itemsValue.selectedGroupUUID);
                              }

                              ///shows the MySearchItems for the search process
                              if (mySearchProvider.isSearching && !itemsValue.isGroup) {

                                return FutureBuilder<List<Product>>(
                                    future: MyOpenFoodFactsService().getProducts(mySearchProvider.searchedText, mySearchProvider.sizeOfSearchedProducts),
                                    builder: (BuildContext context, AsyncSnapshot<List<Product>> searchSnapshot) {

                                      if (searchSnapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      if (!searchSnapshot.hasData) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      return FutureBuilder<int>(
                                          future: MyOpenFoodFactsService().getMaximumProductSize([mySearchProvider.searchedText]),
                                          builder: (BuildContext context, AsyncSnapshot<int> sizeSnapshot) {

                                            if (sizeSnapshot.connectionState == ConnectionState.waiting) {
                                              return const Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }

                                            if (!sizeSnapshot.hasData) {
                                              return const Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }

                                            int itemLength = searchSnapshot.data!.length + 1; /// +1 => the MySearchForMoreProductsWidget

                                            return MyListWidget(
                                              maxSizeForSearch: sizeSnapshot.data!,
                                              itemLength: itemLength, controller: _controller,
                                              mySearchProvider: mySearchProvider, groupsFromUser: groupsFromUser,
                                              itemsValue: itemsValue,
                                              isSearch: true, isGroup: itemsValue.isGroup,
                                              selectedGroupIndex: selectedGroupIndex, searchSnapshot: searchSnapshot,
                                              searchedText: mySearchProvider.searchedText,
                                            );
                                          }
                                      );
                                    }
                                );
                              }

                              int itemLength = itemsValue.isGroup ?
                              groupsFromUser.length :
                              (selectedGroupIndex != -1 ? groupsFromUser[selectedGroupIndex].products.length : 0);

                              ///Error Handling for empty lists
                              Widget? emptyErrorWidget = myHomeErrorWidgetHandler.getEmptyErrorWidget(
                                  groupsFromUser,
                                  itemsValue.isGroup,
                                  selectedGroupIndex,
                                  widget.isListEmptyWidget
                              );
                              ///shows many errors and returns a widget
                              if (emptyErrorWidget != null) {
                                return emptyErrorWidget;
                              }

                              ///shows the ProductItems or the GroupItems
                              return MyListWidget(
                                  itemLength: itemLength, controller: _controller,
                                  mySearchProvider: mySearchProvider, groupsFromUser: groupsFromUser,
                                  itemsValue: itemsValue,
                                  isSearch: false, isGroup: itemsValue.isGroup,
                                  selectedGroupIndex: selectedGroupIndex
                              );
                            });
                      });
                }
            );
        });
  }
}