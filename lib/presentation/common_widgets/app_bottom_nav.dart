import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pusula/core/theme/app_colors.dart';
import 'package:pusula/data/services/settings_controller.dart';

class AppBottomNav extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onIndexChanged;

  const AppBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsController>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.black : Colors.white;
    final selectedColor = Colors.greenAccent;
    final unselectedColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final indicatorColor = isDark ? Colors.green.withOpacity(0.2) : Colors.green.withOpacity(0.12);

    return Theme(
      data: Theme.of(context).copyWith(
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: bgColor,
          surfaceTintColor: Colors.transparent,
          indicatorColor: indicatorColor,
          indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: selectedColor);
            }
            return TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: unselectedColor);
          }),
          iconTheme: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return IconThemeData(color: selectedColor, size: 26);
            }
            return IconThemeData(color: unselectedColor, size: 24);
          }),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          height: 72,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: isDark ? const Color(0xFF333333) : const Color(0xFFE8ECEF), width: 1)),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onIndexChanged,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home_rounded),
              label: settings.translate('home'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.assignment_outlined),
              selectedIcon: const Icon(Icons.assignment_rounded),
              label: settings.translate('procedures'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.archive_outlined),
              selectedIcon: const Icon(Icons.archive_rounded),
              label: settings.translate('archive'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline_rounded),
              selectedIcon: const Icon(Icons.person_rounded),
              label: settings.translate('profile'),
            ),
          ],
        ),
      ),
    );
  }
}
