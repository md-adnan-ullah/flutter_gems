import 'package:flutter/material.dart';
import 'package:gems_responsive/gems_responsive.dart';

void main() {
  runApp(const FlutterGemsApp());
}

class FlutterGemsApp extends StatelessWidget {
  const FlutterGemsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Gems',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GemsHomePage(),
    );
  }
}

class GemsHomePage extends StatelessWidget {
  const GemsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Gems'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Flutter Gems',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Your Flutter project is ready!',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
