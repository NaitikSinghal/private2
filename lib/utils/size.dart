getSize(String size, String sizeUnit) {
  if (sizeUnit == 'S' ||
      sizeUnit == 'M' ||
      sizeUnit == 'L' ||
      sizeUnit == 'XL' ||
      sizeUnit == 'XXL' ||
      sizeUnit == 'XXXL') {
    return sizeUnit;
  } else {
    return '$size $sizeUnit';
  }
}
