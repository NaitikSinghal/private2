import 'package:flutter/material.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/models/address.dart';
import 'package:pherico/resources/address_resource.dart';
import 'package:pherico/utils/snackbar.dart';

class AddressList extends StatelessWidget {
  final Address address;
  const AddressList({required this.address, super.key});

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return Dismissible(
      key: Key(address.id.toString()),
      background: Container(
        color: errorColor,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(right: 20, left: 20),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.delete,
              color: white,
              size: 40,
            ),
            Icon(
              Icons.delete,
              color: white,
              size: 40,
            ),
          ],
        ),
      ),
      onDismissed: (direction) async {
        try {
          String res = await AddressMethods().deleteAddress(address.id);
          if (res != 'success') {
            scaffold.showSnackBar(
              const SnackBar(
                content: Text(
                  'Failed to delete',
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (error) {
          scaffold.showSnackBar(
            const SnackBar(
              content: Text(
                'Something went wrong',
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      direction: DismissDirection.horizontal,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.fullName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed('/add-address', arguments: address);
                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.topRight),
                    child: Text(
                      'Edit',
                      style: TextStyle(color: gradient1),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${address.flat},  ${address.area}, ${address.city}, ${address.state} - ${address.pincode}\nPhone : ${address.phone}',
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 14, left: 4),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: Transform.scale(
                        scale: 1.4,
                        child: Checkbox(
                          value: address.isDefault == 0 ? false : true,
                          onChanged: (value) async {
                            try {
                              String res = await AddressMethods()
                                  .setDefaultAddress(address.id);
                              if (res != 'success') {
                                // ignore: use_build_context_synchronously
                                showErrorSnackbar(res.toString(), context);
                              }
                            } catch (error) {
                              showErrorSnackbar(
                                  'Something went wrong', context);
                            }
                          },
                          activeColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 14, left: 12),
                    child: Text('Use as the shipping address'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
