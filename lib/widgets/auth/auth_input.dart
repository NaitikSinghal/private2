import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import '../../config/my_color.dart';

class AuthInput extends StatelessWidget {
  final String type;
  final String label;
  final String keyName;
  final String hint;
  final Function onValidate;
  final Function onSaved;
  final Icon? prefixIcon;
  final IconButton? suffixIcon;
  final bool isNumeric;
  final bool hidePassword;
  final TextEditingController controller;
  const AuthInput({
    this.type = 'simple',
    this.label ='',
    required this.keyName,
    this.hint = '',
    required this.onValidate,
    required this.onSaved,
    this.prefixIcon ,
    this.suffixIcon,
    this.isNumeric = false,
    this.hidePassword = true,
    super.key,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return type == 'simple'
        ? FormHelper.inputFieldWidgetWithLabel(
            context,
            keyName,
            label,
            hint,
            onValidate,
            onSaved,
            labelFontSize: 14,
            labelBold: false,
            paddingLeft: 0,
            isNumeric: isNumeric,
            paddingRight: 0,
            obscureText: false,
            showPrefixIcon: true,
            prefixIcon: prefixIcon,
            prefixIconPaddingLeft: 15,
            borderFocusColor: labelGreyColor,
            prefixIconColor: Colors.blueGrey,
            borderColor: labelGreyColor,
            borderWidth: 1,
            errorBorderWidth: 1,
            focusedBorderWidth: 1,
            textColor: Colors.black,
            hintColor: labelGreyColor,
            
            hintFontSize: 14,
            borderRadius: 6,
          )
        : FormHelper.inputFieldWidgetWithLabel(
            context,
            keyName,
            label,
            hint,
            onValidate,
            onSaved,
            labelFontSize: 14,
            suffixIcon: suffixIcon,
            labelBold: false,
            paddingLeft: 0,
            paddingRight: 0,
            obscureText: hidePassword,
            showPrefixIcon: true,
            prefixIcon: prefixIcon,
            prefixIconPaddingLeft: 15,
            borderFocusColor: labelGreyColor,
            prefixIconColor: Colors.blueGrey,
            borderColor: labelGreyColor,
            borderWidth: 1,
            errorBorderWidth: 1,
            focusedBorderWidth: 1,
            textColor: black,
            hintColor: labelGreyColor,
            hintFontSize: 14,
            borderRadius: 6,
          );
  }
}
