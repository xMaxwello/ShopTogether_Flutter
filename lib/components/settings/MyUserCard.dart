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
      future: MyUserCardService.getUserName(uid),
      builder: (context, snapshot) {

        String displayName = snapshot.data ?? "";
        return _buildUserCard(context, displayName);
      },
    );
  }

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
