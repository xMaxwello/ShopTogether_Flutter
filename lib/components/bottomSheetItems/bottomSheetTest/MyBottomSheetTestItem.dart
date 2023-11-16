import 'package:flutter/material.dart';

class MyBottomSheetTestItem {

  static List<Widget> generateBottomSheet() {

    return <Widget> [

      const SizedBox(
        height: 40,
      ),

      const Center(
        child: Text("Hallo"),
      ),

      Padding(
        padding: const EdgeInsets.only(left: 60, right: 60),
        child: ElevatedButton(
            onPressed: () {
              ///TODO: Entsprechend auslagern
            },
            child: const Text("Click Mich")
        ),
      ),

      for (int i = 0;i < 60;i++)
        Text("Hallo")

    ];
  }
}