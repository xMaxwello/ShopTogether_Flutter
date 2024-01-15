import 'package:flutter/material.dart';
import 'package:shopping_app/components/bottomSheetItems/MyCustomItemBottomSheet.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';
import 'package:shopping_app/functions/services/firestore/MyFirestoreService.dart';
import 'package:shopping_app/objects/users/MyUsers.dart';

class MyShowCustomItemBottomSheet {
  static Future<List<Widget>> generateBottomSheet(
      BuildContext context,
      String productUUID,
      String groupUUID) async {
    MyProduct? product = await MyFirestoreService.productService.getProductByUUID(groupUUID, productUUID);

    if (product == null) {
      return [const Center(child: Text('Produkt nicht gefunden.'))];
    }

    List<Widget> productInfoWidgets = [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(product.productName,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Text('Menge: ${product.productVolumen}',
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 10),
            Text('Beschreibung:',
                style: Theme.of(context).textTheme.bodyLarge),
            Text(product.productDescription,
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    ];

    //Zuweisung Mitglied
    Stream<List<MyUser>> userStream = await MyFirestoreService.groupService.getMembersAsStream(groupUUID);
    productInfoWidgets.add(
      StreamBuilder<List<MyUser>>(
          stream: userStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('Keine Mitglieder gefunden');
            }
            List<MyUser> users = snapshot.data!;

            if (users.length > 1) {
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: FutureBuilder<MyProduct?>(
                      future: MyFirestoreService.productService.getProductByUUID(groupUUID, productUUID),
                      builder: (BuildContext context,
                          AsyncSnapshot<MyProduct?> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(20))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text('Käufer zuweisen:',
                                    style: Theme.of(context).textTheme.titleMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  DropdownButton<String>(
                                    hint: Text('Mitglied auswählen',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                    items: users.map((MyUser user) {
                                      return DropdownMenuItem<String>(
                                        value: user.uuid,
                                        child: Center(
                                          child: Text('${user.prename} ${user.surname}',
                                            style: Theme.of(context).textTheme.bodyLarge,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (
                                        String? selectedUserUUID) async {
                                      if (selectedUserUUID != null) {
                                        MyFirestoreService.productService.updateSelectedUserOfProduct(
                                            groupUUID, productUUID, selectedUserUUID);
                                      }
                                    },
                                    value: snapshot.data?.selectedUserUUID,
                                  ),
                                ]
                            ),
                          ),
                        );
                      }
                  )
              );
            }
            else {
              return Container();
            }
          }
      ),
    );

    productInfoWidgets.add(
        ElevatedButton(
          onPressed: () {
            print(product);
            print(productUUID);
            print(groupUUID);
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return MyCustomItemBottomSheet(
                  product: product,
                  productUUID: productUUID,
                  groupUUID: groupUUID,
                  isNewProduct: false,
                );
              },
            );
          },
          child: Text('Produkt bearbeiten',
              style: Theme.of(context).textTheme.displaySmall
          ),
        )
    );
    return productInfoWidgets;
  }
}
