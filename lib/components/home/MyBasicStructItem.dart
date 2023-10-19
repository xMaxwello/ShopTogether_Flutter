import 'package:flutter/material.dart';

class MyBasicStructItem extends StatelessWidget {

  final Widget content;

  const MyBasicStructItem({super.key, required this.content});

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        Container(
          margin: const EdgeInsets.only(left: 6, right: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              Card(
                color: Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.08),
                shadowColor: Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.6),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                  child: content,
                ),
              ),
              const SizedBox(height: 4,)

            ],
          )
        ),

      ],
    );
  }
}
