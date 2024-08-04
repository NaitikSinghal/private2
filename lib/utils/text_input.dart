import 'package:flutter/material.dart';
import 'package:pherico/config/my_color.dart';

TextStyle labelStyle = TextStyle(color: labelGreyColor, height: 4);
OutlineInputBorder outlinedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10.0),
  borderSide: BorderSide(color: white, width: 0),
);
OutlineInputBorder errorBorder = OutlineInputBorder(
  borderRadius: const BorderRadius.all(Radius.circular(4)),
  borderSide: BorderSide(color: errorColor, width: 1.0),
);

disableInputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    floatingLabelAlignment: FloatingLabelAlignment.start,
    fillColor: greyColor,
    labelStyle: labelStyle,
    filled: true,
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide(
        width: 1,
      ),
    ),
    contentPadding: const EdgeInsets.fromLTRB(12.0, 36.0, 12.0, 5.0),
    enabledBorder: outlinedBorder,
    focusedBorder: outlinedBorder,
    errorBorder: errorBorder,
  );
}

inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    floatingLabelAlignment: FloatingLabelAlignment.start,
    fillColor: inputBoxColor,
    labelStyle: labelStyle,
    filled: true,
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide(
        width: 1,
      ),
    ),
    contentPadding: const EdgeInsets.fromLTRB(12.0, 36.0, 12.0, 5.0),
    enabledBorder: outlinedBorder,
    focusedBorder: outlinedBorder,
    errorBorder: errorBorder,
  );
}
