import 'dart:convert';
import 'package:http/http.dart' as http;

class BankLocator {
  Future<List> getBankAddress(String ifscCode) async {
    List res = [];
    try {
      final response =
          await http.get(Uri.parse('https://ifsc.razorpay.com/$ifscCode'));
      final parsed = json.decode(response.body);

      if (response.statusCode == 200) {
        res.add({
          'status': 200,
          'message': '${parsed['BANK']}, ${parsed['BRANCH']}'
        });
      } else {
        res.add({'status': 404, 'message': 'Invalid ifsc code'});
      }
    } catch (e) {
      res.add({'status': 400, 'message': 'Something went wrong'});
    }
    return res;
  }
}
