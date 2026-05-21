import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../auth_screen.dart';

class AuthSwitchRow extends StatelessWidget {
  final AuthMode mode;
  final VoidCallback onSwitch;

  const AuthSwitchRow({
    super.key,
    required this.mode,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    final isLogin = mode == AuthMode.login;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLogin ? 'Hesabınız yok mu?' : 'Zaten hesabınız var mı?',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.text600,
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onSwitch,
          child: Text(
            isLogin ? 'Kayıt Ol' : 'Giriş Yap',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.accent,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.accent,
              decorationThickness: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}



