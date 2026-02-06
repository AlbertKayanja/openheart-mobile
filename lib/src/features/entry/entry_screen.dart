import 'package:flutter/material.dart';

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/branding/openheart_logo_full_2048.png',
                height: 140,
              ),
              const SizedBox(height: 48),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 52),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/counsellor-auth');
                },
                child: const Text('I am a Counsellor'),
              ),

              const SizedBox(height: 16),

              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  side: const BorderSide(color: Colors.white),
                ),
                onPressed: () {
                  // NOT touched — future flow
                },
                child: const Text('I Need Help'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
