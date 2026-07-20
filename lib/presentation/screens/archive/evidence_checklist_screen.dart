import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pusula/core/theme/app_colors.dart';
import 'package:pusula/data/services/settings_controller.dart';

class EvidenceChecklistScreen extends StatefulWidget {
  const EvidenceChecklistScreen({super.key});

  @override
  State<EvidenceChecklistScreen> createState() => _EvidenceChecklistScreenState();
}

class _EvidenceChecklistScreenState extends State<EvidenceChecklistScreen> {
  late final List<ChecklistItem> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      ChecklistItem(
        titleTr: 'Tanık',
        titleEn: 'Witness',
        subtitleTr: 'Olayı doğrudan görmüş kişilerin beyanı, mahkemenin kanaat oluşturmasında en güçlü araçtır. Hukuki süreçte iddiaların ispatını kolaylaştırır.',
        subtitleEn: 'The statement of people who directly witnessed the event is the strongest tool for the court to form an opinion. It facilitates proof of allegations in legal processes.',
      ),
      ChecklistItem(
        titleTr: 'Fatura',
        titleEn: 'Invoice',
        subtitleTr: 'Maddi kayıpların ve yapılan harcamaların resmi kanıtıdır. Tazminat tutarının netleşmesi ve ekonomik zararın belgelenmesi için kritiktir.',
        subtitleEn: 'Official proof of material losses and expenses. Critical for clarifying compensation amounts and documenting economic damage.',
      ),
      ChecklistItem(
        titleTr: 'Mesaj Kayıtları',
        titleEn: 'Message Records',
        subtitleTr: 'WhatsApp, SMS veya e-posta yazışmaları tarafların niyetini ve aralarındaki sözlü anlaşmaları kanıtlar. Karşı tarafın itiraflarını belgelemek için kullanılır.',
        subtitleEn: 'WhatsApp, SMS, or email correspondence proves the intent of the parties and oral agreements between them. Used to document admissions of the opposing party.',
      ),
      ChecklistItem(
        titleTr: 'Fotoğraf / Video',
        titleEn: 'Photo / Video',
        subtitleTr: "Olay yerinin veya durumun görsel kanıtıdır. 'Gözle görülür' zararların (hasar, kusurlu ürün vb.) inkar edilmesini imkansız hale getirir.",
        subtitleEn: 'Visual evidence of the scene or situation. Makes it impossible to deny "visible" damages (damage, defective products, etc.).',
      ),
      ChecklistItem(
        titleTr: 'Banka Kayıtları',
        titleEn: 'Bank Records',
        subtitleTr: 'Para transferleri ve ödeme dekontları, aradaki maddi ilişkinin en somut ve reddedilemez delilidir.',
        subtitleEn: 'Money transfers and payment receipts are the most concrete and undeniable proof of the financial relationship between the parties.',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsController>(context);
    final isTr = settings.language == AppLanguage.tr;

    return Scaffold(
      appBar: AppBar(
        title: Text(settings.translate('evidence_checklist')),
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            final item = _items[index];
            return CheckboxListTile(
              title: Text(
                isTr ? item.titleTr : item.titleEn,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                isTr ? item.subtitleTr : item.subtitleEn,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.text400,
                ),
              ),
              value: item.isChecked,
              onChanged: (val) => setState(() => item.isChecked = val ?? false),
            );
          },
        ),
      ),
    );
  }
}

class ChecklistItem {
  final String titleTr;
  final String titleEn;
  final String subtitleTr;
  final String subtitleEn;
  bool isChecked;

  ChecklistItem({
    required this.titleTr,
    required this.titleEn,
    required this.subtitleTr,
    required this.subtitleEn,
    this.isChecked = false,
  });
}
