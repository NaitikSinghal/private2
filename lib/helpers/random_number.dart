import 'dart:math';

int generate6digit() {
  var rng = Random();
  var rand = rng.nextInt(900000) + 100000;
  return rand;
}
