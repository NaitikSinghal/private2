import 'package:pherico/config/variables.dart';

getbasePrice(int price, int discount, String discountUnit) {
  if (discountUnit == '%') {
    return '$rupeeSymbol${(price + (price * discount) / 100).toInt()}';
  } else {
    return '$rupeeSymbol${(price + discount).toInt()}';
  }
}

getDiscount(int discount, String discountUnit) {
  if (discountUnit == '%') {
    return '$discount% off';
  } else {
    return '$rupeeSymbol$discount off';
  }
}

afterDiscount(int discount, String discountUnit, int price) {
  if (discountUnit == '%') {
    return (price - (price * discount) / 100).toInt();
  } else {
    return (price - discount).toInt();
  }
}

String intToPolicy(int policy) {
  switch (policy) {
    case 0:
      return 'No return policy';
    case 1:
      return '7 Days return policy';
    case 2:
      return '15 Days return policy';
    case 3:
      return '7 Days replacement';
    case 4:
      return '15 Days replacement';
    default:
      return 'No return policy';
  }
}
