import 'package:flutter/material.dart';

class CounsellorProfileScreen extends StatelessWidget {
  const CounsellorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: counsellor subscription, ratings, profile editing
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Profile',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Alias: Counsellor A23'),
                const SizedBox(height: 6),
                const Text('Rating: ⭐ 4.8 (120)'),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('TODO: Counsellor subscription paywall')),
                    );
                  },
                  child: const Text('Manage subscription'),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
