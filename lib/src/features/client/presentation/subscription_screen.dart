import 'package:flutter/material.dart';

import '../../../data/subscription_service.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final _subscriptionService = SubscriptionService();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Choose Your Plan',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 24),

        _PlanCard(
          title: 'Daily Access',
          price: 'KSh 150 / day',
          onTap: () async {
            await _subscriptionService.createSubscription(plan: 'day');
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment flow started (TODO – integrate real checkout)'),
                ),
              );
            }
          },
        ),
        const SizedBox(height: 16),

        _PlanCard(
          title: 'Weekly Access',
          price: 'KSh 800 / week',
          onTap: () async {
            await _subscriptionService.createSubscription(plan: 'week');
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment flow started (TODO)')),
              );
            }
          },
        ),
        const SizedBox(height: 16),

        _PlanCard(
          title: 'Monthly Access',
          price: 'KSh 2,500 / month',
          onTap: () async {
            await _subscriptionService.createSubscription(plan: 'month');
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment flow started (TODO)')),
              );
            }
          },
        ),

        const SizedBox(height: 32),
        const Text(
          'All plans give full access to counsellors, chat & voice sessions.',
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: const TextStyle(fontSize: 24, color: Colors.green),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onTap,
              child: const Text('Select Plan'),
            ),
          ],
        ),
      ),
    );
  }
}