import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/clicky.dart';

class ClickyController extends GetxController {
  final Rx<List<Clicky>> _clickies = Rx<List<Clicky>>([]);

  List<Clicky> get clickies => _clickies.value;

  @override
  void onInit() {
    super.onInit();
    _clickies.bindStream(
      firebaseFirestore.collection(clickiesCollection).snapshots().map(
        (QuerySnapshot querySnapshot) {
          List<Clicky> fromRes = [];
          for (var data in querySnapshot.docs) {
            fromRes.add(Clicky.fromSnap(data));
          }

          return fromRes;
        },
      ),
    );
  }
}
