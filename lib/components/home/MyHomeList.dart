import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/home/MyBasicStructItem.dart';
import 'package:shopping_app/components/group/MyGroupItem.dart';
import 'package:shopping_app/components/product/MyProductItem.dart';
import 'package:shopping_app/functions/providers/items/MyItemsProvider.dart';
import 'package:shopping_app/objects/groups/MyGroup.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';

import '../../functions/providers/floatingbutton/MyFloatingButtonProvider.dart';

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

  @override
  Widget build(BuildContext context) {

    return Consumer<MyItemsProvider>(
        builder: (BuildContext context,
            MyItemsProvider value,
            Widget? child){

          Stream<QuerySnapshot<Map<String, dynamic>>> getTable = value.isGroup ?
          FirebaseFirestore.instance.collection("groups").snapshots() :
          FirebaseFirestore.instance.collection("users").snapshots();

      return StreamBuilder(
          stream: getTable,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "Es ist ein Fehler aufgetreten, \nbitte kontaktieren Sie den Support!",
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Hier kannst du auf die Firestore-Daten zugreifen
            final data = snapshot.data;

            if (data == null || data.docs.isEmpty) {
              return Center(
                child: widget.isListEmptyWidget,
              );
            }

            return ListView.builder(
              itemCount: data.docs.length,
              controller: _controller,
              itemBuilder: (context, index) {

                return MyBasicStructItem(///the basic struct of the group, product, ... elements

                    content:
                    value.isGroup == true ?
                    MyGroupItem(
                      myGroup: MyGroup.fromQuery(data.docs.elementAt(index))
                    )
                        :
                    MyProductItem(
                      myProduct: MyProduct.fromQuery(data.docs.elementAt(index))
                    )

                );
              },
            );
          }

      );
    });

    /*
    return Consumer<MyItemsProvider>(
        builder: (BuildContext context,
            MyItemsProvider value,
            Widget? child){

          if (value.elements.isEmpty) {

            return Center(
              child: widget.isListEmptyWidget,
            );
          } else {

            return ListView.builder(
              itemCount: value.elements.length,
              controller: _controller,
              itemBuilder: (context, index) {
                return MyBasicStructItem(///the basic struct of the group, product, ... elements

                    content:
                    value.isGroup == true ?
                    MyGroupItem(
                      myGroupItem: value.elements[index],
                    )
                        :
                    MyProductItem(
                      myProduct: value.elements[index],
                    )

                );
              },
            );
          }
        }
    );
    * */
  }
}