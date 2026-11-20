import 'package:flutter/material.dart';
import '../widgets/form_widgets.dart';
import '../widgets/helpers.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _id = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FormPage(
      title: 'Forgot password',
      children: [
        Form(
          key: _form,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 45,
                child: Text('MCH',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              gap(16),
              const Text('Reset your password',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Text('Enter your email or phone number.\nWe send a code by SMS.',
                  textAlign: TextAlign.center),
              gap(20),
              field('Email or phone', _id),
              gap(16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (_form.currentState!.validate()) {
                      snack(context, 'Code sent (demo)');
                    }
                  },
                  child: const Text('Send code'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to log in'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
