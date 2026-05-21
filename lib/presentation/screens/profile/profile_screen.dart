import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pusula/core/theme/app_colors.dart';
import 'package:pusula/data/services/settings_controller.dart';
import 'package:pusula/presentation/screens/auth/auth_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pusula/presentation/screens/auth/edevlet_login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  const ProfileScreen({super.key, required this.userName, required this.userEmail});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEDevletVerified = false;

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsController>(context);
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLight ? const Color(0xFFDAE8E3) : null,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _ProfileHeader(userName: widget.userName, userEmail: widget.userEmail, isVerified: _isEDevletVerified)),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _SectionTitle(title: settings.translate('personal_info')),
                _DetailGroup(items: [
                  _DetailItem(label: settings.translate('full_name'), value: widget.userName, icon: Icons.person_outline),
                  _DetailItem(label: settings.translate('email'), value: widget.userEmail, icon: Icons.alternate_email_rounded),
                ]),
                const SizedBox(height: 24),
                _SectionTitle(title: settings.translate('settings')),
                _DetailGroup(items: [
                  _SettingsToggleItem(
                    icon: Icons.dark_mode_outlined,
                    title: settings.translate('dark_mode'),
                    value: settings.isDarkMode,
                    onChanged: (v) => settings.toggleTheme(),
                  ),
                  _SettingsItem(
                    icon: Icons.language_rounded,
                    title: settings.translate('language'),
                    value: settings.language == AppLanguage.tr ? "Türkçe" : "English",
                    onTap: () => settings.setLanguage(settings.language == AppLanguage.tr ? AppLanguage.en : AppLanguage.tr),
                  ),
                ]),
                const SizedBox(height: 24),
                _SectionTitle(title: settings.translate('official_integrations')),
                _DetailGroup(items: [
                  _SettingsItem(
                    icon: Icons.account_balance_outlined,
                    title: settings.translate('edevlet_gateway'),
                    value: _isEDevletVerified ? settings.translate('verified_state') : settings.translate('verify'),
                    valueColor: _isEDevletVerified ? const Color(0xFF4CAF50) : const Color(0xFFC42B24),
                    onTap: () async {
                      if (!_isEDevletVerified) {
                        final Uri url = Uri.parse('https://giris.turkiye.gov.tr/');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                          // Otomatik doğrulama kaldırıldı, gerçekçi akış sağlandı.
                        }
                      }
                    },
                  ),
                ]),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const AuthScreen()), (r) => false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.05),
                    foregroundColor: Theme.of(context).colorScheme.error,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(settings.translate('logout'), style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String userName;
  final String userEmail;
  final bool isVerified;
  const _ProfileHeader({required this.userName, required this.userEmail, required this.isVerified});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(radius: 50, backgroundColor: Theme.of(context).colorScheme.surface, child: const Icon(Icons.person, size: 50, color: AppColors.accent)),
              if (isVerified)
                Positioned(bottom: 0, right: 0, child: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, shape: BoxShape.circle), child: Icon(Icons.verified, color: Theme.of(context).colorScheme.primary, size: 24))),
            ],
          ),
          const SizedBox(height: 16),
          Text(userName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(userEmail, style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6))),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(left: 4, bottom: 8), child: Text(title.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6), letterSpacing: 1.1)));
}

class _DetailGroup extends StatelessWidget {
  final List<Widget> items;
  const _DetailGroup({required this.items});
  @override
  Widget build(BuildContext context) => Container(decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20)), child: Column(children: items));
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;
  const _DetailItem({required this.label, required this.value, required this.icon, this.valueColor});
  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: Theme.of(context).iconTheme.color?.withOpacity(0.45), size: 20),
    title: Text(label, style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6))),
    trailing: Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: valueColor)),
  );
}

class _SettingsToggleItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SettingsToggleItem({required this.icon, required this.title, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: AppColors.accent),
    title: Text(title, style: const TextStyle(fontSize: 15)),
    trailing: Switch.adaptive(value: value, onChanged: onChanged),
  );
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? valueColor;
  final VoidCallback onTap;
  const _SettingsItem({required this.icon, required this.title, required this.value, this.valueColor, required this.onTap});
  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: AppColors.accent),
    title: Text(title, style: const TextStyle(fontSize: 15)),
    trailing: Row(mainAxisSize: MainAxisSize.min, children: [Text(value, style: TextStyle(color: valueColor ?? Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6), fontSize: 13)), Icon(Icons.chevron_right, size: 20, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6))]),
    onTap: onTap,
  );
}
