import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/functions/services/firestore/MyFirestoreService.dart';
import 'package:shopping_app/functions/services/firestore/subclasses/ProductService.dart';
import 'package:shopping_app/functions/services/snackbars/MySnackBarService.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';


class MyCustomItemBottomSheet extends StatefulWidget {
  final MyProduct? product;
  final String? productUUID;
  final String? groupUUID;
  final bool isNewProduct;

  const MyCustomItemBottomSheet({super.key, this.product, this.productUUID, this.groupUUID, this.isNewProduct = true});

  @override
  _MyCustomItemBottomSheetState createState() => _MyCustomItemBottomSheetState();
}

class _MyCustomItemBottomSheetState extends State<MyCustomItemBottomSheet> {
  late TextEditingController _titleController;
  late TextEditingController _volumeController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _volumeController = TextEditingController();
    _descriptionController = TextEditingController();
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
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Titel'),
          ),
          TextField(
            controller: _volumeController,
            decoration: const InputDecoration(
                labelText: 'Menge (Gramm, Liter, etc.)'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Beschreibung'),
          ),
          const SizedBox(height: 15),
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

  void _manageProductDetails() async {

    String title = _titleController.text.trim();
    String productVolumen = _volumeController.text.trim();
    String description = _descriptionController.text.trim();

    if (title.isEmpty) {
      MySnackBarService.showMySnackBar(context, 'Bitte geben Sie einen Titel an!');
      Navigator.pop(context);
      return;
    }

    if (widget.isNewProduct) {

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