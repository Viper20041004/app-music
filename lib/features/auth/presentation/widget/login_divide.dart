import 'package:flutter/material.dart';

class LoginDivider extends StatelessWidget {
  const LoginDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: Colors.white,
            thickness: 0.7,
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'or',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),

        const Expanded(
          child: Divider(
            color: Colors.white,
            thickness: 0.7,
          ),
        ),
      ],
    );
  }
}