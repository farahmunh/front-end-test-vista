import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend/screens/create_service_screen.dart';
import '../services/api_service.dart';
import '../models/company.dart';
import 'create_company_screen.dart';
import 'service_detail_screen.dart';
import 'edit_company_screen.dart';
import 'edit_service_screen.dart';

class CompanyListScreen extends StatefulWidget {
  const CompanyListScreen({super.key});

  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Company>> companiesFuture;

  List<Company> allCompanies = [];   // full list
  List<Company> filteredCompanies = []; // filtered list
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    companiesFuture = apiService.fetchCompanies();
    companiesFuture.then((data) {
      setState(() {
        allCompanies = data;
        filteredCompanies = data;
      });
    });

    searchController.addListener(_filterCompanies);
  }

  void _filterCompanies() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredCompanies = allCompanies.where((company) {
        return company.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _refreshCompanies() {
    companiesFuture = apiService.fetchCompanies();
    companiesFuture.then((data) {
      setState(() {
        allCompanies = data;
        filteredCompanies = data;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _openCreateCompanyForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateCompanyScreen()),
    );

    if (result == true) {
      _refreshCompanies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Companies")),
      body: FutureBuilder<List<Company>>(
        future: companiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No companies found.\nTap + to add one!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          } else {
            final companies = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: companies.length,
              itemBuilder: (context, index) {
                final company = companies[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Slidable(
                    key: ValueKey(company.id),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditCompanyScreen(company: company),
                              ),
                            );
                            if (result == true) _refreshCompanies();
                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                        SlidableAction(
                          onPressed: (context) async {
                            try {
                              await apiService.deleteCompany(company.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Deleted '${company.name}'")),
                              );
                              _refreshCompanies();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error deleting: $e")),
                              );
                            }
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: ExpansionTile(
                      title: Text(
                        company.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Reg No: ${company.registrationNumber}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      children: company.services.isEmpty
                          ? [
                              const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  "No services yet. Add one!",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            ]
                          : company.services.map((service) {
                              return Slidable(
                                key: ValueKey(service.id),
                                endActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => EditServiceScreen(service: service),
                                          ),
                                        );
                                        if (result == true) _refreshCompanies();
                                      },
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit,
                                      label: 'Edit',
                                    ),
                                    SlidableAction(
                                      onPressed: (context) async {
                                        try {
                                          await apiService.deleteService(service.id);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Deleted '${service.name}'")),
                                          );
                                          _refreshCompanies();
                                        } catch (e) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Error deleting service: $e")),
                                          );
                                        }
                                      },
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  title: Text(service.name),
                                  subtitle: Text(service.description.isNotEmpty
                                      ? service.description
                                      : "No description"),
                                  trailing: Chip(
                                    label: Text(
                                      "RM ${service.price.toStringAsFixed(2)}",
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ServiceDetailScreen(service: service),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }).toList(),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "addCompany",
            onPressed: _openCreateCompanyForm,
            child: const Icon(Icons.add_business),
            tooltip: "Add Company",
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: "addService",
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateServiceScreen()),
              );
              if (result == true) _refreshCompanies();
            },
            child: const Icon(Icons.home_repair_service),
            tooltip: "Add Service",
          ),
        ],
      ),
    );
  }
}
