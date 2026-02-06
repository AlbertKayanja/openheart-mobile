import 'package:flutter/material.dart';

class AvailabilityScreen extends StatefulWidget {
  const AvailabilityScreen({super.key});

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  bool online = true;
  bool chat = true;
  bool voice = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Availability',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        Card(
          child: SwitchListTile(
            title: const Text('Go online'),
            subtitle: const Text('Clients can request sessions when you are online.'),
            value: online,
            onChanged: (v) => setState(() => online = v),
          ),
        ),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Chat sessions'),
                value: chat,
                onChanged: online ? (v) => setState(() => chat = v) : null,
              ),
              SwitchListTile(
                title: const Text('Voice sessions'),
                value: voice,
                onChanged: online ? (v) => setState(() => voice = v) : null,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: () {
            // TODO: write counsellor availability to Firestore
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('TODO: Save availability to backend')),
            );
          },
          child: const Text('Save'),
        )
      ],
    );
  }
}
