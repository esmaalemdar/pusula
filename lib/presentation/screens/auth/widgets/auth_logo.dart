import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../auth_screen.dart';

class AuthLogo extends StatelessWidget {
  final AuthMode mode;

  const AuthLogo({
    super.key,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    final isLogin = mode == AuthMode.login;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'PUS',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text900,
                  letterSpacing: -1.5,
                  height: 1.0,
                ),
              ),
              TextSpan(
                text: 'ULA',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 38,
                  fontWeight: FontWeight.w300,
                  color: AppColors.accent,
                  letterSpacing: -1.5,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: Text(
            isLogin ? 'Hesabınıza giriş yapın' : 'Yeni hesap oluşturun',
            key: ValueKey(mode),
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.text600,
              height: 1.5,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ],
    );
  }
}



