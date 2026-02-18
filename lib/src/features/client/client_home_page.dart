import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateRequestPage extends StatefulWidget {
  const CreateRequestPage({super.key});

  @override
  State<CreateRequestPage> createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends State<CreateRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  String _selectedCategory = "Anxiety";

  final List<String> _categories = [
    "Anxiety",
    "Depression",
    "Relationship",
    "Trauma",
    "Addiction",
    "Career",
  ];

  bool _isLoading = false;

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final user = FirebaseAuth.instance.currentUser!;

    await FirebaseFirestore.instance.collection("requests").add({
      "clientId": user.uid,
      "category": _selectedCategory,
      "description": _descriptionController.text.trim(),
      "status": "pending",
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    });

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Request"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map(
                      (cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  setState(() => _selectedCategory = val!);
                },
                decoration: const InputDecoration(
                  labelText: "Category",
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter description" : null,
                decoration: const InputDecoration(
                  labelText: "Describe your issue",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitRequest,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Submit Request"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
