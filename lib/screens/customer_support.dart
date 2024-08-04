// ignore: import_of_legacy_library_into_null_safe
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/widgets/buttons/round_button_with_icon.dart';
import 'package:pherico/widgets/global/app_bar.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerSupport extends StatelessWidget {
  static const routeName = '/customer-support';
  const CustomerSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: CustomAppbar(
          title: 'Customer support',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 6),
              child: Text(
                'FAQs',
                style: TextStyle(fontSize: 22),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    ExpansionTile(
                      title: const Text('Can i change my refund policy'),
                      initiallyExpanded: true,
                      iconColor: gradient1,
                      textColor: black,
                      children: const [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                          child: Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim.'),
                        )
                      ],
                    ),
                    ExpansionTile(
                      title: const Text('Is there any delivery charges?'),
                      iconColor: gradient1,
                      textColor: black,
                      children: const [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                          child: Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim.'),
                        )
                      ],
                    ),
                    ExpansionTile(
                      title: const Text('Is pay later available'),
                      iconColor: gradient1,
                      textColor: black,
                      children: const [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                          child: Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim.'),
                        )
                      ],
                    ),
                    ExpansionTile(
                      title: const Text('Can i use credit card'),
                      iconColor: gradient1,
                      textColor: black,
                      children: const [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                          child: Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim.'),
                        )
                      ],
                    ),
                    ExpansionTile(
                      title: const Text('Can i avail Emi?'),
                      iconColor: gradient1,
                      textColor: black,
                      children: const [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                          child: Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim.'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Arc(
              edge: Edge.TOP,
              arcType: ArcType.CONVEX,
              height: 50.0,
              child: Container(
                color: HexColor('40258B'),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.26,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Pherico',
                        style: TextStyle(
                            color: gradient1,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Feel free to contact us',
                        style: TextStyle(color: gradient1),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      RoundButtonWithIcon(
                        buttonName: 'Call us',
                        onPressed: () async {
                          final Uri launchUri = Uri(
                            scheme: 'tel',
                            path: '+918755512976',
                          );
                          if (await launchUrl(launchUri)) {
                            //dialer opened
                          } else {
                            //dailer is not opened
                          }
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            alignment: Alignment.centerLeft),
                        onPressed: () {},
                        child: Text(
                          'Mail us : support@pherico.com',
                          style: TextStyle(color: gradient1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
