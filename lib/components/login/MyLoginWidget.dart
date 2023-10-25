import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/functions/providers/login/MyLoginProvider.dart';

class MyLoginWidget extends StatefulWidget {
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
  State<MyLoginWidget> createState() => _MyLoginWidgetState();
}

class _MyLoginWidgetState extends State<MyLoginWidget> {

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
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text(
                    widget.title,
                    style: GoogleFonts.tiltNeon(
                        fontSize: 24
                    ),
                  ),

                  for (int i = 0; i<widget.controllers.length;i++)
                    TextFormField(
                      controller: widget.controllers[i],
                      decoration: InputDecoration(
                        labelText: widget.inputLabels[i],
                        suffixIcon: IconButton(
                          onPressed: () {

                            if (widget.isInputPassword[i]) {

                               setState(() {
                                 value.showPasswords[i] = !value.showPasswords[i];
                                 Provider.of<MyLoginProvider>(context, listen: false).updateShowPasswords(value.showPasswords);
                               });
                            } else {

                              widget.controllers[i].clear();
                            }

                          },
                          icon: Icon(
                            widget.isInputPassword[i] ? Icons.password : Icons.clear,
                            size: 20,
                          ),
                        ),
                      ),
                      obscureText: value.showPasswords[i],
                    ),
                  const SizedBox(height: 30),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      for (int i = 0;i < widget.buttonLabels.length;i++)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            ElevatedButton(
                                onPressed: widget.buttonFunctions[i],
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(widget.buttonBackgroundColors[i]),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                  child: Text(
                                    widget.buttonLabels[i],
                                    style: GoogleFonts.tiltNeon(
                                        fontSize: 19,
                                        color: widget.buttonForegroundColors[i]
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
