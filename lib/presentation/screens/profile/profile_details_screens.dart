import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pusula/core/theme/app_colors.dart';
import 'package:pusula/data/services/settings_controller.dart';

// ── 1. Uygulama Ayarları ──
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsController>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(settings.translate('settings')), 
        backgroundColor: Theme.of(context).cardColor, 
        elevation: 0.5, 
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SettingsSection(title: settings.translate('settings_appearance'), children: [
            _SwitchTile(
              title: settings.translate('dark_mode'), 
              value: settings.isDarkMode, 
              icon: Icons.dark_mode_outlined,
              onChanged: (_) => settings.toggleTheme(),
            ),
            _SwitchTile(
              title: settings.translate('settings_fast_animations'), 
              value: true, 
              icon: Icons.speed_rounded,
              onChanged: (_) {},
            ),
          ]),
          const SizedBox(height: 20),
          _SettingsSection(title: settings.translate('settings_notifications'), children: [
            _SwitchTile(
              title: settings.translate('settings_push_notifications'), 
              value: true, 
              icon: Icons.notifications_active_outlined,
              onChanged: (_) {},
            ),
            _SwitchTile(
              title: settings.translate('settings_email_newsletter'), 
              value: false, 
              icon: Icons.email_outlined,
              onChanged: (_) {},
            ),
          ]),
          const SizedBox(height: 20),
          _SettingsSection(title: settings.translate('language'), children: [
            ListTile(
              leading: const Icon(Icons.language_rounded, color: AppColors.accent),
              title: Text(settings.translate('settings_app_language')),
              trailing: Text(
                settings.language == AppLanguage.tr ? "Türkçe 🇹🇷" : "English 🇬🇧", 
                style: const TextStyle(color: AppColors.text600),
              ),
              onTap: () {
                settings.setLanguage(settings.language == AppLanguage.tr ? AppLanguage.en : AppLanguage.tr);
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
    final settings = Provider.of<SettingsController>(context);
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(settings.translate('vault_title'), style: TextStyle(color: cs.onSurface)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: cs.onSurface),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_person_rounded, size: 80, color: AppColors.accent),
          const SizedBox(height: 24),
          Text(settings.translate('vault_locked'), style: TextStyle(color: cs.onSurface, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              settings.translate('vault_auth_hint'), 
              textAlign: TextAlign.center, 
              style: TextStyle(color: cs.onSurface.withOpacity(0.7)),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(settings.translate('vault_scanning'))));
            },
            icon: const Icon(Icons.fingerprint_rounded),
            label: Text(settings.translate('vault_unlock')),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent, 
              foregroundColor: cs.onPrimary, 
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
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
    final settings = Provider.of<SettingsController>(context);
    final isTr = settings.language == AppLanguage.tr;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(settings.translate('calendar_title')), 
        backgroundColor: Theme.of(context).cardColor, 
        elevation: 0.5, 
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _CalendarEvent(
            date: isTr ? "12 Mayıs" : "12 May", 
            title: settings.translate('calendar_event_eviction'), 
            type: settings.translate('calendar_event_type_court'),
          ),
          _CalendarEvent(
            date: isTr ? "15 Mayıs" : "15 May", 
            title: settings.translate('calendar_event_passport'), 
            type: settings.translate('calendar_event_type_appointment'),
          ),
          _CalendarEvent(
            date: isTr ? "20 Mayıs" : "20 May", 
            title: settings.translate('calendar_event_tax'), 
            type: settings.translate('calendar_event_type_payment'),
          ),
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
  final ValueChanged<bool>? onChanged;
  const _SwitchTile({required this.title, required this.value, required this.icon, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).iconTheme.color?.withOpacity(0.55)),
      title: Text(title),
      trailing: Switch.adaptive(value: value, onChanged: onChanged, activeColor: AppColors.accent),
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



