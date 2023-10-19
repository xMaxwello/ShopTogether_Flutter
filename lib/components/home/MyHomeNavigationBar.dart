import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/functions/providers/navigationBar/MyNavigationBarProvider.dart';

class MyHomeNavigationBar extends StatefulWidget {

  const MyHomeNavigationBar({super.key});

  @override
  State<MyHomeNavigationBar> createState() => _MyHomeNavigationBarState();
}

class _MyHomeNavigationBarState extends State<MyHomeNavigationBar> {
  @override
  Widget build(BuildContext context) {

    List<IconData> icons = [Icons.home,Icons.settings];
    List<String> titles = ["Home","Settings"];

    return Consumer<MyNavigationBarProvider>(
        builder: (BuildContext context,
        MyNavigationBarProvider value,
        Widget? child) {

          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              for (int i = 0;i < icons.length; i++)
                Row(
                  children: [

                    GestureDetector(
                        onTap: () {
                          setState(() {

                            bool allFalse = value.isNavigationSelected.every((element) => element == false);

                            if (allFalse) {
                              value.isNavigationSelected[i] = true;
                            } else {
                              for (int y = 0; y < value.isNavigationSelected.length; y++) {
                                value.isNavigationSelected[y] = false;
                              }
                              value.isNavigationSelected[i] = !value.isNavigationSelected[i];
                            }

                            Provider.of<MyNavigationBarProvider>(context, listen: false).updateNavigationSelected(value.isNavigationSelected);

                            ///TODO: LUKAS: Hier müssen noch die einzelnen Verlinkung zu den Seiten hin + Du müsstest dann noch eine neue Seite erstellen
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: value.isNavigationSelected[i] == true ?
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Icon(
                                icons[i],
                                size: 28,
                                color: Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.8),
                              ),
                              Text(
                                  titles[i]
                              )

                            ],
                          )
                              :
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Icon(
                                icons[i],
                                size: 25,
                              ),
                              Text(
                                  titles[i]
                              )

                            ],
                          ),
                        )
                    ),

                    const SizedBox(width: 14,),

                  ],
                ),

            ],
          );
        }
    );
  }
}
