class ServiceModel {
  final int id;
  final int companyId;
  final String name;
  final String description;
  final double price;

  ServiceModel({
    required this.id,
    required this.companyId,
    required this.name,
    required this.description,
    required this.price,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      companyId: json['companyId'],
      name: json['name'],
      description: (json['description'] as String?) ?? '',
      price: (json['price'] as num).toDouble(),
    );
  }
}
