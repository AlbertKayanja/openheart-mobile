import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CounsellorShell extends StatelessWidget {
  const CounsellorShell({super.key});

  @override
  Widget build(BuildContext context) {
    final counsellorId = FirebaseAuth.instance.currentUser?.uid;
    if (counsellorId == null) {
      return const Scaffold(body: Center(child: Text('Not signed in')));
    }

    final query = FirebaseFirestore.instance
        .collection('requests')
        .where('status', isEqualTo: 'open')
        .orderBy('createdAt', descending: true);

    return Scaffold(
      appBar: AppBar(title: const Text('Requests')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: query.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('No open requests yet.'));
          }

          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final d = docs[index];
              final data = d.data();
              final topic = (data['topic'] ?? '').toString();
              final message = (data['message'] ?? '').toString();
              final createdAt = data['createdAt'];
              final createdText = createdAt is Timestamp
                  ? createdAt.toDate().toLocal().toString()
                  : '';

              return ListTile(
                title: Text(topic.isEmpty ? 'Help request' : topic),
                subtitle: Text(
                  '${message.isEmpty ? '(no message)' : message}\n$createdText',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                isThreeLine: true,
                trailing: ElevatedButton(
                  onPressed: () async {
                    await d.reference.update({
                      'status': 'accepted',
                      'counsellorId': counsellorId,
                      'acceptedAt': FieldValue.serverTimestamp(),
                      'updatedAt': FieldValue.serverTimestamp(),
                    });

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Request accepted')),
                      );
                    }
                  },
                  child: const Text('Accept'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
