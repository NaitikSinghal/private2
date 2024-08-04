import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pherico/config/my_color.dart';

class InputEmailPhone extends StatelessWidget {
  final VoidCallback onTap;
  final TextEditingController controller;
  final bool isPhone;
  const InputEmailPhone({
    required this.onTap,
    required this.controller,
    this.isPhone = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onTap: onTap,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Email',
        fillColor: white,
        labelStyle: TextStyle(color: labelGreyColor, height: 4),
        filled: true,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 5.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: textColor_1, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: textColor_1, width: 1),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintText: isPhone ? 'Select Phone' : 'Select Email',
        hintStyle: const TextStyle(fontSize: 14),
        prefixIcon: Icon(
          isPhone ? CupertinoIcons.phone : CupertinoIcons.mail_solid,
          color: Colors.blueGrey,
        ),
      ),
    );
  }
}
