import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/company.dart';
import '../models/service.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:3000"; 
  // 👆 For Android emulator. If testing in browser/web: use localhost:3000

  Future<List<Company>> fetchCompanies() async {
    final response = await http.get(Uri.parse("$baseUrl/companies"));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Company.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load companies");
    }
  }

  Future<Company> createCompany(String name, String regNo) async {
    final response = await http.post(
      Uri.parse("$baseUrl/companies"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "registrationNumber": regNo,
      }),
    );
    if (response.statusCode == 201) {
      return Company.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to create company");
    }
  }

  Future<ServiceModel> createService(
      int companyId, String name, String description, double price) async {
    final response = await http.post(
      Uri.parse("$baseUrl/services"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "companyId": companyId,
        "name": name,
        "description": description,
        "price": price,
      }),
    );
    if (response.statusCode == 201) {
      return ServiceModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to create service");
    }
  }

  Future<ServiceModel> getServiceById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/services/$id"));
    if (response.statusCode == 200) {
      return ServiceModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Service not found");
    }
  }

  Future<void> deleteCompany(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/companies/$id"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete company");
    }
  }

  Future<void> deleteService(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/services/$id"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete service");
    }
  }

  Future<Company> updateCompany(int id, String name, String regNo) async {
    final response = await http.put(
      Uri.parse("$baseUrl/companies/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "registrationNumber": regNo}),
    );
    if (response.statusCode == 200) {
      return Company.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to update company");
    }
  }

  Future<ServiceModel> updateService(int id, String name, String description, double price) async {
    final response = await http.put(
      Uri.parse("$baseUrl/services/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "description": description, "price": price}),
    );
    if (response.statusCode == 200) {
      return ServiceModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to update service");
    }
  }
}
