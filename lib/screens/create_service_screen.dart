import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/company.dart';
import '../models/service.dart';

class CreateServiceScreen extends StatefulWidget {
  const CreateServiceScreen({super.key});

  @override
  State<CreateServiceScreen> createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final ApiService apiService = ApiService();
  List<Company> companies = [];
  Company? selectedCompany;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    try {
      final result = await apiService.fetchCompanies();
      setState(() {
        companies = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading companies: $e")),
      );
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() && selectedCompany != null) {
      setState(() => _isLoading = true);

      try {
        ServiceModel service = await apiService.createService(
          selectedCompany!.id,
          _nameController.text.trim(),
          _descriptionController.text.trim(),
          double.parse(_priceController.text.trim()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Service '${service.name}' created!")),
        );

        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Service")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<Company>(
                value: selectedCompany,
                hint: const Text("Select Company"),
                items: companies.map((company) {
                  return DropdownMenuItem(
                    value: company,
                    child: Text(company.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCompany = value;
                  });
                },
                validator: (value) =>
                    value == null ? "Please select a company" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Service Name"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter service name" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Price"),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter a price";
                  if (double.tryParse(value) == null) return "Enter a valid number";
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text("Create Service"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
