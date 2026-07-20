import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pusula/data/services/settings_controller.dart';

class ProcessFlowScreen extends StatelessWidget {
  const ProcessFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsController>(context);
    final isTr = settings.language == AppLanguage.tr;

    final steps = isTr
        ? [
            'Dilekçeni hazırla',
            'Gerekli delilleri ekle',
            'Harcı yatır',
            'Başvuruyu ilet',
            'Takip ve cevap bekle',
          ]
        : [
            'Prepare your petition',
            'Attach required evidence',
            'Pay the fee',
            'Submit the application',
            'Track and wait for response',
          ];

    return Scaffold(
      appBar: AppBar(
        title: Text(isTr ? 'Başvuru Süreç Akışı' : 'Application Process Flow'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isTr ? 'Adım Adım Süreç' : 'Step-by-Step Process',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            ...List.generate(steps.length, (i) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text('${i + 1}'),
                ),
                title: Text('${i + 1}. ${steps[i]}'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
