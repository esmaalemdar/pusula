// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Akıllı Arama Çubuğu Widget'ı
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/services/settings_controller.dart';
import '../../../../data/services/smart_search_service.dart';
import '../../../../data/models/procedure_model.dart';
import '../../procedures/generic_detail_screen.dart';

class SmartSearchBar extends StatefulWidget {
  final Function(ProcedureCategory) onCategoryMatch;
  
  const SmartSearchBar({super.key, required this.onCategoryMatch});

  @override
  State<SmartSearchBar> createState() => _SmartSearchBarState();
}

class _SmartSearchBarState extends State<SmartSearchBar> {
  final _controller = TextEditingController();

  void _handleSearch(String value) {
    if (value.trim().isEmpty) return;

    final result = SmartSearchService.analyzeQuery(value);

    if (result != null) {
      if (result is ProcedureModel) {
        // Doğrudan detay ekranına git
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GenericDetailScreen(procedure: result)),
        );
      } else if (result is ProcedureCategory) {
        // İlgili sekmeye yönlendir
        widget.onCategoryMatch(result);
      }
      _controller.clear();
      FocusScope.of(context).unfocus();
    } else {
      // Eşleşme yoksa uyarı ver
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(SettingsController().translate('search_no_match'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = SettingsController();

    return AnimatedBuilder(
      animation: settings,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            onSubmitted: _handleSearch,
            style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
            decoration: InputDecoration(
              hintText: settings.translate('search_hint'),
              hintStyle: TextStyle(fontSize: 13, color: Theme.of(context).hintColor),
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.accent, size: 22),
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_forward_rounded, color: AppColors.accent),
                onPressed: () => _handleSearch(_controller.text),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            ),
          ),
        );
      },
    );
  }
}



