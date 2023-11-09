import 'package:flutter/material.dart';
import 'package:shopping_app/objects/groups/MyGroup.dart';

class MyGroupItem extends StatelessWidget {

  final MyGroup myGroup;

  const MyGroupItem({super.key, required this.myGroup});

  @override
  Widget build(BuildContext context) {

    int usersLength = myGroup.userUUIDs.length;
    int shoppingListLength = myGroup.products.length;

    return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 15, bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Text(
              myGroup.groupName,
              style: Theme.of(context).textTheme.titleMedium
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Icon(
                    Icons.person,
                    size: Theme.of(context).iconTheme.size,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(width: 3,),
                  Text(
                    usersLength.toString(),
                    style: Theme.of(context).textTheme.titleMedium
                  ),

                  const SizedBox(width: 20,),

                  Icon(
                    Icons.shopping_bag,
                    size: Theme.of(context).iconTheme.size,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(width: 3,),
                  Text(
                    shoppingListLength.toString(),
                    style: Theme.of(context).textTheme.titleMedium
                  )

                ],
              ),
            )

          ],
        )
      );
  }
}
