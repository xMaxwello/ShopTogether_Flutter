import 'package:flutter/material.dart';

class MySearchBar extends StatefulWidget {
  const MySearchBar({super.key});

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
      child: SearchAnchor(
          builder: (BuildContext context, SearchController controller) {

            return SearchBar(
              surfaceTintColor: MaterialStateProperty.all(
                  Color.lerp(Colors.white, Theme
                      .of(context)
                      .colorScheme
                      .primary, 0.8)),
              controller: controller,
              onTap: () {
                controller.openView();
              },
              onChanged: (_) {
                controller.openView();
              },
              leading: const Icon(Icons.search),
              trailing: <Widget> [
                IconButton(
                  onPressed: () {
                    setState(() {
                      ///TODO: add function
                    });
                  },
                  icon: const Icon(Icons.qr_code),
                ),
              ],
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0)),
            );
          },
          suggestionsBuilder: (BuildContext context, SearchController controller) {
            return List<ListTile>.generate(5, (int index) {
              final String item = 'item $index';
              return ListTile( ///TODO: edit to the Productitem
                title: Text(item),
                onTap: () {
                  controller.closeView(item);
                },
              );
            });
          }
      ),
    );
  }
}