import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pusula/data/services/settings_controller.dart';
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
    final settings = Provider.of<SettingsController>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          settings.translate(isLogin ? 'auth_no_account' : 'auth_have_account'),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.text600,
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onSwitch,
          child: Text(
            settings.translate(isLogin ? 'auth_register_now' : 'auth_login_btn'),
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
