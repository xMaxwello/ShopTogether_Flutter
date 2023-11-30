import 'package:flutter/material.dart';
import 'package:shopping_app/functions/services/clipBoard/MyClipBoardService.dart';

class MyOutMemberRequestWidget extends StatelessWidget {

  final String title;
  String requestCode;

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
                        color: Theme.of(context).primaryColor,
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

              SizedBox(
                height: 50,
                width: 50,
                child: FloatingActionButton.extended(
                    onPressed: () {
                      MyClipBoardService.copyToClipboard(requestCode);
                    },
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Theme.of(context).floatingActionButtonTheme.foregroundColor,
                    label: Icon(
                      Icons.copy,
                      size: Theme.of(context).floatingActionButtonTheme.iconSize! * 0.8,
                    )
                ),
              ),

            ],
          )
        ),
      ),
    );
  }
}