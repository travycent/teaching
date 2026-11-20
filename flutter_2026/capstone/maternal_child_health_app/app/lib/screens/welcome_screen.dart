import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../widgets/helpers.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                child: Text('MCH',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              ),
              gap(24),
              const Text(
                'Welcome to Maternal and Child Health Monitoring System!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              gap(32),
              FilledButton(
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen())),
                child: const Text('Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
