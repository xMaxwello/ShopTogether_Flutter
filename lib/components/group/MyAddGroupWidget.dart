import 'package:flutter/material.dart';

class MyAddGroupWidget extends StatelessWidget {

  final Function() function;
  final String title;
  final String subtitle;

  const MyAddGroupWidget({super.key, required this.function, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: GestureDetector(
        onTap: function,
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 10, top: 15, bottom: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),

                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.labelSmall,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
