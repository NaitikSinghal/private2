import 'package:cloud_firestore/cloud_firestore.dart';

class SizeOption {
  final String unit;

  SizeOption({required this.unit});
}

class SizeModel {
  final String size;
  final String unit;

  SizeModel({required this.size, required this.unit});

  Map<String, dynamic> toJson() => {
        "size": size,
        "unit": unit,
      };

  static SizeModel fromJson(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return SizeModel(
      size: snap['size'],
      unit: snap['unit'],
    );
  }

  factory SizeModel.fromMap(Map<String, dynamic> json) {
    return SizeModel(
      size: json["size"],
      unit: json["unit"],
    );
  }
}

List<SizeOption> sizeOption = [
  SizeOption(unit: 'mm'),
  SizeOption(unit: 'cm'),
  SizeOption(unit: 'm'),
  SizeOption(unit: 'inch'),
  SizeOption(unit: 'ft'),
  SizeOption(unit: 'mm²'),
  SizeOption(unit: 'cm²'),
  SizeOption(unit: 'm²'),
  SizeOption(unit: 'in²'),
  SizeOption(unit: 'ft²'),
  SizeOption(unit: 'mm³'),
  SizeOption(unit: 'cm³'),
  SizeOption(unit: 'm³'),
  SizeOption(unit: 'liter'),
  SizeOption(unit: 'ml'),
  SizeOption(unit: 'mg'),
  SizeOption(unit: 'g'),
  SizeOption(unit: 'kg'),
  SizeOption(unit: 'S'),
  SizeOption(unit: 'M'),
  SizeOption(unit: 'L'),
  SizeOption(unit: 'XL'),
  SizeOption(unit: 'XXL'),
  SizeOption(unit: 'XXXL'),
];

List<String> sizeOptionString = [
  'mm',
  'cm',
  'm',
  'inch',
  'ft',
  'mm²',
  'cm²',
  'm²',
  'in²',
  'ft²',
  'mm³',
  'cm³',
  'm³',
  'liter',
  'ml',
  'mg',
  'g',
  'kg',
  'S',
  'M',
  'L',
  'XL',
  'XXL',
  'XXXL',
];
