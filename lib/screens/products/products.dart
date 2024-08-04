import 'package:flutter/material.dart';
import 'package:pherico/widgets/global/app_bar.dart';
import 'package:pherico/widgets/product/product_grid.dart';

class Products extends StatelessWidget {
  static const routeName = '/products';
  const Products({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: CustomAppbar(
          title: 'Products',
          onPressed: () {
            Navigator.of(context).pushNamed('/home');
          },
        ),
      ),
      body: const SafeArea(
        child: ProductGrid(),
      ),
    );
  }
}
