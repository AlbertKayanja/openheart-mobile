import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CounsellorHomePage extends StatelessWidget {
  const CounsellorHomePage({super.key});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.black, // ✅ MATCHES YOUR APP THEME
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Counsellor Home",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            /// Welcome
            const Text(
              "Welcome,",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              user?.email ?? "Counsellor",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFB39DDB), // ✅ Your purple accent tone
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              "Overview",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            _buildStatCard(
              icon: Icons.calendar_today,
              title: "Upcoming Sessions",
              value: "0",
            ),

            const SizedBox(height: 15),

            _buildStatCard(
              icon: Icons.people,
              title: "Active Clients",
              value: "0",
            ),

            const SizedBox(height: 15),

            _buildStatCard(
              icon: Icons.star,
              title: "Reviews",
              value: "0",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E), // ✅ Dark card color
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 26, color: const Color(0xFFB39DDB)),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFB39DDB),
            ),
          ),
        ],
      ),
    );
  }
}
