import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CounsellorAuthPage extends StatefulWidget {
  const CounsellorAuthPage({super.key});

  @override
  State<CounsellorAuthPage> createState() => _CounsellorAuthPageState();
}

class _CounsellorAuthPageState extends State<CounsellorAuthPage> {
  bool isLogin = true;
  bool loading = false;

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final qualificationCtrl = TextEditingController();
  final experienceCtrl = TextEditingController();

  Future<void> _submit() async {
    setState(() => loading = true);

    try {
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailCtrl.text.trim(),
          password: passwordCtrl.text.trim(),
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailCtrl.text.trim(),
          password: passwordCtrl.text.trim(),
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isLogin
              ? 'Login successful'
              : 'Registration successful'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Auth error')),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counsellor Access'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Image.asset(
              'assets/branding/openheart_icon_1024.png',
              height: 80,
            ),
            const SizedBox(height: 24),

            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),

            if (!isLogin) ...[
              const SizedBox(height: 12),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: qualificationCtrl,
                decoration:
                    const InputDecoration(labelText: 'Qualification'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: experienceCtrl,
                decoration:
                    const InputDecoration(labelText: 'Experience (years)'),
                keyboardType: TextInputType.number,
              ),
            ],

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
              child: loading
                  ? const CircularProgressIndicator()
                  : Text(isLogin ? 'Login' : 'Register'),
            ),

            TextButton(
              onPressed: () {
                setState(() => isLogin = !isLogin);
              },
              child: Text(isLogin
                  ? 'New counsellor? Register'
                  : 'Already registered? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
