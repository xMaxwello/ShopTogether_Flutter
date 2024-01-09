import 'package:flutter/material.dart';
import 'package:shopping_app/functions/services/clipBoard/MyClipBoardService.dart';
import 'package:shopping_app/functions/services/firestore/MyFirestoreService.dart';

/**
 * This widget shows the user the created request code. So that a other person join this group
 * */
class MyOutMemberRequestWidget extends StatelessWidget {

  final String title;
  final String requestCode;

  MyOutMemberRequestWidget({Key? key, required this.requestCode, required this.title}) : super(key: key) {
    _validateLength();
  }

  void _validateLength() {
    if (requestCode.length != 6) {
      throw ArgumentError('Der requestCode muss 6 Zeichen lang sein.');
    }
  }

  @override
  Widget build(BuildContext context) {

    List<int> requestCodeList = [];
    for (var s in requestCode.characters) {
      requestCodeList.add(int.parse(s));
    }

    List<IconData> icons = [Icons.copy, Icons.close];
    List<Function()> functions = [
      () => MyClipBoardService.copyToClipboard(requestCode),
      () {
        MyFirestoreService.requestService.removeRequestWithCode(int.parse(requestCode));
      }
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 15,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  for (int i = 0;i < requestCodeList.length;i++)
                    Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Color.lerp(Colors.white, Theme.of(context).primaryColor, 0.5),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            requestCodeList.elementAt(i).toString(),
                            style: TextStyle(
                              fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                              color: Colors.white
                            ),
                          ),
                        )
                    ),

                ],
              ),

              const SizedBox(height: 15,),


              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  for (int i = 0;i < icons.length;i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: FloatingActionButton.extended(
                            onPressed: functions.elementAt(i),
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Theme.of(context).floatingActionButtonTheme.foregroundColor,
                            label: Icon(
                              icons.elementAt(i),
                              size: Theme.of(context).floatingActionButtonTheme.iconSize! * 0.8,
                            )
                        ),
                      ),
                    ),

                ],
              )

            ],
          )
        ),
      ),
    );
  }
}