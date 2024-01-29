import 'package:flutter/material.dart';

/**
 * Its the BottomSheet Layout
 * */

class MyDraggableScrollableWidget extends StatelessWidget {

  final List<Widget> widgets;

  const MyDraggableScrollableWidget({super.key, required this.widgets});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.95,
        maxChildSize: 1.0,
        minChildSize: 0.0,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {

          return ListView.builder(
            key: UniqueKey(),
            controller: scrollController,
            itemCount: widgets.length,
            itemBuilder: (BuildContext context, int index) {
              return widgets.elementAt(index);
            },
          );
        }
    );
  }
}


/*
LayoutBuilder(
        builder: (BuildContext context, BoxConstraints boxConstraints) {
          return Container(
            color: Theme.of(context).colorScheme.background,
            child: DraggableScrollableSheet(
                initialChildSize: 0.95,
                maxChildSize: 1.0,
                minChildSize: 0.0,
                builder: (BuildContext context, ScrollController scrollController) {

                  return ListView.builder(
                    key: UniqueKey(),
                    controller: scrollController,
                    itemCount: widget.widgets.length,
                    itemBuilder: (BuildContext context, int index) {
                      return widget.widgets.elementAt(index);
                    },
                  );
                }
            ),
          );
        }
    );
* */

/*
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      Divider(
                        color: Theme.of(context).dividerTheme.color,
                        indent: MediaQuery.of(context).size.width * 0.4,
                        endIndent: MediaQuery.of(context).size.width * 0.4,
                        thickness: 5,
                      ),

                      Expanded(
                        child: ListView.builder(
                        shrinkWrap: true,
                        key: UniqueKey(),
                        //controller: scrollController,
                        itemCount: widget.widgets.length,
                        itemBuilder: (BuildContext context, int index) {
                          return widget.widgets.elementAt(index);
                        },
                      ),
                      )

                    ],
                  );*/