import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/functions/providers/login/MyLoginProvider.dart';

class MyLoginWidget extends StatelessWidget {

  final String title;
  final List<Function()> buttonFunctions;
  final List<TextEditingController> controllers;
  final List<String> inputLabels;
  final List<String> buttonLabels;
  final List<Color> buttonForegroundColors;
  final List<Color> buttonBackgroundColors;
  final List<bool> isInputPassword;

  const MyLoginWidget({super.key, required this.buttonFunctions, required this.controllers, required this.inputLabels, required this.buttonLabels, required this.buttonForegroundColors, required this.buttonBackgroundColors, required this.isInputPassword, required this.title});

  @override
  Widget build(BuildContext context) {


    return Consumer<MyLoginProvider>(
        builder: (BuildContext context,
            MyLoginProvider value,
            Widget? child) {

          return Card(
            color: Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.08),
            elevation: 20,
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.only(right: 25, left: 25, top: 25, bottom: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text(
                      title,
                    style: GoogleFonts.tiltNeon(
                      fontSize: 24
                    ),
                  ),

                  for (int i = 0; i<controllers.length;i++)
                    TextFormField(
                      controller: controllers[i],
                      decoration: InputDecoration(labelText: inputLabels[i]),
                      obscureText: isInputPassword[i],
                    ),
                  const SizedBox(height: 30),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      for (int i = 0;i < buttonLabels.length;i++)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            ElevatedButton(
                                onPressed: buttonFunctions[i],
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(buttonBackgroundColors[i]),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                  child: Text(
                                    buttonLabels[i],
                                    style: GoogleFonts.tiltNeon(
                                        fontSize: 19,
                                        color: buttonForegroundColors[i]
                                    ),
                                  ),
                                )
                            ),
                            const SizedBox(height: 2,),

                          ],
                        )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
