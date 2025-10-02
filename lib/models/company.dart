import 'service.dart';

class Company {
  final int id;
  final String name;
  final String registrationNumber;
  final List<ServiceModel> services;

  Company({
    required this.id,
    required this.name,
    required this.registrationNumber,
    required this.services,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      registrationNumber: json['registrationNumber'],
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => ServiceModel.fromJson(e))
          .toList()
        ?? [],
    );
  }
}
