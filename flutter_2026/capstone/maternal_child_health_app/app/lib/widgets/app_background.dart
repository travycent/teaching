import 'package:flutter/material.dart';

/// Shows assets/images/background.png faintly behind every screen.
/// If the picture is missing, the background is just white.
class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => const SizedBox(),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
