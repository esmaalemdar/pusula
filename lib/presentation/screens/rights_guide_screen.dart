import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pusula/core/theme/app_colors.dart';
import 'package:pusula/data/services/settings_controller.dart';

class RightsGuideScreen extends StatelessWidget {
  const RightsGuideScreen({super.key});

  static const _scenarios = [
    _RightsScenario(
      titleKey: 'rights_guide_eviction_title',
      icon: Icons.home_outlined,
      highlightKeys: [
        'rights_guide_eviction_h1',
        'rights_guide_eviction_h2',
        'rights_guide_eviction_h3',
        'rights_guide_eviction_h4',
      ],
    ),
    _RightsScenario(
      titleKey: 'rights_guide_refund_title',
      icon: Icons.shopping_bag_outlined,
      highlightKeys: [
        'rights_guide_refund_h1',
        'rights_guide_refund_h2',
        'rights_guide_refund_h3',
        'rights_guide_refund_h4',
      ],
    ),
    _RightsScenario(
      titleKey: 'rights_guide_employment_title',
      icon: Icons.work_outline,
      highlightKeys: [
        'rights_guide_employment_h1',
        'rights_guide_employment_h2',
        'rights_guide_employment_h3',
        'rights_guide_employment_h4',
      ],
    ),
    _RightsScenario(
      titleKey: 'rights_guide_privacy_title',
      icon: Icons.privacy_tip_outlined,
      highlightKeys: [
        'rights_guide_privacy_h1',
        'rights_guide_privacy_h2',
        'rights_guide_privacy_h3',
        'rights_guide_privacy_h4',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(settings.translate('rights_guide_title')),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        itemCount: _scenarios.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final scenario = _scenarios[index];
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: AppColors.primary.withOpacity(0.14)),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(scenario.icon, color: AppColors.primary, size: 24),
                ),
                title: Text(
                  settings.translate(scenario.titleKey),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    height: 1.3,
                  ),
                ),
                children: scenario.highlightKeys.map((itemKey) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 3, right: 10),
                          child: Icon(Icons.circle, size: 6, color: AppColors.text600),
                        ),
                        Expanded(
                          child: Text(
                            settings.translate(itemKey),
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.6,
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RightsScenario {
  final String titleKey;
  final IconData icon;
  final List<String> highlightKeys;

  const _RightsScenario({
    required this.titleKey,
    required this.icon,
    required this.highlightKeys,
  });
}



