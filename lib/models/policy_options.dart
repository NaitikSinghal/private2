class PolicyOption {
  final int value;
  final String name;

  PolicyOption({required this.value, required this.name});
}

List<PolicyOption> policyOptions = [
  PolicyOption(value: 0, name: 'No return policy'),
  PolicyOption(value: 1, name: '7 Days return policy'),
  PolicyOption(value: 2, name: '15 Days return policy'),
  PolicyOption(value: 3, name: '7 Days replacement'),
  PolicyOption(value: 4, name: '15 Days replacement'),
];
