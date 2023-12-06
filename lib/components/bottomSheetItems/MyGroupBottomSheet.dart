import 'package:flutter/material.dart';
import 'package:shopping_app/functions/dialog/groupDialog/newGroupDialog.dart';



class MyGroupBottomSheet {

  static List<Widget> generateBottomSheet(BuildContext context) {

    return [

      const SizedBox(height: 10,),
      Center(
        child: Text(
          "Gruppe",
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),

      const SizedBox(height: 20,),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Gruppe erstellen',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Hier können Sie Ihre eigene \n Gruppe erstellen',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
          onPressed: () async {

            newGroupDialog(context);

          },
        ),
      ),
      const SizedBox(height: 10,),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Gruppe beitreten',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Geben Sie Ihren Einladungscode \n ein und treten Sie einer \n anderen Gruppe bei',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
          onPressed: () async {



          },
        ),
      ),
    ];
  }
}