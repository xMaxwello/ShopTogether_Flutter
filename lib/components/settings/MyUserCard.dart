import 'package:flutter/material.dart';

class MyUserCard extends StatelessWidget {
  const MyUserCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      color: Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.05),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Vorname Nachname",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Accounteinstellungen",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                Icon(Icons.arrow_forward, size: 16, color: Colors.black54)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
