// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Dilekçe Önizleme Ekranı (Adım Adım Şablonu & Yerelleştirilmiş)
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:pusula/core/theme/app_colors.dart';
import 'package:pusula/data/services/settings_controller.dart';

class PetitionPreviewScreen extends StatefulWidget {
  const PetitionPreviewScreen({super.key});

  @override
  State<PetitionPreviewScreen> createState() => _PetitionPreviewScreenState();
}

class _PetitionPreviewScreenState extends State<PetitionPreviewScreen> {
  // Hangi bölümün genişletildiğini takip et
  String? _expandedSection;
  bool _initialized = false;

  // Dinamik içerik için kontrolcüler
  final _headerController = TextEditingController();
  final _plaintiffController = TextEditingController();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _requestController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final settings = Provider.of<SettingsController>(context, listen: false);
      _headerController.text = settings.translate('petprev_header_default');
      _plaintiffController.text = settings.translate('petprev_plaintiff_default');
      _subjectController.text = settings.translate('petprev_subject_default');
      _descriptionController.text = settings.translate('petprev_description_default');
      _requestController.text = settings.translate('petprev_request_default');
      _initialized = true;
    }
  }

  // Bölüm açıklamaları
  Map<String, String> _getSectionHints(SettingsController settings) {
    return {
      'BAŞLIK': settings.translate('petprev_hint_header'),
      'DAVACI': settings.translate('petprev_hint_plaintiff'),
      'KONU': settings.translate('petprev_hint_subject'),
      'AÇIKLAMALAR': settings.translate('petprev_hint_description'),
      'NETİCE-İ TALEP': settings.translate('petprev_hint_request'),
    };
  }

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

  Future<void> _generatePdf(SettingsController settings) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
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
                  turkishToEnglish('${settings.translate('petprev_sec_title_plaintiff')}:'),
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
                  turkishToEnglish('${settings.translate('petprev_sec_title_subject')}:'),
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
                  turkishToEnglish('${settings.translate('petprev_sec_title_description')}:'),
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
                  turkishToEnglish('${settings.translate('petprev_sec_title_request')}:'),
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
                        turkishToEnglish(settings.translate('petprev_date')),
                        style: pw.TextStyle(
                          font: pw.Font.helvetica(),
                          fontSize: 10,
                        ),
                      ),
                      pw.SizedBox(height: 30),
                      pw.Text(
                        turkishToEnglish(settings.translate('petprev_signature')),
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${settings.translate('petprev_pdf_error')} $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsController>(context);
    final hints = _getSectionHints(settings);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          settings.translate('petprev_title'),
          style: const TextStyle(fontWeight: FontWeight.bold),
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
              onPressed: () => _generatePdf(settings),
              icon: const Icon(Icons.picture_as_pdf, size: 20),
              label: Text(settings.translate('petprev_pdf')),
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
                      title: settings.translate('petprev_sec_title_header'),
                      controller: _headerController,
                      section: 'BAŞLIK',
                      settings: settings,
                    ),

                    Divider(height: 1, color: Colors.grey[300]),

                    // DAVACI Bölümü
                    _buildPetitionSection(
                      title: settings.translate('petprev_sec_title_plaintiff'),
                      controller: _plaintiffController,
                      section: 'DAVACI',
                      settings: settings,
                    ),

                    Divider(height: 1, color: Colors.grey[300]),

                    // KONU Bölümü
                    _buildPetitionSection(
                      title: settings.translate('petprev_sec_title_subject'),
                      controller: _subjectController,
                      section: 'KONU',
                      settings: settings,
                    ),

                    Divider(height: 1, color: Colors.grey[300]),

                    // AÇIKLAMALAR Bölümü
                    _buildPetitionSection(
                      title: settings.translate('petprev_sec_title_description'),
                      controller: _descriptionController,
                      section: 'AÇIKLAMALAR',
                      isLarge: true,
                      settings: settings,
                    ),

                    Divider(height: 1, color: Colors.grey[300]),

                    // NETİCE-İ TALEP Bölümü
                    _buildPetitionSection(
                      title: settings.translate('petprev_sec_title_request'),
                      controller: _requestController,
                      section: 'NETİCE-İ TALEP',
                      settings: settings,
                    ),

                    // İmza Alanı
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            settings.translate('petprev_date'),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.text600,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            settings.translate('petprev_signature'),
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
                        Expanded(
                          child: Text(
                            settings.translate('petprev_attention'),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTip(settings.translate('petprev_tip_1')),
                    _buildTip(settings.translate('petprev_tip_2')),
                    _buildTip(settings.translate('petprev_tip_3')),
                    _buildTip(settings.translate('petprev_tip_4')),
                    _buildTip(settings.translate('petprev_tip_5')),
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
                              _getGuideTitle(settings),
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
                        hints[_expandedSection] ?? '',
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

  String _getGuideTitle(SettingsController settings) {
    final sectionTitles = {
      'BAŞLIK': settings.translate('petprev_sec_title_header'),
      'DAVACI': settings.translate('petprev_sec_title_plaintiff'),
      'KONU': settings.translate('petprev_sec_title_subject'),
      'AÇIKLAMALAR': settings.translate('petprev_sec_title_description'),
      'NETİCE-İ TALEP': settings.translate('petprev_sec_title_request'),
    };
    final currentSectionTitle = sectionTitles[_expandedSection] ?? '';
    return '"$currentSectionTitle" ${settings.translate('petprev_guide_title')}';
  }

  Widget _buildPetitionSection({
    required String title,
    required TextEditingController controller,
    required String section,
    required SettingsController settings,
    bool isLarge = false,
  }) {
    final isExpanded = _expandedSection == section;
    final hints = _getSectionHints(settings);

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
                    hints[section] ?? '',
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
