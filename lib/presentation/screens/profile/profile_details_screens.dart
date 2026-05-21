// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Profil Detay Ekranları
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:pusula/core/theme/app_colors.dart';

// ── 1. Uygulama Ayarları ──
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Ayarlar'), backgroundColor: Theme.of(context).cardColor, elevation: 0.5, foregroundColor: Theme.of(context).textTheme.bodyLarge?.color),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SettingsSection(title: "Görünüm", children: [
            _SwitchTile(title: "Karanlık Mod", value: false, icon: Icons.dark_mode_outlined),
            _SwitchTile(title: "Hızlı Animasyonlar", value: true, icon: Icons.speed_rounded),
          ]),
          const SizedBox(height: 20),
          _SettingsSection(title: "Bildirimler", children: [
            _SwitchTile(title: "Anlık Bildirimler", value: true, icon: Icons.notifications_active_outlined),
            _SwitchTile(title: "E-Posta Bülteni", value: false, icon: Icons.email_outlined),
          ]),
          const SizedBox(height: 20),
          _SettingsSection(title: "Dil", children: [
            ListTile(
              leading: const Icon(Icons.language_rounded, color: AppColors.accent),
              title: const Text("Uygulama Dili"),
              trailing: const Text("Türkçe 🇹🇷", style: TextStyle(color: AppColors.text600)),
              onTap: () {
                debugPrint('Profile photo tapped');
              },
            ),
          ]),
        ],
      ),
    );
  }
}

// ── 2. Belge Kasası (Secure Vault) ──
class VaultScreen extends StatelessWidget {
  const VaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text('Belge Kasası', style: TextStyle(color: cs.onSurface)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: cs.onSurface),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_person_rounded, size: 80, color: AppColors.accent),
          const SizedBox(height: 24),
          Text("Kasa Kilitli", style: TextStyle(color: cs.onSurface, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text("Hassas belgelerinize erişmek için lütfen biyometrik doğrulama yapın.", 
              textAlign: TextAlign.center, style: TextStyle(color: cs.onSurface.withOpacity(0.7))),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("FaceID/Parmak İzi Okunuyor...")));
            },
            icon: const Icon(Icons.fingerprint_rounded),
            label: const Text("Kilidi Aç"),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: cs.onPrimary, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
          ),
        ],
      ),
    );
  }
}

// ── 3. Hukuki Takvim ──
class LegalCalendarScreen extends StatelessWidget {
  const LegalCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Hukuki Takvim'), backgroundColor: Theme.of(context).cardColor, elevation: 0.5, foregroundColor: Theme.of(context).textTheme.bodyLarge?.color),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _CalendarEvent(date: "12 Mayıs", title: "Duruşma: Kira Tahliye", type: "Mahkeme"),
          _CalendarEvent(date: "15 Mayıs", title: "Pasaport Teslim Günü", type: "Randevu"),
          _CalendarEvent(date: "20 Mayıs", title: "Vergi Yapılandırma Son Gün", type: "Ödeme"),
        ],
      ),
    );
  }
}

// ── Yardımcı Widget'lar ──
class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.accent, letterSpacing: 0.5)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.2))),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final IconData icon;
  const _SwitchTile({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).iconTheme.color?.withOpacity(0.55)),
      title: Text(title),
      trailing: Switch.adaptive(value: value, onChanged: (v) {}, activeColor: AppColors.accent),
    );
  }
}

class _CalendarEvent extends StatelessWidget {
  final String date;
  final String title;
  final String type;
  const _CalendarEvent({required this.date, required this.title, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.2))),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
            child: Text(date.split(" ")[0], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(type, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.55), fontSize: 12)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: Theme.of(context).iconTheme.color?.withOpacity(0.4)),
        ],
      ),
    );
  }
}



