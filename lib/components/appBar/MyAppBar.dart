import 'package:flutter/material.dart';
import '../search/MySearchBar.dart';

class MyAppBar extends StatefulWidget {

  final bool isGroup;

  const MyAppBar({super.key, required this.isGroup});

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {

    if (widget.isGroup) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 10),
        child: Column(
            children: [

              const SizedBox(
                height: 60,
              ),

              Text(
                  "Einkaufsapp",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge
              ),

            ]
        ),
      );
    }

    return const Padding(
      padding: EdgeInsets.only(bottom: 10, top: 10),
      child: Column(
        children: [

          SizedBox(
            height: 40,
          ),

          ///the search bar for the products
          MySearchBar(),

        ],
      ),
    );
  }
}
