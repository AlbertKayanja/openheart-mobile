import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'src/features/entry/entry_screen.dart';
import 'src/features/admin/admin_dashboard_page.dart';
import 'src/features/counsellor/counsellor_home_page.dart';
import 'src/features/client/client_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 🔥 FORCE LOGOUT ON EVERY APP START
  await FirebaseAuth.instance.signOut();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // 🔹 No user → show login entry screen
    if (user == null) {
      return const EntryScreen();
    }

    // 🔹 User exists → check Firestore role
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.data!.exists) {
          return const EntryScreen();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>?;

        if (data == null || !data.containsKey('role')) {
          return const EntryScreen();
        }

        final role = data['role'];

        if (role == 'admin') {
          return AdminDashboardPage();
        } else if (role == 'counsellor') {
          return CounsellorHomePage();
        } else if (role == 'client') {
          return ClientHomePage();
        } else {
          return const EntryScreen();
        }
      },
    );
  }
}
