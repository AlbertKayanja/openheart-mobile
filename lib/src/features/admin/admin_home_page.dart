import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'assign_counsellor_dialog.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('requests')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator());
          }

          final requests = snapshot.data!.docs;

          if (requests.isEmpty) {
            return const Center(
                child: Text("No requests yet"));
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final data =
                  request.data() as Map<String, dynamic>;

              return Card(
                child: ListTile(
                  title: Text(data['clientName'] ?? ''),
                  subtitle: Text(
                      "Status: ${data['status'] ?? ''}"),
                  trailing: ElevatedButton(
                    onPressed:
                        data['status'] == 'pending'
                            ? () {
                                showDialog(
                                  context: context,
                                  builder: (_) =>
                                      AssignCounsellorDialog(
                                    requestId:
                                        request.id,
                                  ),
                                );
                              }
                            : null,
                    child: const Text("Assign"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
