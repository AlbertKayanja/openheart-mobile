import 'package:flutter/material.dart';
import 'features/entry/entry_screen.dart';
import 'features/counsellor/counsellor_auth_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const EntryScreen(),
        );

      case '/counsellor-auth':
        return MaterialPageRoute(
          builder: (_) => const CounsellorAuthPage(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const EntryScreen(),
        );
    }
  }
}
