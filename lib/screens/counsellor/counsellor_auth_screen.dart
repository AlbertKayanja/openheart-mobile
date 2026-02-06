import 'package:flutter/material.dart';

class CounsellorAuthScreen extends StatefulWidget {
  const CounsellorAuthScreen({super.key});

  @override
  State<CounsellorAuthScreen> createState() => _CounsellorAuthScreenState();
}

class _CounsellorAuthScreenState extends State<CounsellorAuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counsellor Access')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ToggleButtons(
              isSelected: [isLogin, !isLogin],
              onPressed: (index) {
                setState(() => isLogin = index == 0);
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Login'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Register'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            TextField(decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/counsellor-home',
                );
              },
              child: Text(isLogin ? 'Login' : 'Register'),
            ),
          ],
        ),
      ),
    );
  }
}
