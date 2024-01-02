import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/functions/providers/group/MyGroupProvider.dart';

class MyInMemberRequestWidget extends StatefulWidget {
  final String title;
  final Function(List<String>) onNumbersEntered;

  const MyInMemberRequestWidget({
    Key? key,
    required this.title,
    required this.onNumbersEntered,
  }) : super(key: key);

  @override
  _MyInMemberRequestWidgetState createState() => _MyInMemberRequestWidgetState();
}

class _MyInMemberRequestWidgetState extends State<MyInMemberRequestWidget> {
  late List<TextEditingController> textControllers;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();

    // Initialisiere die TextControllers und FocusNodes
    textControllers = List.generate(6, (index) => TextEditingController());
    focusNodes = List.generate(6, (index) => FocusNode());
  }

  @override
  void dispose() {
    // Disponiere die TextControllers und FocusNodes
    for (var controller in textControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  List<String> getEnteredNumbers() {
    return textControllers.map((controller) => controller.text).toList();
  }

  @override
  Widget build(BuildContext context) {
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
                widget.title,
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
                        focusNode: focusNodes[index],
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        style: Theme.of(context).textTheme.bodyMedium,
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
                            final nextField = index < textControllers.length - 1 ? index + 1 : null;
                            if (nextField != null) {
                              FocusScope.of(context).requestFocus(focusNodes[nextField]);
                            }
                          } else {
                            final prevField = index > 0 ? index - 1 : null;
                            if (prevField != null) {
                              FocusScope.of(context).requestFocus(focusNodes[prevField]);
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
                  for (int i = 0; i < 2; i++)
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      height: 50,
                      width: 50,
                      child: FloatingActionButton.extended(
                        onPressed: i == 0
                            ? () { widget.onNumbersEntered(getEnteredNumbers()); Provider.of<MyGroupProvider>(context, listen: false).updateShowWidget(false); }
                            : () => Provider.of<MyGroupProvider>(context, listen: false).updateShowWidget(false),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Theme.of(context).floatingActionButtonTheme.foregroundColor,
                        label: Icon(
                          i == 0 ? Icons.check : Icons.close,
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