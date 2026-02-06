import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/request_service.dart';

class RequestWaitingScreen extends StatelessWidget {
  const RequestWaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = RequestService();

    return Scaffold(
      appBar: AppBar(title: const Text('Your Requests')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: service.watchMyRequests(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('No requests yet.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final data = docs[i].data();
              final status = (data['status'] ?? 'unknown').toString();
              final createdAt = data['createdAt'];

              return Card(
                child: ListTile(
                  title: Text('Status: $status'),
                  subtitle: Text('createdAt: $createdAt'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
