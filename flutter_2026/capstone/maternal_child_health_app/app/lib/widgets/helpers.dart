import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../services/store.dart';

void go(BuildContext c, Widget w) =>
    Navigator.push(c, MaterialPageRoute(builder: (_) => w));

void logout(BuildContext c) {
  Store.current = null;
  Navigator.pushAndRemoveUntil(
    c,
    MaterialPageRoute(builder: (_) => const LoginScreen()),
    (route) => false,
  );
}

void snack(BuildContext c, String msg) =>
    ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(msg)));

Widget gap([double h = 14]) => SizedBox(height: h);
