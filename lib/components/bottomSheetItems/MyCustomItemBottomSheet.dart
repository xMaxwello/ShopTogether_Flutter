import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/functions/services/firestore/MyFirestoreService.dart';
import 'package:shopping_app/functions/services/firestore/subclasses/ProductService.dart';
import 'package:shopping_app/functions/services/snackbars/MySnackBarService.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';
import 'package:shopping_app/objects/users/MyUsers.dart';


class MyCustomItemBottomSheet extends StatefulWidget {
  final String? productUUID;
  final String? groupUUID;
  final bool isNewProduct;

  const MyCustomItemBottomSheet({super.key, this.productUUID, this.groupUUID, this.isNewProduct = true});

  @override
  _MyCustomItemBottomSheetState createState() => _MyCustomItemBottomSheetState();
}

class _MyCustomItemBottomSheetState extends State<MyCustomItemBottomSheet> {
  late TextEditingController _titleController;
  late TextEditingController _volumeController;
  late TextEditingController _descriptionController;
  String? _selectedUserUUID;
  List<MyUser> _users = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _volumeController = TextEditingController();
    _descriptionController = TextEditingController();

    if (!widget.isNewProduct) {
      _loadProductData();
    }
    _loadGroupMembers();
  }

  void _loadProductData() async {
    if (widget.productUUID != null && widget.groupUUID != null) {
      MyProduct? product = await MyFirestoreService.productService.getProductByUUID(widget.groupUUID!, widget.productUUID!);
      if (product != null) {
        _titleController.text = product.productName;
        _volumeController.text = product.productVolumen;
        _descriptionController.text = product.productDescription;
      }
    }
  }

  void _loadGroupMembers() async {
    if (widget.groupUUID != null) {
      Stream<List<MyUser>> userStream = await MyFirestoreService.groupService.getMembersAsStream(widget.groupUUID!);
      userStream.listen((List<MyUser> users) {
        setState(() {
          _users = users;
        });
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _volumeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
              widget.isNewProduct ? 'Neues Produkt hinzufügen' : 'Produkt bearbeiten',
              style: Theme.of(context).textTheme.titleMedium
          ),
          const SizedBox(height: 10),
          TextField(
            maxLength: 40,
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Produktname*',
              counterStyle: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          TextField(
            maxLength: 20,
            controller: _volumeController,
            decoration: InputDecoration(
              labelText: 'Menge (Gramm, Liter, etc.)',
              counterStyle: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          TextField(
            maxLength: 200,
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Beschreibung',
              counterStyle: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          const SizedBox(height: 15),
          if (!widget.isNewProduct && _users.length > 1)
            _memberAssignment(),
          const SizedBox(height: 45),
          ElevatedButton(
            onPressed: () => _manageProductDetails(),
            child: Text('Speichern',
                style: Theme.of(context).textTheme.displaySmall
            ),
          ),
        ],
      ),
    );
  }

  Widget _memberAssignment() {
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
              items: _users.map((MyUser user) {
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
                setState(() {
                  _selectedUserUUID = selectedUserUUID;
                });
                if (selectedUserUUID != null) {
                  MyFirestoreService.productService.updateSelectedUserOfProduct(
                      widget.groupUUID!, widget.productUUID!, selectedUserUUID);
                }
              },
              value: _selectedUserUUID,
            ),
          ],
        ),
      ),
    );
  }

  void _manageProductDetails() async {

    String title = _titleController.text.trim();
    String productVolumen = _volumeController.text.trim();
    String description = _descriptionController.text.trim();

    if (widget.isNewProduct) {

      if (title.isEmpty) {
        MySnackBarService.showMySnackBar(context, 'Bitte geben Sie einen Produktnamen an!');
        Navigator.pop(context);
        return;
      }

      String currentUserUUID = FirebaseAuth.instance.currentUser?.uid ?? '';
      String newProductUUID = await ProductService().getUnusedProductUUID(widget.groupUUID!);

      MyProduct newProduct = MyProduct(
        productID: newProductUUID,
        barcode: '',
        productName: title,
        selectedUserUUID: currentUserUUID,
        productCount: 1,
        productVolumen: productVolumen,
        productVolumenType: '',
        productImageUrl: '',
        productDescription: description,
      );

      ProductService().addProductToGroup(widget.groupUUID!, newProduct);

      MySnackBarService.showMySnackBar(context, 'Produkt erfolgreich hinzugefügt.', isError: false);
      Navigator.pop(context);
    } else {

      if (title.isEmpty) {
        MySnackBarService.showMySnackBar(context, 'Änderungen wurden nicht übernommen, da der Produktname fehlt!');
        Navigator.pop(context);
        return;
      }

      MyFirestoreService.productService.updateProductDetails(
        widget.groupUUID!,
        widget.productUUID!,
        title,
        productVolumen,
        description,
      );
      MySnackBarService.showMySnackBar(context, 'Produkt erfolgreich geändert.', isError: false);
      Navigator.pop(context);
    }
  }
}