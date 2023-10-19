import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/home/MyBasicStructItem.dart';
import 'package:shopping_app/components/group/MyGroupItem.dart';
import 'package:shopping_app/objects/groups/MyGroup.dart';

import '../../functions/providers/floatingbutton/MyFloatingButtonProvider.dart';

class MyHomeList extends StatefulWidget {

  final List<MyGroup> myGroups;
  final Widget isListEmptyWidget;

  const MyHomeList({super.key, required this.myGroups, required this.isListEmptyWidget});

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
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if (widget.myGroups.isEmpty) {

      return Center(
        child: widget.isListEmptyWidget,
      );
    } else {

      return ListView.builder(
        itemCount: widget.myGroups.length,
        //TODO: Moritz: Hier muss noch der Builder flexibel gemacht werden
        controller: _controller,
        itemBuilder: (context, index) {
          return MyBasicStructItem(

            ///the basic struct of the group, product, ... elements
            content: MyGroupItem(
              myGroupItem: widget.myGroups[index],
            ),
          );
        },
      );
    }
  }
}
