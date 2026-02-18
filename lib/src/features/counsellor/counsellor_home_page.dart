import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CounsellorHomePage extends StatefulWidget {
  const CounsellorHomePage({super.key});

  @override
  State<CounsellorHomePage> createState() => _CounsellorHomePageState();
}

class _CounsellorHomePageState extends State<CounsellorHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = [
    "assigned",
    "active",
    "completed",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  String get _currentUserId => FirebaseAuth.instance.currentUser!.uid;

  Color _statusColor(String status) {
    switch (status) {
      case "assigned":
        return Colors.blue;
      case "active":
        return Colors.green;
      case "completed":
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  Future<void> _acceptRequest(String requestId) async {
    await FirebaseFirestore.instance
        .collection("requests")
        .doc(requestId)
        .update({
      "status": "active",
      "acceptedAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> _completeRequest(String requestId) async {
    await FirebaseFirestore.instance
        .collection("requests")
        .doc(requestId)
        .update({
      "status": "completed",
      "completedAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  Widget _buildRequestList(String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("requests")
          .where("counsellorId", isEqualTo: _currentUserId)
          .where("status", isEqualTo: status)
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(child: Text("No requests"));
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                title: Text(data["category"] ?? ""),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data["description"] ?? ""),
                    const SizedBox(height: 4),
                    Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        color: _statusColor(status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                trailing: _buildActionButton(status, doc.id),
              ),
            );
          },
        );
      },
    );
  }

  Widget? _buildActionButton(String status, String requestId) {
    if (status == "assigned") {
      return ElevatedButton(
        onPressed: () => _acceptRequest(requestId),
        child: const Text("Accept"),
      );
    }

    if (status == "active") {
      return ElevatedButton(
        onPressed: () => _completeRequest(requestId),
        child: const Text("Complete"),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counsellor Dashboard"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Assigned"),
            Tab(text: "Active"),
            Tab(text: "Completed"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((status) => _buildRequestList(status)).toList(),
      ),
    );
  }
}
