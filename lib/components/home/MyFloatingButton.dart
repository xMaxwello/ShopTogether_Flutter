import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

            ///if the user scrolls then the floating action button shalln't be extended, otherwise it shall be extended
            child: (value.isExtended == false) && widget.isChangeByScroll
                ?
            FloatingActionButton(
              key: const ValueKey<bool>(false),
              backgroundColor: Theme
                  .of(context).floatingActionButtonTheme.backgroundColor,
              onPressed: widget.function,
              child: Icon(
                widget.iconData,
                color: Theme
                    .of(context).floatingActionButtonTheme.foregroundColor,
                size: Theme
                    .of(context).floatingActionButtonTheme.iconSize,
              ),
            )
                :
            FloatingActionButton.extended(
              key: const ValueKey<bool>(true),
              onPressed: widget.function,
              backgroundColor: Theme
                  .of(context).floatingActionButtonTheme.backgroundColor,
              label: Text(
                widget.buttonTitle,
                style: Theme
                    .of(context).floatingActionButtonTheme.extendedTextStyle,
              ),
              icon: Icon(
                widget.iconData,
                color: Theme
                    .of(context).floatingActionButtonTheme.foregroundColor,
                size: Theme
                    .of(context).floatingActionButtonTheme.iconSize,
              ),
            )

          );
        }
    );
  }
}