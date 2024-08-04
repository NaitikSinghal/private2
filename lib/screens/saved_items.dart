import 'package:flutter/material.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/widgets/order/cancelled_order.dart';
import 'package:pherico/widgets/savedItems/saved_clickies.dart';
import 'package:pherico/widgets/savedItems/saved_products.dart';

import '../widgets/global/app_bar.dart';

class SavedItems extends StatelessWidget {
  static const routeName = '/saved-items';
  const SavedItems({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: CustomAppbar(
            title: 'Saved Items',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.0)),
                child: TabBar(
                  indicator: BoxDecoration(
                      // color: gradient1,
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(10.0)),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: const [
                    Tab(
                      text: 'Products',
                    ),
                    Tab(
                      text: 'Clickies',
                    ),
                    Tab(
                      text: 'Video',
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    SavedProducts(),
                    SavedClickies(),
                    CancelledOrder()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
