import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = [
    "pending",
    "assigned",
    "active",
    "completed",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  Color _statusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange;
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

  Future<void> _assignCounsellor(
      BuildContext context, String requestId) async {
    final counsellorsSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("role", isEqualTo: "counsellor")
        .where("active", isEqualTo: true)
        .get();

    if (counsellorsSnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No active counsellors available")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Assign Counsellor"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: counsellorsSnapshot.docs.map((doc) {
                final data = doc.data();
                return ListTile(
                  title: Text(data["name"]),
                  subtitle: Text(
                      (data["specialities"] as List<dynamic>).join(", ")),
                  onTap: () async {
                    await FirebaseFirestore.instance
                        .collection("requests")
                        .doc(requestId)
                        .update({
                      "counsellorId": doc.id,
                      "counsellorName": data["name"],
                      "status": "assigned",
                      "updatedAt": FieldValue.serverTimestamp(),
                    });

                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRequestList(String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("requests")
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
                    if (data["counsellorName"] != null)
                      Text("Counsellor: ${data["counsellorName"]}"),
                  ],
                ),
                trailing: status == "pending"
                    ? ElevatedButton(
                        onPressed: () =>
                            _assignCounsellor(context, doc.id),
                        child: const Text("Assign"),
                      )
                    : Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          color: _statusColor(status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Pending"),
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
