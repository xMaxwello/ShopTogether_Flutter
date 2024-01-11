import 'package:flutter/material.dart';
import 'package:shopping_app/functions/services/firestore/MyFirestoreService.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';

class MyCustomItemBottomSheet extends StatefulWidget {
  final MyProduct product;
  final String productUUID;
  final String? groupUUID;

  const MyCustomItemBottomSheet({super.key, required this.product, required this.productUUID, this.groupUUID});

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
    _titleController = TextEditingController(text: widget.product.productName);
    _volumeController = TextEditingController(text: widget.product.productVolumen);
    _descriptionController = TextEditingController(text: widget.product.productDescription);
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
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Produkt bearbeiten',
          style: Theme.of(context).textTheme.titleMedium
          ),

          const SizedBox(height: 10),

          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Titel'),
          ),
          TextField(
            controller: _volumeController,
            decoration: InputDecoration(labelText: 'Menge (Gramm, Liter, etc.)'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Beschreibung'),
          ),

          const SizedBox(height: 15),

          ElevatedButton(
            onPressed: () => _updateProductDetails(),
            child: Text('Speichern',
                style: Theme.of(context).textTheme.displaySmall
            ),
          ),
        ],
      ),
    );
  }

  void _updateProductDetails() {
    MyFirestoreService.productService.updateProductDetails(
      widget.groupUUID!,
      widget.productUUID,
      _titleController.text,
      _volumeController.text,
      _descriptionController.text,
    );
    Navigator.pop(context);
  }
}