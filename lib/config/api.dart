class Api {
  static const String apiUrl =
      'https://f802-2405-201-4029-7956-87e-f53c-83a-3e83.in.ngrok.io';
  static const String loginApi = '/api/login';
  static const String registerApi = '/api/register';
  static const String profileUrl = '/api/profile';
  static var getCategory = Uri.parse('$apiUrl/api/categories');
  static var getCart = Uri.parse('$apiUrl/api/get-cart');
  static const userId = '639d790975f00c844817b28f';
  static const headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  static var increaseCartQuantity =
      Uri.parse('$apiUrl/api/increase-cart-quantity');
  static var decreaseCartQuantity =
      Uri.parse('$apiUrl/api/decrease-cart-quantity');

  static var getAddressesUrl = Uri.parse('$apiUrl/api/get-address');
  static var deleteAddressesUrl = Uri.parse('$apiUrl/api/delete-address');
  static var setDefaultAddressUrl =
      Uri.parse('$apiUrl/api/set-default-address');
}
