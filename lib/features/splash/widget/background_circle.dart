import 'package:flutter/material.dart';

class BackgroundCircle extends StatelessWidget {
  final double size;

  const BackgroundCircle({
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF0AAEC1),
        gradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF08AFC1), // phía trên - đậm
            Color(0xFF08AFC1), // giữ màu đậm
            Color(0xFF20B8C8), // bắt đầu sáng
            Color(0xFF5ED1DF), // phía dưới - nhạt
          ],
          stops: [
            0.0,
            0.6,
            0.75,
            1.0,
          ],
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withValues(alpha: 0.05),
        //     blurRadius: 10,
        //     spreadRadius: 2,
        //   ),
        // ],
      ),
    );
  }
}