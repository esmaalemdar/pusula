import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pusula/core/theme/app_colors.dart';
import 'package:pusula/data/services/settings_controller.dart';
import 'package:pusula/data/services/database_service.dart';
import '../../common_widgets/pusula_text_field.dart';
import '../home/home_screen.dart';
import 'widgets/auth_logo.dart';
import 'widgets/auth_switch_row.dart';
import 'widgets/auth_submit_button.dart';

enum AuthMode { login, signUp }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  AuthMode _mode = AuthMode.login;
  final _formKey = GlobalKey<FormState>();

  final _nameController     = TextEditingController();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController  = TextEditingController();

  final _nameFocus     = FocusNode();
  final _emailFocus    = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus  = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirm  = true;
  bool _isLoading       = false;

  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  void _switchMode() {
    _animController.reverse().then((_) {
      setState(() {
        _mode = _mode == AuthMode.login ? AuthMode.signUp : AuthMode.login;
        _formKey.currentState?.reset();
        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _confirmController.clear();
        _obscurePassword = true;
        _obscureConfirm  = true;
      });
      _animController.forward();
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final settings = Provider.of<SettingsController>(context, listen: false);
    final db       = DatabaseService();

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isLoading = false);

    final email    = _emailController.text.trim();
    final password = _passwordController.text;

    if (_mode == AuthMode.login) {
      // ── 1. E-posta kayıtlı mı? ──
      if (!db.isEmailRegistered(email)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(settings.translate('auth_email_not_found')),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ));
        return;
      }
      // ── 2. Şifre doğru mu? ──
      if (!db.validateLogin(email, password)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(settings.translate('auth_wrong_password')),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ));
        return;
      }
      // ── 3. Başarılı Giriş → HomeScreen ──
      if (!mounted) return;
      Navigator.pushReplacement(context, _fadeRoute(
        userName:  db.getUserName(email).split(' ').first,
        userEmail: email,
      ));
    } else {
      // ── Kayıt Ol: Hive'a kalıcı olarak yaz ──
      final name = _nameController.text.trim();
      await db.registerUser(email, password, name);
      if (!mounted) return;
      Navigator.pushReplacement(context, _fadeRoute(
        userName:  name.isNotEmpty ? name.split(' ').first : email.split('@')[0],
        userEmail: email,
      ));
    }
  }

  PageRouteBuilder _fadeRoute({required String userName, required String userEmail}) {
    return PageRouteBuilder(
      pageBuilder: (_, animation, __) => HomeScreen(
        userName:  userName,
        userEmail: userEmail,
      ),
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  String? _validateName(String? value) {
    final settings = Provider.of<SettingsController>(context, listen: false);
    if (value == null || value.trim().isEmpty) {
      return settings.translate('auth_name_empty');
    }
    if (value.trim().split(' ').length < 2) {
      return settings.translate('auth_name_invalid');
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final settings = Provider.of<SettingsController>(context, listen: false);
    if (value == null || value.trim().isEmpty) {
      return settings.translate('auth_email_empty');
    }
    final emailRegex = RegExp(r'^[\w\.\+\-]+@[\w\-]+\.[a-z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return settings.translate('auth_email_invalid');
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final settings = Provider.of<SettingsController>(context, listen: false);
    if (value == null || value.isEmpty) {
      return settings.translate('auth_password_empty');
    }
    if (value.length < 6) {
      return settings.translate('auth_password_invalid');
    }
    return null;
  }

  String? _validateConfirm(String? value) {
    final settings = Provider.of<SettingsController>(context, listen: false);
    if (value == null || value.isEmpty) {
      return settings.translate('auth_confirm_empty');
    }
    if (value != _passwordController.text) {
      return settings.translate('auth_passwords_mismatch');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = _mode == AuthMode.login;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.translucent,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: isLogin ? 72 : 48),
                  AuthLogo(mode: _mode),
                  SizedBox(height: isLogin ? 48 : 36),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildFormCard(isLogin),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AuthSubmitButton(mode: _mode, isLoading: _isLoading, onSubmit: _submit),
                  const SizedBox(height: 28),
                  AuthSwitchRow(mode: _mode, onSwitch: _switchMode),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard(bool isLogin) {
    final settings = Provider.of<SettingsController>(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!isLogin) ...[
              PusulaTextField(
                controller: _nameController,
                focusNode: _nameFocus,
                label: settings.translate('full_name'),
                hint: settings.translate('auth_name_hint'),
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.person_outline_rounded,
                validator: _validateName,
                onEditingComplete: () => _emailFocus.requestFocus(),
              ),
              const SizedBox(height: 14),
            ],
            PusulaTextField(
              controller: _emailController,
              focusNode: _emailFocus,
              label: settings.translate('email'),
              hint: 'ornek@mail.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              prefixIcon: Icons.mail_outline_rounded,
              validator: _validateEmail,
              onEditingComplete: () => _passwordFocus.requestFocus(),
            ),
            const SizedBox(height: 14),
            PusulaTextField(
              controller: _passwordController,
              focusNode: _passwordFocus,
              label: settings.translate('password'),
              hint: isLogin ? '••••••' : settings.translate('auth_password_hint'),
              obscureText: _obscurePassword,
              textInputAction: isLogin ? TextInputAction.done : TextInputAction.next,
              prefixIcon: Icons.lock_outline_rounded,
              suffixIcon: _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              onSuffixTap: () => setState(() => _obscurePassword = !_obscurePassword),
              validator: _validatePassword,
              onEditingComplete: isLogin ? _submit : () => _confirmFocus.requestFocus(),
            ),
            if (!isLogin) ...[
              const SizedBox(height: 14),
              PusulaTextField(
                controller: _confirmController,
                focusNode: _confirmFocus,
                label: settings.translate('confirm_password'),
                hint: settings.translate('auth_confirm_hint'),
                obscureText: _obscureConfirm,
                textInputAction: TextInputAction.done,
                prefixIcon: Icons.lock_outline_rounded,
                suffixIcon: _obscureConfirm
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                onSuffixTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
                validator: _validateConfirm,
                onEditingComplete: _submit,
              ),
            ],
            if (isLogin) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    debugPrint('Şifremi unuttum tapped');
                  },
                  child: Text(
                    settings.translate('auth_forgot_password'),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
