import 'package:app_music/app/theme/app_colors.dart';
import 'package:app_music/features/auth/presentation/page/sign_in_screen.dart';
import 'package:flutter/material.dart';

class WelcomeBottomContent extends StatelessWidget {
  const WelcomeBottomContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 265,
      padding: const EdgeInsets.fromLTRB(
        25,
        28,
        25,
        50,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF03090A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Text
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                height: 1.3,
                fontWeight: FontWeight.w600,
              ),
              children: [
                const TextSpan(
                  text: 'From the ',
                ),
                TextSpan(
                  text: 'latest',
                  style: TextStyle(
                    color: AppColors.primaryDark,
                  ),
                ),
                const TextSpan(
                  text: ' to the\n',
                ),
                TextSpan(
                  text: 'greatest',
                  style: TextStyle(
                    color: AppColors.primaryDark,
                  ),
                ),
                const TextSpan(
                  text: ' hits, play your\n'
                      'favorite tracks on ',
                ),
                TextSpan(
                  text: 'musium',
                  style: TextStyle(
                    color: AppColors.primaryDark,
                  ),
                ),
                const TextSpan(
                  text: '\nnow!',
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),

          const Spacer(),

          // Get Started
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SignInScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                elevation: 8,
                shadowColor: AppColors.primaryDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}