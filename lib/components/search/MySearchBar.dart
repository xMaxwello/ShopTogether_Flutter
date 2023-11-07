import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: controller,
            onTap: () {
              controller.openView();
            },
            onChanged: (_) {
              controller.openView();
            },
            leading: const Icon(Icons.search),
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0)),
          );
        },
        suggestionsBuilder: (BuildContext context, SearchController controller) {
          return List<ListTile>.generate(5, (int index) {
            final String item = 'item $index';
            return ListTile(
              title: Text(item),
              onTap: () {
                controller.closeView(item);
              },
            );
          });
        }
    );
  }
}
