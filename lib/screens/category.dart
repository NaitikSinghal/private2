import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/config/icon_paths.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/models/category_model.dart';
import 'package:pherico/screens/best_seller.dart';
import 'package:pherico/screens/products/product_list.dart';
import 'package:pherico/utils/border.dart';
import 'package:pherico/widgets/global/app_bar.dart';
import 'package:pherico/widgets/global/circle_with_bottom_label.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';

class Category extends StatelessWidget {
  const Category({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppbar(
          onPressed: () {
            Navigator.of(context).pop();
          },
          title: 'Categories',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(() => const BestSeller(),
                          transition: Transition.leftToRight);
                    },
                    child: CircleWithBottomLabel(
                      title: 'Best sellers',
                      child: SvgPicture.asset(bestSeller),
                    ),
                  ),
                  CircleWithBottomLabel(
                    title: 'My List',
                    child: SvgPicture.asset(
                      cartBag,
                      height: 28,
                    ),
                  ),
                  CircleWithBottomLabel(
                    title: 'Top Rated',
                    child: SvgPicture.asset(
                      topRated,
                      height: 28,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: FirestoreListView(
                query: firebaseFirestore
                    .collection('category')
                    .where('status', isEqualTo: true),
                loadingBuilder: (context) => const MyProgressIndicator(),
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text('An error occured'),
                  );
                },
                emptyBuilder: (context) {
                  return const Center(
                    child: Text('No category found'),
                  );
                },
                itemBuilder: (context, snapshot) {
                  CategoryModel category = CategoryModel.fromSnap(snapshot);
                  return categoryList(category);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryList(CategoryModel category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Get.to(() => const ProductList(),
              arguments: category.id.toString(),
              transition: Transition.leftToRight);
        },
        child: Card(
          color: const Color.fromARGB(255, 243, 243, 243),
          elevation: 2,
          margin: EdgeInsets.zero,
          shape: borderShape(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  category.name.toString(),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.keyboard_arrow_right_sharp,
                  color: iconColor,
                  size: 28,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
