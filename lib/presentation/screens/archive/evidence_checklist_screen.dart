import 'package:flutter/material.dart';
import 'package:pusula/core/theme/app_colors.dart';

class EvidenceChecklistScreen extends StatefulWidget {
  const EvidenceChecklistScreen({super.key});

  @override
  State<EvidenceChecklistScreen> createState() => _EvidenceChecklistScreenState();
}

class _EvidenceChecklistScreenState extends State<EvidenceChecklistScreen> {
  final Map<String, bool> _items = {
    'Tanık': false,
    'Fatura': false,
    'Mesaj Kayıtları': false,
    'Fotoğraf / Video': false,
    'Banka Kayıtları': false,
  };

  final Map<String, String> _subtitles = {
    'Tanık': 'Olayı doğrudan görmüş kişilerin beyanı, mahkemenin kanaat oluşturmasında en güçlü araçtır. Hukuki süreçte iddiaların ispatını kolaylaştırır.',
    'Fatura': 'Maddi kayıpların ve yapılan harcamaların resmi kanıtıdır. Tazminat tutarının netleşmesi ve ekonomik zararın belgelenmesi için kritiktir.',
    'Mesaj Kayıtları': 'WhatsApp, SMS veya e-posta yazışmaları tarafların niyetini ve aralarındaki sözlü anlaşmaları kanıtlar. Karşı tarafın itiraflarını belgelemek için kullanılır.',
    'Fotoğraf / Video': "Olay yerinin veya durumun görsel kanıtıdır. 'Gözle görülür' zararların (hasar, kusurlu ürün vb.) inkar edilmesini imkansız hale getirir.",
    'Banka Kayıtları': 'Para transferleri ve ödeme dekontları, aradaki maddi ilişkinin en somut ve reddedilemez delilidir.',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delil Listesi'),
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: _items.keys.map((key) {
            return CheckboxListTile(
              title: Text(
                key,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                _subtitles[key] ?? '',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.text400,
                ),
              ),
              value: _items[key],
              onChanged: (val) => setState(() => _items[key] = val ?? false),
            );
          }).toList(),
        ),
      ),
    );
  }
}



