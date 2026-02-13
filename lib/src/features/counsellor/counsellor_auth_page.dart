import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'counsellor_home_page.dart';

class CounsellorAuthPage extends StatefulWidget {
  const CounsellorAuthPage({super.key});

  @override
  State<CounsellorAuthPage> createState() => _CounsellorAuthPageState();
}

class _CounsellorAuthPageState extends State<CounsellorAuthPage> {
  final _auth = FirebaseAuth.instance;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool isLogin = true;
  bool isLoading = false;

  final List<String> counsellingCategories = [
    "Anxiety",
    "Depression",
    "Marriage",
    "Addiction",
    "Trauma",
    "Career",
  ];

  final List<String> selectedCategories = [];

  Future<void> _submit() async {
    setState(() => isLoading = true);

    try {
      if (isLogin) {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CounsellorHomePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Authentication failed")),
      );
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? "Counsellor Login" : "Counsellor Register"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            // ✅ Bigger Logo (only change made)
            Image.asset(
              'assets/branding/openheart_logo_full_2048.png',
              height: 180, // ← increased slightly
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 30),

            if (!isLogin)
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                ),
              ),

            if (!isLogin) const SizedBox(height: 16),

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
            ),

            const SizedBox(height: 20),

            if (!isLogin) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Preferred Counselling Categories",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),

              Column(
                children: counsellingCategories.map((category) {
                  return CheckboxListTile(
                    title: Text(category),
                    value: selectedCategories.contains(category),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          selectedCategories.add(category);
                        } else {
                          selectedCategories.remove(category);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isLogin ? "Login" : "Register"),
              ),
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(
                isLogin
                    ? "Don't have an account? Register"
                    : "Already have an account? Login",
              ),
            ),

            const SizedBox(height: 10),

            if (!isLogin)
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = true;
                  });
                },
                child: const Text("Cancel"),
              ),
          ],
        ),
      ),
    );
  }
}
