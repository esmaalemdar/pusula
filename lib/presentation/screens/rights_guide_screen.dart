import 'package:flutter/material.dart';
import 'package:pusula/core/theme/app_colors.dart';

class RightsGuideScreen extends StatelessWidget {
  const RightsGuideScreen({super.key});

  static const _scenarios = [
    _RightsScenario(
      title: 'Ev sahibim beni evden çıkarmak istiyor, ne yapmalıyım?',
      icon: Icons.home_outlined,
      highlights: [
        'Tahliye taleplerini yazılı olarak alın ve sözleşmenizi kontrol edin.',
        'İhtar çekmek, kira sözleşmesindeki maddeleri incelemek en ilk adımdır.',
        'Mahkeme öncesi uzlaşma veya arabuluculuk seçeneklerini değerlendirin.',
        'Gerekirse sulh hukuk mahkemesine başvurup durumu resmi hale getirin.',
      ],
    ),
    _RightsScenario(
      title: 'İnternetten aldığım ürün bozuk çıktı, iade edebilir miyim?',
      icon: Icons.shopping_bag_outlined,
      highlights: [
        'Satıcıya bozuk ürünü yazılı olarak bildirin ve iade talep edin.',
        'Fatura, kargo bilgileri ve fotoğrafları saklayın.',
        'Tüketici hakları kapsamında cayma veya ayıp bildiriminde bulunun.',
        'Satıcı kabul etmezse Hakem Heyeti’ne başvurun.',
      ],
    ),
    _RightsScenario(
      title: 'İşten sebepsiz yere çıkarıldım, haklarım neler?',
      icon: Icons.work_outline,
      highlights: [
        'Fesih bildirimini ve ihbar sürenizi kontrol edin.',
        'Kıdem, ihbar ve ücret alacaklarını hesaplayın.',
        'Sendika veya işçi temsilcisinden destek alın.',
        'Gerekirse işe iade veya tazminat davası açın.',
      ],
    ),
    _RightsScenario(
      title: 'Kişisel verilerimin izinsiz kullanıldığını düşünüyorum.',
      icon: Icons.privacy_tip_outlined,
      highlights: [
        'Verilerinizi hangi amaçla kullandıklarını kurumdan sorun.',
        'Aydınlatma metni ve onay sürecini inceleyin.',
        'KVKK’ya şikayet başvurusu yapın.',
        'Gerekirse hukuki destek alın.',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Haklarım Neler?'),
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
                  scenario.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    height: 1.3,
                  ),
                ),
                children: scenario.highlights.map((item) {
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
                            item,
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
  final String title;
  final IconData icon;
  final List<String> highlights;

  const _RightsScenario({
    required this.title,
    required this.icon,
    required this.highlights,
  });
}



