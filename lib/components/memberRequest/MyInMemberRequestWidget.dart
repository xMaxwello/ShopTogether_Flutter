import 'package:flutter/material.dart';

class MyInMemberRequestWidget extends StatelessWidget {

  final String title;
  final Function() executeFunction;

  const MyInMemberRequestWidget({Key? key, required this.title, required this.executeFunction}) : super(key: key);

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
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(6,
                      (index) => Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: SizedBox(
                      width: 35,
                      child: TextField(
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
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

              const SizedBox(height: 15,),
              
              SizedBox(
                height: 50,
                width: 50,
                child: FloatingActionButton.extended(
                    onPressed: executeFunction,
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Theme.of(context).floatingActionButtonTheme.foregroundColor,
                    label: Icon(
                      Icons.check,
                      size: Theme.of(context).floatingActionButtonTheme.iconSize! * 0.8,
                    )
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}