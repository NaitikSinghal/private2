import 'package:flutter/material.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        itemCount: 3,
        scrollDirection: Axis.vertical,
        itemBuilder: (ctx, i) {
          return const Center(
            child: Text('To do'),
          );
          // return ProductItem();
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 16,
          mainAxisExtent: 220,
        ),
      ),
    );
  }
}
