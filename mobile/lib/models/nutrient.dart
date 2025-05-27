class Nutrient {
  final String name;
  final double amount;
  final String unit;

  Nutrient({
    required this.name,
    required this.amount,
    required this.unit,
  });

  factory Nutrient.fromJson(Map<String, dynamic> json) {
    return Nutrient(
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
    );
  }

  factory Nutrient.empty() {
    return Nutrient(name: '', amount: 0.0, unit: '');
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'unit': unit,
    };
  }
}
