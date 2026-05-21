import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pusula/core/theme/app_colors.dart';
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

  // Kayıtlı e-posta adresleri (uygulama oturumu boyunca hafızada tutulur)
  static final Set<String> _registeredEmails = {};

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

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
        _obscureConfirm = true;
      });
      _animController.forward();
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    // Hızlı simülasyon gecikmesi
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;
    setState(() => _isLoading = false);

    final email = _emailController.text.trim();

    if (_mode == AuthMode.login) {
      // Kayıt olmadan giriş yapılmasını engelle
      if (!_registeredEmails.contains(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bu e-posta adresiyle kayıtlı bir hesap bulunamadı. Lütfen önce kayıt olunuz.'),
            backgroundColor: Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
    } else {
      // Kayıt modunda e-postayı kayıt listesine ekle
      _registeredEmails.add(email);
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => HomeScreen(
          userName: _nameController.text.isEmpty ? 'Esma' : _nameController.text.split(' ')[0],
          userEmail: _emailController.text.isEmpty ? 'esma@mail.com' : _emailController.text,
        ),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ad soyad boş bırakılamaz';
    }
    if (value.trim().split(' ').length < 2) {
      return 'Lütfen adınızı ve soyadınızı giriniz';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-posta adresi boş bırakılamaz';
    }
    final emailRegex = RegExp(r'^[\w\.\+\-]+@[\w\-]+\.[a-z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Geçerli bir e-posta adresi giriniz';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre boş bırakılamaz';
    }
    if (value.length < 6) {
      return 'Şifre en az 6 karakter olmalıdır';
    }
    return null;
  }

  String? _validateConfirm(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre tekrarı boş bırakılamaz';
    }
    if (value != _passwordController.text) {
      return 'Şifreler eşleşmiyor';
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
            PusulaTextField(
              controller: _nameController,
              focusNode: _nameFocus,
              label: 'Ad Soyad',
              hint: 'Adınız ve Soyadınız',
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              prefixIcon: Icons.person_outline_rounded,
              validator: _validateName,
              onEditingComplete: () => _emailFocus.requestFocus(),
            ),
            const SizedBox(height: 14),
            PusulaTextField(
              controller: _emailController,
              focusNode: _emailFocus,
              label: 'E-posta adresi',
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
              label: 'Şifre',
              hint: isLogin ? '••••••' : 'En az 6 karakter',
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
                label: 'Şifreyi Tekrarla',
                hint: 'Şifrenizi tekrar girin',
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
                  child: const Text(
                    'Şifremi Unuttum',
                    style: TextStyle(
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



