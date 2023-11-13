import 'package:flutter/material.dart';

class MyBasicStructItem extends StatelessWidget {

  final Widget content;
  final Function() onTapFunction;

  const MyBasicStructItem({super.key, required this.content, required this.onTapFunction});

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        Container(
          margin: const EdgeInsets.only(left: 6, right: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

            GestureDetector(
                onTap: onTapFunction,
              child:
                  Card(
                    color: Theme.of(context).cardTheme.color,
                    shadowColor: Theme.of(context).cardTheme.shadowColor,
                    elevation: Theme.of(context).cardTheme.elevation,
                    child: Container(
                        decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: Theme.of(context).colorScheme.primary, width: 10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                        child: content,
                      ),
                    ),
                ),
              ),
              const SizedBox(height: 4,)

            ],
          )
        ),

      ],
    );
  }
}
