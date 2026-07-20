// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — e-Devlet Güvenli Giriş Simülasyonu
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pusula/data/services/settings_controller.dart';

class EDevletLoginScreen extends StatefulWidget {
  const EDevletLoginScreen({super.key});

  @override
  State<EDevletLoginScreen> createState() => _EDevletLoginScreenState();
}

class _EDevletLoginScreenState extends State<EDevletLoginScreen> {
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);
    // Gerçekçi bir gecikme
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pop(context, true); // Başarılı giriş
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsController>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text("türkiye.gov.tr", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFC42B24), // e-Devlet Kırmızısı
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Image.network(
              "https://static.turkiye.gov.tr/themes/ankara/assets/img/logos/logo.png",
              height: 60,
              errorBuilder: (_, __, ___) => const Icon(Icons.account_balance, size: 60, color: Color(0xFFC42B24)),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        settings.translate('edevlet_title'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        decoration: InputDecoration(
                          labelText: settings.translate('edevlet_username'),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: settings.translate('edevlet_password'),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC42B24),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(settings.translate('auth_login_btn')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              settings.translate('edevlet_footer'),
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
