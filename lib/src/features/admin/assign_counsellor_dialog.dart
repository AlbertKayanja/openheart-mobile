import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignCounsellorDialog extends StatelessWidget {
  final String requestId;

  const AssignCounsellorDialog(
      {super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Assign Counsellor"),
      content: SizedBox(
        width: double.maxFinite,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('role',
                  isEqualTo: 'counsellor')
              .where('active',
                  isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                  child:
                      CircularProgressIndicator());
            }

            final counsellors =
                snapshot.data!.docs;

            if (counsellors.isEmpty) {
              return const Text(
                  "No active counsellors");
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: counsellors.length,
              itemBuilder: (context, index) {
                final counsellor =
                    counsellors[index];
                final data =
                    counsellor.data()
                        as Map<String,
                            dynamic>;

                return ListTile(
                  title:
                      Text(data['name'] ?? ''),
                  onTap: () async {
                    await FirebaseFirestore
                        .instance
                        .collection(
                            'requests')
                        .doc(requestId)
                        .update({
                      'assignedTo':
                          counsellor.id,
                      'status':
                          'assigned',
                    });

                    Navigator.pop(
                        context);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
