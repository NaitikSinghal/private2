import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/widgets/global/app_bar.dart';

class StoreSettings extends StatelessWidget {
  const StoreSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppbar(
          onPressed: () {
            Get.back();
          },
          title: 'Settings',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: const Text('Accepting Orders'),
                trailing: Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    value: true,
                    onChanged: (value) {},
                  ),
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              const ListTile(
                title: Text('Edit Store'),
              ),
              const Divider(
                thickness: 1,
              ),
              const ListTile(
                title: Text("Seller's Policy"),
              ),
              const Divider(
                thickness: 1,
              ),
              const ListTile(
                title: Text('Payment Settings'),
              ),
              const Divider(
                thickness: 1,
              ),
              const ListTile(
                title: Text('Delivery Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
