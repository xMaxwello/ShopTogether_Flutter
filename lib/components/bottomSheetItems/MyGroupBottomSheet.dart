import 'package:flutter/material.dart';
import 'package:shopping_app/functions/dialog/groupDialog/newGroupDialog.dart';



class MyGroupBottomSheet {

  static List<Widget> generateBottomSheet(BuildContext context) {

    List<String> titles = ["Gruppe erstellen", "Gruppe beitreten"];
    List<String> subtitles = ["Hier können Sie Ihre eigene \n Gruppe erstellen!", "Treten Sie hier einer \nanderen Gruppe per Code bei!"];
    List<Function()> functions = [() => newGroupDialog, () => {}];

    return [

      const SizedBox(height: 10,),
      Center(
        child: Text(
          "Gruppe",
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),

      const SizedBox(height: 20,),

      for (int i = 0;i < titles.length;i++)
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
          child: GestureDetector(
            onTap: functions.elementAt(i),
            child: Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 10, top: 15, bottom: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      titles.elementAt(i),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),

                    Text(
                      subtitles.elementAt(i),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),

    ];
  }
}