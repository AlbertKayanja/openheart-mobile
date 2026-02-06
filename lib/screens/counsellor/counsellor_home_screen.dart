import 'package:flutter/material.dart';

class CounsellorHomeScreen extends StatelessWidget {
  const CounsellorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counsellor Dashboard')),
      body: const Center(
        child: Text(
          'Welcome, Counsellor\n\nIncoming requests will appear here.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
