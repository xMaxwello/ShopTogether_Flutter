import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/functions/providers/navigationBar/MyNavigationBarProvider.dart';
import 'package:shopping_app/pages/MyHomePage.dart';

import '../../functions/providers/items/MyItemsProvider.dart';
import '../../pages/MySettingsPage.dart';

class MyHomeNavigationBar extends StatefulWidget {

  const MyHomeNavigationBar({super.key});

  @override
  State<MyHomeNavigationBar> createState() => _MyHomeNavigationBarState();
}

class _MyHomeNavigationBarState extends State<MyHomeNavigationBar> {

  @override
  Widget build(BuildContext context) {

    List<IconData> icons = [Icons.group,Icons.settings];
    List<String> titles = ["Gruppen","Einstellungen"];

    return Consumer<MyNavigationBarProvider>(
        builder: (BuildContext context,
        MyNavigationBarProvider value,
        Widget? child) {

          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              for (int iconView = 0;iconView < icons.length; iconView++)
                Row(
                  children: [

                    GestureDetector(
                        onTap: () {
                          setState(() {

                            bool allFalse = value.isNavigationSelected.every((element) => element == false);

                            if (allFalse) {
                              value.isNavigationSelected[iconView] = true;
                            } else {
                              for (int y = 0; y < value.isNavigationSelected.length; y++) {
                                value.isNavigationSelected[y] = false;
                              }
                              value.isNavigationSelected[iconView] = !value.isNavigationSelected[iconView];
                            }

                            Provider.of<MyNavigationBarProvider>(context, listen: false).updateNavigationSelected(value.isNavigationSelected);

                            //Switch statement to switch between different Views by pressing
                            // on the corresponding Icon on the BottomBar
                            switch(iconView) {
                              case 0: //Shows Homepage
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
                                break;
                              case 1: //Shows SettingsPage
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const MySettingsPage()));
                                break;
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: value.isNavigationSelected[iconView] == true ?
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Icon(
                                icons[iconView],
                                size: Theme.of(context).iconTheme.size! + 2,
                                color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
                              ),
                              Text(
                                titles[iconView],
                                style: Theme.of(context).textTheme.bodySmall,
                              )

                            ],
                          )
                              :
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Icon(
                                icons[iconView],
                                size: Theme.of(context).iconTheme.size,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              Text(
                                titles[iconView],
                                style: Theme.of(context).textTheme.bodySmall,
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
