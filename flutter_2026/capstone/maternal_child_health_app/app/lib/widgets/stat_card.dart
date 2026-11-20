import 'package:flutter/material.dart';

Widget statCard(String label, String value, {VoidCallback? onTap}) {
  return Card(
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          children: [
            Text(value,
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            Text(label),
          ],
        ),
      ),
    ),
  );
}
