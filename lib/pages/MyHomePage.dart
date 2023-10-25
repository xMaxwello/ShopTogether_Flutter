import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/home/MyFloatingButton.dart';
import 'package:shopping_app/components/home/MyHomeList.dart';
import 'package:shopping_app/components/home/MyHomeNavigationBar.dart';
import 'package:shopping_app/components/settings/MySettingsWidget.dart';
import 'package:shopping_app/functions/providers/settings/MySettingsProvider.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ///get status bar height
    double height = MediaQuery.of(context).padding.top;

    return Consumer<MySettingsProvider>(
      builder: (context, mySettingsProvider, child) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.only(top: height),

            ///set the padding = status bar height
            child: mySettingsProvider.isSettingsPage
                ? const MySettingsWidget()
                : MyHomeList(
              isListEmptyWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text(
                    "Die Liste ist leer!",
                    style: GoogleFonts.tiltNeon(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: () {

                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.lerp(Colors.white, Theme
                              .of(context)
                              .colorScheme
                              .primary, 0.8)),
                      minimumSize: MaterialStateProperty.resolveWith<Size?>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return const Size(230, 42);
                          }
                          return const Size(180, 40);
                        },
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 5, bottom: 5),
                      child: Text(
                        "Gruppe Hinzufügen",
                        style: GoogleFonts.tiltNeon(
                            fontSize: 16,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.2),
            child: const MyHomeNavigationBar(),
          ),

          floatingActionButton: mySettingsProvider.isSettingsPage
              ? null
              : const MyFloatingButton(
            buttonTitle: 'Gruppe',
            iconData: Icons.group_add,
            isChangeByScroll: true,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        );
      },
    );
  }
}
