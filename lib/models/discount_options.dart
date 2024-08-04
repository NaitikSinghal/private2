class DiscountOption {
  final String type;
  final String name;

  DiscountOption({required this.type, required this.name});
}

List<DiscountOption> discountOption = [
  DiscountOption(type: '₹', name: 'Rupees'),
  DiscountOption(type: '%', name: 'Percent'),
];
