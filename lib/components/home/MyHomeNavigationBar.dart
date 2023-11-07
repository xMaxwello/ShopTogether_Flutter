import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/functions/providers/items/MyItemsProvider.dart';
import 'package:shopping_app/functions/providers/navigationBar/MyNavigationBarProvider.dart';
import 'package:shopping_app/functions/providers/settings/MySettingsProvider.dart';

class MyHomeNavigationBar extends StatefulWidget {

  const MyHomeNavigationBar({super.key});

  @override
  State<MyHomeNavigationBar> createState() => _MyHomeNavigationBarState();
}

class _MyHomeNavigationBarState extends State<MyHomeNavigationBar> {

  @override
  void initState() {
    super.initState();
  }

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
                                Provider.of<MySettingsProvider>(context, listen: false).updateIsSettingsPage(false);
                                Provider.of<MyItemsProvider>(context, listen: false).updateIsGroup(true);
                                break;
                              case 1: //Shows SettingsPage
                                Provider.of<MySettingsProvider>(context, listen: false).updateIsSettingsPage(true);
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
                                size: 28,
                                color: Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.8),
                              ),
                              Text(
                                  titles[iconView]
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
                                size: 25,
                              ),
                              Text(
                                  titles[iconView]
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
