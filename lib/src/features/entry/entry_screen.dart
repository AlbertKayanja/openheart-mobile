import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../counsellor/counsellor_auth_page.dart';

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // ✅ LOGO (correct pubspec path)
                Image.asset(
                  'assets/branding/openheart_logo_full_2048.png',
                  height: 220,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 40),

                Text(
                  "Welcome to OpenHeart",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 50),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CounsellorAuthPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "I am a Counsellor",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
