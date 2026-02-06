import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/subscription_service.dart';

class CounsellorsScreen extends StatefulWidget {
  const CounsellorsScreen({super.key});

  @override
  State<CounsellorsScreen> createState() => _CounsellorsScreenState();
}

class _CounsellorsScreenState extends State<CounsellorsScreen> {
  final _subscriptionService = SubscriptionService();

  @override
  Widget build(BuildContext context) {
    final hasSubStream = _subscriptionService.watchHasActiveSubscription();

    return StreamBuilder<bool>(
      stream: hasSubStream,
      initialData: false,
      builder: (context, snapshot) {
        final hasSub = snapshot.data ?? false;

        if (!hasSub) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Subscribe to see available counsellors',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => GoRouter.of(context).push('/client/subscription'),
                  child: const Text('Choose a plan'),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Available Counsellors',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 12),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('counsellors')
                  .where('online', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No counsellors online right now'));
                }

                final counsellors = snapshot.data!.docs;

                return Column(
                  children: counsellors.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return _CounsellorCard(
                      alias: data['alias'] ?? 'Counsellor',
                      rating: (data['ratingAvg'] as num?)?.toDouble() ?? 0.0,
                      tags: List<String>.from(data['tags'] ?? []),
                      online: data['online'] ?? false,
                    );
                  }).toList(),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _CounsellorCard extends StatelessWidget {
  final String alias;
  final double rating;
  final List<String> tags;
  final bool online;

  const _CounsellorCard({
    required this.alias,
    required this.rating,
    required this.tags,
    required this.online,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    alias,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: online ? Colors.green.withOpacity(0.15) : Colors.grey.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    online ? 'Online' : 'Offline',
                    style: TextStyle(
                      color: online ? Colors.green[800] : Colors.grey[800],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '⭐ ${rating.toStringAsFixed(1)}  •  ${tags.join(" • ")}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: online
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Chat started (TODO)')),
                            );
                          }
                        : null,
                    child: const Text('Chat'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: online
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Voice call (TODO)')),
                            );
                          }
                        : null,
                    child: const Text('Voice'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}