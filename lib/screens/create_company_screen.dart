import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/company.dart';

class CreateCompanyScreen extends StatefulWidget {
  const CreateCompanyScreen({super.key});

  @override
  State<CreateCompanyScreen> createState() => _CreateCompanyScreenState();
}

class _CreateCompanyScreenState extends State<CreateCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _regNoController = TextEditingController();
  final ApiService apiService = ApiService();

  bool _isLoading = false;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        Company company = await apiService.createCompany(
          _nameController.text.trim(),
          _regNoController.text.trim(),
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Company '${company.name}' created!")),
        );

        // Close this screen and go back to list
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
      appBar: AppBar(title: const Text("Create Company")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Company Name"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter company name" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _regNoController,
                decoration: const InputDecoration(labelText: "Registration Number"),
                validator: (value) => value == null || value.isEmpty
                    ? "Enter registration number"
                    : null,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text("Create Company"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
