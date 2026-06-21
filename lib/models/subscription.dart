class Subscription {
  final String id;
  final String name;
  final double price;
  final String category;
  final int paymentDate;
  final String notes;
  final DateTime createdAt;

  Subscription({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.paymentDate,
    this.notes = '',
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'category': category,
        'paymentDate': paymentDate,
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        id: json['id'],
        name: json['name'],
        price: (json['price'] as num).toDouble(),
        category: json['category'],
        paymentDate: json['paymentDate'],
        notes: json['notes'] ?? '',
        createdAt: DateTime.parse(json['createdAt']),
      );

  Subscription copyWith({
    String? id,
    String? name,
    double? price,
    String? category,
    int? paymentDate,
    String? notes,
    DateTime? createdAt,
  }) =>
      Subscription(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        category: category ?? this.category,
        paymentDate: paymentDate ?? this.paymentDate,
        notes: notes ?? this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
}
