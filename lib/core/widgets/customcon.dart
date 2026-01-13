import 'package:flutter/material.dart';

class Maincus extends StatelessWidget {
  const Maincus({super.key, required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.blueAccent,
        ),
        child: child,
      ),
    );
  }
}
