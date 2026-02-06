import 'package:flutter/material.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: query assigned requests for this counsellor
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Requests',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            title: const Text('New request (Chat)'),
            subtitle: const Text('Client: anon_**** • Topic: Stress'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        )
      ],
    );
  }
}
