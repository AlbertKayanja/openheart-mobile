import 'package:flutter/material.dart';
import '../counsellor/counsellor_auth_page.dart';

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // ✅ ORIGINAL LOGO (UNCHANGED)
            Image.asset(
              'assets/branding/openheart_logo_full_2048.png',
              width: 220, // slightly bigger as requested
            ),

            const SizedBox(height: 60),

            // ✅ I AM A COUNSELLOR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CounsellorAuthPage(),
                    ),
                  );
                },
                child: const Text(
                  'I am a Counsellor',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ✅ I NEED HELP
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  // future user flow
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User flow coming soon')),
                  );
                },
                child: const Text(
                  'I Need Help',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
