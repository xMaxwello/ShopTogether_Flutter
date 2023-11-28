import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_app/functions/services/settings/MyUserCardService.dart';


///TODO: Der Name braucht etwas bis der aktualisiert wird, evnt. fixen falls möglich

class MyUserCard extends StatelessWidget {
  const MyUserCard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? '';

    return FutureBuilder<String>(
      future: MyUserCardService.getUserName(uid), ///TODO: Verstehe was du hier machen möchstest, ist kein schlechter Ansatz. Du musst nur aufpassen, das bei sowas die Art und Weise wie man Sachen programmiert Konstant bleibt und man nicht bei einem das so und bei dem anderen das anders macht
      builder: (context, snapshot) {

        String displayName = snapshot.data ?? "";
        return _buildUserCard(context, displayName);
      },
    );
  }

  ///TODO: Kann man machen, wenn es dir hilft kannst du das lassen. Allerdings lagerst du dieses Widget nicht wirklich aus oder verwendest es irgendwo wieder, deswegen kannst du es auch rein schreiben. Könnte aber wie gesagt für die Übersichtlichkeit für jemanden besser sein. Also deine Entscheidung
  Widget _buildUserCard(BuildContext context, String displayName) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: Theme.of(context).colorScheme.primary, width: 10),
          ),
        ),
        child: Card(
          color: Theme.of(context).cardTheme.color,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  displayName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Accounteinstellungen",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: Theme.of(context).iconTheme.size,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
