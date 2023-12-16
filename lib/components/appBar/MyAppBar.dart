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

    return Padding(
      padding: const EdgeInsets.only(top: 60, bottom: 10),
      child: widget.isGroup ?
      Text(
          "ShopTogether",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge
      )
          :
      ///the search bar for the products
      const MySearchBar(),
    );
  }
}
