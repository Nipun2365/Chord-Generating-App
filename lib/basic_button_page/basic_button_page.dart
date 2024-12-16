import 'package:flutter/material.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final Color? color;
  final Color? textColor;  // Add textColor parameter for button text

  const BasicAppButton({
    required this.onPressed,
    required this.title,
    this.color,
    this.textColor,  // Initialize textColor
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.blue, // Button background color
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            color: textColor ?? Colors.white, // Apply the text color
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
