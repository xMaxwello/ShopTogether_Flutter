import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/functions/others/MyFunctions.dart';

import '../../functions/providers/floatingbutton/MyFloatingButtonProvider.dart';

class MyFloatingButton extends StatefulWidget {

  final String buttonTitle;
  final IconData iconData;
  final bool isChangeByScroll;
  final Function() function;

  const MyFloatingButton({super.key, required this.buttonTitle, required this.iconData, required this.isChangeByScroll, required this.function});

  @override
  State<MyFloatingButton> createState() => _MyFloatingButtonState();
}

class _MyFloatingButtonState extends State<MyFloatingButton> {

  bool toggle = false;

  @override
  Widget build(BuildContext context) {



    return Consumer<MyFloatingButtonProvider>(
        builder: (BuildContext context,
            MyFloatingButtonProvider value,
            Widget? child) {

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 0),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeInOut,

            child: (value.isExtended == false) && widget.isChangeByScroll
                ?
            FloatingActionButton(
              key: const ValueKey<bool>(false),
              backgroundColor: Color.lerp(Colors.white, Theme
                  .of(context)
                  .colorScheme
                  .primary, 0.8),
              onPressed: widget.function,
              child: Icon(
                widget.iconData,
                color: Colors.white,
              ),
            )
                :
            FloatingActionButton.extended(
              key: const ValueKey<bool>(true),
              onPressed: widget.function,
              backgroundColor: Color.lerp(Colors.white, Theme
                  .of(context)
                  .colorScheme
                  .primary, 0.8),
              label: Text(
                widget.buttonTitle,
                style: const TextStyle(
                    color: Colors.white
                ),
              ),
              icon: Icon(
                widget.iconData,
                color: Colors.white,
              ),
            )

          );
        }
    );
  }
}

