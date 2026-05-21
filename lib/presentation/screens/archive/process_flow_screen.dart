import 'package:flutter/material.dart';

class ProcessFlowScreen extends StatelessWidget {
  const ProcessFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      '1. Dilekçeni hazırla',
      '2. Gerekli delilleri ekle',
      '3. Harcı yatır',
      '4. Başvuruyu ilet',
      '5. Takip ve cevap bekle',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Başvuru Süreç Akışı'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Adım Adım Süreç',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            ...List.generate(steps.length, (i) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text('${i + 1}'),
                ),
                title: Text(steps[i]),
              );
            }),
          ],
        ),
      ),
    );
  }
}



