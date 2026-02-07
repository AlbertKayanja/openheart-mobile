import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CounsellorAuthPage extends StatefulWidget {
  const CounsellorAuthPage({super.key});

  @override
  State<CounsellorAuthPage> createState() => _CounsellorAuthPageState();
}

class _CounsellorAuthPageState extends State<CounsellorAuthPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  final _qualification = TextEditingController();
  final _experience = TextEditingController();

  bool isLogin = true;
  bool loading = false;

  final auth = FirebaseAuth.instance;

  Future<void> _submit() async {
    setState(() => loading = true);

    try {
      if (isLogin) {
        await auth.signInWithEmailAndPassword(
          email: _email.text.trim(),
          password: _password.text.trim(),
        );
      } else {
        await auth.createUserWithEmailAndPassword(
          email: _email.text.trim(),
          password: _password.text.trim(),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Success')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() => loading = false);
  }

  InputDecoration _field(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Counsellor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),

            Text(
              isLogin ? 'Counsellor Login' : 'Counsellor Registration',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            TextField(
              controller: _email,
              style: const TextStyle(color: Colors.white),
              decoration: _field('Email'),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _password,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: _field('Password'),
            ),

            if (!isLogin) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _name,
                style: const TextStyle(color: Colors.white),
                decoration: _field('Full Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _qualification,
                style: const TextStyle(color: Colors.white),
                decoration: _field('Qualification'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _experience,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: _field('Years of Experience'),
              ),
            ],

            const SizedBox(height: 32),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: loading ? null : _submit,
              child: Text(isLogin ? 'Login' : 'Register'),
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(
                isLogin
                    ? 'New counsellor? Register'
                    : 'Already registered? Login',
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
