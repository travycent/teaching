import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../services/store.dart';
import '../widgets/form_widgets.dart';
import '../widgets/helpers.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _pass = TextEditingController();
  String? _role = 'Mother';

  void _save() {
    if (!_form.currentState!.validate()) return;
    final email = _email.text.trim();
    if (Store.users.any((u) => u.email == email)) {
      snack(context, 'That email is already registered');
      return;
    }
    Store.users.add(AppUser(_name.text.trim(), email, _phone.text.trim(),
        _pass.text, _role ?? 'Mother'));
    snack(context, 'Account created');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FormPage(
      title: 'New account',
      children: [
        Form(
          key: _form,
          child: Column(
            children: [
              field('Full name', _name),
              gap(),
              field('Email', _email, type: TextInputType.emailAddress),
              gap(),
              field('Phone', _phone, type: TextInputType.phone),
              gap(),
              TextFormField(
                controller: _pass,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Password', border: OutlineInputBorder()),
                validator: (v) =>
                    (v == null || v.length < 4) ? 'Minimum 4 characters' : null,
              ),
              gap(),
              dropdown<String>(
                label: 'Role',
                value: _role,
                items: const ['Mother', 'Health Worker', 'Admin'],
                text: (s) => s,
                onChanged: (v) => setState(() => _role = v),
              ),
              gap(20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: _save, child: const Text('Register')),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Have an account? Log in'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
