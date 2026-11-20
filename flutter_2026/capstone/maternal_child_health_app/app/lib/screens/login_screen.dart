import 'package:flutter/material.dart';
import '../models/app_user.dart';
import 'admin_home.dart';
import 'forgot_password_screen.dart';
import 'health_worker_home.dart';
import 'mother_home.dart';
import 'register_screen.dart';
import '../services/store.dart';
import '../widgets/form_widgets.dart';
import '../widgets/helpers.dart';

Widget homeFor(AppUser u) {
  switch (u.role) {
    case 'Admin':
      return const AdminHome();
    case 'Health Worker':
      return const HealthWorkerHome();
    default:
      return const MotherHome();
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _pass = TextEditingController();
  bool _hide = true;

  @override
  void dispose() {
    _id.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _login() {
    if (!_form.currentState!.validate()) return;
    final id = _id.text.trim();
    final matches = Store.users.where(
        (u) => (u.email == id || u.phone == id) && u.password == _pass.text);
    if (matches.isEmpty) {
      snack(context, 'Wrong email/phone or password');
      return;
    }
    final u = matches.first;
    if (!u.active) {
      snack(context, 'This account is inactive');
      return;
    }
    Store.current = u;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => homeFor(u)));
  }

  @override
  Widget build(BuildContext context) {
    return FormPage(
      title: 'Login',
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
              gap(12),
              const Text('Maternal & Child Health Platform',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Text('Sign in to continue'),
              gap(24),
              field('Email / Phone number', _id),
              gap(16),
              TextFormField(
                controller: _pass,
                obscureText: _hide,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _hide ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _hide = !_hide),
                  ),
                ),
                validator: (v) =>
                   (v == null || v.isEmpty)
    ? 'Password is required'
    : (v.length < 6 || v.length > 8)
        ? 'Password must be 6 to 8 characters'
        : null,
              ),
              gap(20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: _login, child: const Text('Log in')),
              ),
              TextButton(
                onPressed: () => go(context, const ForgotPasswordScreen()),
                child: const Text('Forgot password?'),
              ),
              TextButton(
                onPressed: () => go(context, const RegisterScreen()),
                child: const Text('Create new account'),
              ),
              gap(8),
              const Text(
                'Demo logins (password Pass#1):\nmother@mch.com  |  worker@mch.com  |  admin@mch.com',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 60, 7, 152)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
