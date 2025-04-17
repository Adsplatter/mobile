import 'package:flutter/material.dart';

class TestingScreen extends StatefulWidget {
  const TestingScreen({super.key});

  /// Mandatory
  static const routeName = '/home';

  @override
  State<TestingScreen> createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  String logOutput = '';

  void testFunction() {
    setState(() {
      logOutput = 'Function executed at ${DateTime.now()}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧪 Testing Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Use this screen to test widgets, functions, UI elements, etc.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: testFunction,
              child: const Text('Run Test Function'),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                logOutput.isNotEmpty ? logOutput : 'No output yet.',
                style: const TextStyle(fontSize: 14),
              ),
            ),

            const SizedBox(height: 32),

            // 🧱 Place your custom widget tests here:
            const Placeholder(
              fallbackHeight: 100,
              color: Colors.deepPurple,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
