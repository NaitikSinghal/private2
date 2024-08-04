import 'package:flutter/material.dart';

borderShape({int radius = 8}) {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(
      radius.toDouble(),
    ),
  );
}

RoundedRectangleBorder bottomSheetBorder = const RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
  ),
);
