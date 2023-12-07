import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/memberRequest/MyInMemberRequestWidget.dart';
import 'package:shopping_app/functions/dialog/groupDialog/newGroupDialog.dart';
import 'package:shopping_app/functions/providers/group/MyGroupProvider.dart';
import 'package:shopping_app/functions/services/firestore/MyFirestoreService.dart';
import 'package:shopping_app/objects/requests/MyRequestGroup.dart';
import 'package:shopping_app/objects/requests/MyRequestKey.dart';

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

      Consumer<MyGroupProvider>(
          builder: (BuildContext context, MyGroupProvider myGroupProvider, Widget? child) {

            List<String> _enteredNumbers = [];

            return Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                groupItem(
                    context, () => newGroupDialog(context),
                    "Gruppe erstellen",
                    "Hier können Sie Ihre eigene \n Gruppe erstellen!"
                ),
                if (myGroupProvider.isShowWidget)
                  MyInMemberRequestWidget(
                      title: "Gruppe beitreten",
                      onNumbersEntered: (List<String> enteredNumbers) {
                        _enteredNumbers = enteredNumbers;
                      },
                      executeFunction: () async {

                        String joinedNumbers = _enteredNumbers.join('');
                        print(joinedNumbers);
                        int joinedNumbersAsInt = int.parse(joinedNumbers);
                        MyRequestGroup myRequestGroup = await MyFirestoreService.requestService.getInfosAboutSession(joinedNumbersAsInt);
                        print(myRequestGroup.sizeOfMembers);
                        ///TODO: Dialog
                        Provider.of<MyGroupProvider>(context, listen: false).updateShowWidget(false);
                      },
                  )
                else
                  groupItem(
                      context, () => Provider.of<MyGroupProvider>(context, listen: false).updateShowWidget(true),
                      "Gruppe beitreten",
                      "Treten Sie hier einer \nanderen Gruppe per Code bei!"
                  ),

              ],
            );
          }
      ),

    ];
  }
}

Widget groupItem(BuildContext context, Function() function, String title, String subtitle) {

  return Padding(
    padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
    child: GestureDetector(
      onTap: function,
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
                title,
                style: Theme.of(context).textTheme.labelMedium,
              ),

              Text(
                subtitle,
                style: Theme.of(context).textTheme.labelSmall,
              ),

            ],
          ),
        ),
      ),
    ),
  );
}