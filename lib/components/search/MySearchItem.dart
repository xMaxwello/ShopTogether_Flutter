import 'package:flutter/material.dart';

class MySearchItem extends StatelessWidget {

  final String s;

  const MySearchItem({super.key, required this.s});

  @override
  Widget build(BuildContext context) {
    return Text(s);
  }
}
