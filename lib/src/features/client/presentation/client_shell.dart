import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/subscription_service.dart';
import 'home_screen.dart';
import 'history_screen.dart';
import 'subscription_screen.dart';
import 'counsellors_screen.dart';

class ClientShell extends StatefulWidget {
  const ClientShell({super.key});

  @override
  State<ClientShell> createState() => _ClientShellState();
}

class _ClientShellState extends State<ClientShell> {
  int _index = 0;

  final _subscriptionService = SubscriptionService();

  @override
  Widget build(BuildContext context) {
    final hasSubStream = _subscriptionService.watchHasActiveSubscription();

    final pages = <Widget>[
      const HomeScreen(),
      const HistoryScreen(),
      const SubscriptionScreen(),
    ];

    return Scaffold(
      body: pages[_index],
      floatingActionButton: StreamBuilder<bool>(
        stream: hasSubStream,
        initialData: false,
        builder: (context, snapshot) {
          final hasSub = snapshot.data ?? false;

          return FloatingActionButton.extended(
            onPressed: hasSub
                ? () => GoRouter.of(context).push('/client/request')
                : () => GoRouter.of(context).push('/client/subscription'),
            icon: const Icon(Icons.chat_bubble_outline),
            label: Text(hasSub ? 'Request help' : 'Subscribe to get help'),
            backgroundColor: hasSub ? null : Colors.grey,
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_border),
            selectedIcon: Icon(Icons.star),
            label: 'Pro',
          ),
        ],
      ),
    );
  }
}