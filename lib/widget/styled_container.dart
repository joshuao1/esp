import 'package:flutter/material.dart';

class StyledContainer extends StatelessWidget {
  final Widget child;
  final Color color;

  const StyledContainer({
    super.key,
    required this.child,
    this.color = const Color.fromARGB(255, 255, 255, 255),
  });

  @override
  Widget build(BuildContext context) {
    // If the color is white (default), use our dark surface color instead.
    final effectiveColor = color == const Color.fromARGB(255, 255, 255, 255)
        ? const Color(0xFF1A1A2E)
        : color;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(12.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: const Color(0xFFFF00FF).withOpacity(0.8),
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 0),
            color: const Color(0xFFFF00FF).withOpacity(0.3),
          ),
        ],
      ),
      child: child,
    );
  }
}
