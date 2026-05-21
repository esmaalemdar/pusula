// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Dilekçe Önizleme Ekranı (Adım Adım Şablonu)
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pusula/core/theme/app_colors.dart';

class PetitionPreviewScreen extends StatefulWidget {
  const PetitionPreviewScreen({super.key});

  @override
  State<PetitionPreviewScreen> createState() => _PetitionPreviewScreenState();
}

class _PetitionPreviewScreenState extends State<PetitionPreviewScreen> {
  // Hangi bölümün genişletildiğini takip et
  String? _expandedSection;

  // Dinamik içerik için kontrolcüler
  final _headerController = TextEditingController(text: 'KARŞIYAKA MAHKEMESİ BAŞKANLIĞINA');
  final _plaintiffController = TextEditingController(text: 'Adı Soyadı\nT.C. No: 12345678901\nAdres: İzmir, Karşıyaka');
  final _subjectController = TextEditingController(text: 'Kira Sözleşmesinde Uyuşmazlık Nedeniyle Dava Açılması');
  final _descriptionController = TextEditingController(text: '1. ... tarihinde kira sözleşmesi yapılmıştır.\n2. ...\n3. ...');
  final _requestController = TextEditingController(text: 'Davacının kira borcu ödeme davası karşı kira iadesi davası açılması talep edilir.');

  // Bölüm açıklamaları
  final Map<String, String> _sectionHints = {
    'BAŞLIK':
        'Dilekçenin başında İlgili makamın adı yazılır.\nÖrnek: "KARŞIYAKA MAHKEMESİ BAŞKANLIĞINA"\n\nDikkat: Resmi makam adı tam ve doğru yazılmalıdır.',
    'DAVACI':
        'Dilekçeyi yazanın (davacının) tam adı, Türkiye Cumhuriyet Kimlik Numarası ve adresi yazılır.\nÖrnek: "Adı Soyadı\nT.C. No: 12345678901\nAdres: İzmir, Karşıyaka"',
    'KONU':
        'Dilekçenin konusu kısaca 1-2 cümle olarak yazılır.\nÖrnek: "Kira Sözleşmesinde Uyuşmazlık Nedeniyle Dava Açılması"\n\nDikkat: Çok uzun yazmayın, özet niteliğinde olmalı.',
    'AÇIKLAMALAR':
        'Olayın detaylı anlatımı yazılır.\n- Olaylar kronolojik sırada açıklanır\n- Hangi tarihte ne olduğu net belirtilir\n- Tanıklar varsa isim belirtilir\n\nDikkat: Duygusal ifadelerden kaçının, resmî dil kullanın.',
    'NETİCE-İ TALEP':
        'Mahkemeden istenen karar açıkça yazılır.\nÖrnek: "Davacının kira borcu ödeme davası karşı kira iadesi davası açılması talep edilir."\n\nDikkat: Açık ve kesin talepler yazılmalıdır.',
  };

  void _toggleSection(String section) {
    setState(() {
      if (_expandedSection == section) {
        _expandedSection = null;
      } else {
        _expandedSection = section;
      }
    });
  }

  /// Türkçe karakterleri İngilizce karşılıklarıyla değiştirir
  /// Örnek: 'İlgili Makam' -> 'Ilgili Makam'
  String turkishToEnglish(String text) {
    final turkishToEnglishMap = {
      'ğ': 'g',
      'ü': 'u',
      'ş': 's',
      'ı': 'i',
      'ö': 'o',
      'ç': 'c',
      'Ğ': 'G',
      'Ü': 'U',
      'Ş': 'S',
      'İ': 'I',
      'Ö': 'O',
      'Ç': 'C',
    };

    String result = text;
    turkishToEnglishMap.forEach((turkish, english) {
      result = result.replaceAll(turkish, english);
    });
    return result;
  }

  Future<void> _generatePdf() async {
    try {
      // PDF paketinin içinde gömülü olan fontları kullan
      // Helvetica font Türkçe karakterleri standart olarak desteklemediği için
      // karakterleri İngilizce karşılıklarıyla değiştiriyoruz
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // BAŞLIK - Orta hizalı
                pw.Center(
                  child: pw.Text(
                    turkishToEnglish(_headerController.text),
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      font: pw.Font.helvetica(),
                      fontSize: 13,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 25),

                // DAVACI - Sol üstte
                pw.Text(
                  turkishToEnglish('DAVACI:'),
                  style: pw.TextStyle(
                    font: pw.Font.helvetica(),
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  turkishToEnglish(_plaintiffController.text),
                  style: pw.TextStyle(
                    font: pw.Font.helvetica(),
                    fontSize: 10,
                  ),
                ),
                pw.SizedBox(height: 15),

                // KONU - Sol üstte
                pw.Text(
                  turkishToEnglish('KONU:'),
                  style: pw.TextStyle(
                    font: pw.Font.helvetica(),
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  turkishToEnglish(_subjectController.text),
                  style: pw.TextStyle(
                    font: pw.Font.helvetica(),
                    fontSize: 10,
                  ),
                ),
                pw.SizedBox(height: 20),

                // AÇIKLAMALAR - Ana gövde
                pw.Text(
                  turkishToEnglish('AÇIKLAMALAR:'),
                  style: pw.TextStyle(
                    font: pw.Font.helvetica(),
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  turkishToEnglish(_descriptionController.text),
                  style: pw.TextStyle(
                    font: pw.Font.helvetica(),
                    fontSize: 10,
                    height: 1.5,
                  ),
                ),
                pw.SizedBox(height: 25),

                // NETİCE-İ TALEP
                pw.Text(
                  turkishToEnglish('NETİCE-İ TALEP:'),
                  style: pw.TextStyle(
                    font: pw.Font.helvetica(),
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  turkishToEnglish(_requestController.text),
                  style: pw.TextStyle(
                    font: pw.Font.helvetica(),
                    fontSize: 10,
                  ),
                ),
                pw.SizedBox(height: 50),

                // Tarih ve İmza - Sağ tarafta
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        turkishToEnglish('Tarih: ___/___/______'),
                        style: pw.TextStyle(
                          font: pw.Font.helvetica(),
                          fontSize: 10,
                        ),
                      ),
                      pw.SizedBox(height: 30),
                      pw.Text(
                        turkishToEnglish('İmza: _________________'),
                        style: pw.TextStyle(
                          font: pw.Font.helvetica(),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      // Hata durumunda kullanıcıya bildirim göster
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF oluşturulurken hata oluştu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Dilekçe Şablonu Rehberi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ??
            Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton.icon(
              onPressed: _generatePdf,
              icon: const Icon(Icons.picture_as_pdf, size: 20),
              label: const Text('PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // A4 Kağıdı Simülasyonu
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // BAŞLIK Bölümü
                    _buildPetitionSection(
                      title: 'BAŞLIK',
                      controller: _headerController,
                      section: 'BAŞLIK',
                    ),

                    Divider(height: 1, color: Colors.grey[300]),

                    // DAVACI Bölümü
                    _buildPetitionSection(
                      title: 'DAVACI',
                      controller: _plaintiffController,
                      section: 'DAVACI',
                    ),

                    Divider(height: 1, color: Colors.grey[300]),

                    // KONU Bölümü
                    _buildPetitionSection(
                      title: 'KONU',
                      controller: _subjectController,
                      section: 'KONU',
                    ),

                    Divider(height: 1, color: Colors.grey[300]),

                    // AÇIKLAMALAR Bölümü
                    _buildPetitionSection(
                      title: 'AÇIKLAMALAR',
                      controller: _descriptionController,
                      section: 'AÇIKLAMALAR',
                      isLarge: true,
                    ),

                    Divider(height: 1, color: Colors.grey[300]),

                    // NETİCE-İ TALEP Bölümü
                    _buildPetitionSection(
                      title: 'NETİCE-İ TALEP',
                      controller: _requestController,
                      section: 'NETİCE-İ TALEP',
                    ),

                    // İmza Alanı
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            'Tarih: ___/___/______',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.text600,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'İmza: _________________',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.text600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Bilgilendirme Paneli
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Dikkat Edilmesi Gerekenler',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTip('Resmi dil ve ton kullanın'),
                    _buildTip('Kronolojik sıra takip edin'),
                    _buildTip('Tarih ve imza zorunludur'),
                    _buildTip('Belgeleri eksiksiz hazırlayın'),
                    _buildTip('Anlaşılmaz yazı kullanmayın'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Hint Paneli
              if (_expandedSection != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.amber[300]!,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Colors.amber[800],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '"$_expandedSection" Bölümü Rehberi',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.amber[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _sectionHints[_expandedSection]!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetitionSection({
    required String title,
    required TextEditingController controller,
    required String section,
    bool isLarge = false,
  }) {
    final isExpanded = _expandedSection == section;

    return GestureDetector(
      onTap: () => _toggleSection(section),
      child: Container(
        color: isExpanded ? AppColors.primaryLight.withOpacity(0.3) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: AppColors.secondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                    color: AppColors.accent,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                maxLines: isLarge ? 8 : null,
                style: TextStyle(
                  fontSize: isLarge ? 14 : 13,
                  color: AppColors.text800,
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              if (isExpanded) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    _sectionHints[section]!,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.text800,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.text800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



