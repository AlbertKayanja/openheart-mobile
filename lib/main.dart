import 'package:flutter/material.dart';
import 'src/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OpenHeartApp());
}

class OpenHeartApp extends StatelessWidget {
  const OpenHeartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenHeart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: '/',
    );
  }
}
