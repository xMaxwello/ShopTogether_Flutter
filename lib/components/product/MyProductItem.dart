import 'package:flutter/material.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';

class MyProductItem extends StatelessWidget {

  final MyProduct myProduct;

  const MyProductItem({
    Key? key, required this.myProduct}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
            margin: const EdgeInsets.only(left: 6, right: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      // Produktbild oder Placeholder
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: myProduct.productImageUrl.isNotEmpty ? Image.network(
                          myProduct.productImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error)),
                        ) : const Center(child: Icon(Icons.image, color: Colors.grey)),
                      ),

                      const SizedBox(width: 10),

                      // Produktname
                      Expanded(
                        child: Text(
                          myProduct.productName,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Stückzahl
                      Text(myProduct.productCount.toString()),
                    ],
                  ),
                ),
                const SizedBox(height: 4,),
              ],
            )
        ),
      ],
    );
  }
}
