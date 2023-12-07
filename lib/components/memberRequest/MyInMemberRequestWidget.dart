import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/functions/providers/group/MyGroupProvider.dart';

class MyInMemberRequestWidget extends StatelessWidget {
  final String title;
  final Function(List<String>) onNumbersEntered;

  const MyInMemberRequestWidget({
    Key? key,
    required this.title,
    required this.onNumbersEntered,
  }) : super(key: key);

  List<String> getEnteredNumbers(List<TextEditingController> controllers) {
    return controllers.map((controller) => controller.text).toList();
  }

  ///TODO: Wenn man in der Tastatur ist und dann unten links die Tastatur schließt löschen sich alle Zahlen in den Textfields
  ///TODO: Der Focus bei den Textfields ist nicht flüssig, vorallem wenn man auf ein Textfield klickt

  @override
  Widget build(BuildContext context) {
    // Erstelle eine Liste von Controllern für die Textfelder
    List<TextEditingController> textControllers = List.generate(
      6,
          (index) => TextEditingController(),
    );

    List<IconData> icons = [Icons.check, Icons.close];
    List<Function()> functions = [() => onNumbersEntered(getEnteredNumbers(textControllers)), () => Provider.of<MyGroupProvider>(context, listen: false).updateShowWidget(false)];

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
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  6,
                      (index) => Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: SizedBox(
                      width: 40,
                      child: TextField(
                        controller: textControllers[index],
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: const EdgeInsets.all(12),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(width: 2),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            final nextField = index < 5 ? index + 1 : null;
                            if (nextField != null) {
                              FocusScope.of(context).nextFocus();
                            }
                          } else {
                            final prevField = index > 0 ? index - 1 : null;
                            if (prevField != null) {
                              FocusScope.of(context).previousFocus();
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  for (int i = 0;i < icons.length;i++)
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      height: 50,
                      width: 50,
                      child: FloatingActionButton.extended(
                        onPressed: functions.elementAt(i),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Theme.of(context).floatingActionButtonTheme.foregroundColor,
                        label: Icon(
                          icons.elementAt(i),
                          size: Theme.of(context).floatingActionButtonTheme.iconSize! * 0.8,
                        ),
                      ),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}