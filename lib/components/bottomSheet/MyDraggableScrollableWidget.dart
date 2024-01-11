import 'package:flutter/material.dart';

/**
 * Its the BottomSheet Layout
 * */
class MyDraggableScrollableWidget extends StatefulWidget {
  
  final List<Widget> widgets;
  
  const MyDraggableScrollableWidget({super.key, required this.widgets});

  @override
  State<MyDraggableScrollableWidget> createState() => _MyDraggableScrollableWidgetState();
}

class _MyDraggableScrollableWidgetState extends State<MyDraggableScrollableWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints boxConstraints) {
          return Container(
            color: Theme.of(context).colorScheme.background,
            child: DraggableScrollableSheet(
                initialChildSize: 0.95,
                maxChildSize: 1.0,
                minChildSize: 0.0,
                builder: (BuildContext context, ScrollController scrollController) {

                  return Column(
                    children: [

                      Divider(
                        color: Theme.of(context).dividerTheme.color,
                        indent: MediaQuery.of(context).size.width * 0.4,
                        endIndent: MediaQuery.of(context).size.width * 0.4,
                        thickness: 5,
                      ),

                      Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: [

                              for (int i = 0; i<widget.widgets.length;i++)
                                widget.widgets.elementAt(i)

                            ],
                          )
                      ),

                    ],
                  );
                }
            ),
          );
        }
    );
  }
}
