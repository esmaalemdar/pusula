// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Hukuki Tarihçem Ekranı (Tam Fonksiyonel)
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:pusula/core/theme/app_colors.dart';
import 'package:pusula/data/models/legal_document_model.dart';
import 'package:pusula/data/services/location_database_service.dart';
import 'package:pusula/data/services/settings_controller.dart';
import 'package:provider/provider.dart';
import '../petition/petition_preview_screen.dart';
import 'evidence_checklist_screen.dart';
import 'process_flow_screen.dart';

class GuideCard {
  final String titleTr;
  final String titleEn;
  final String descriptionTr;
  final String descriptionEn;
  final IconData icon;

  GuideCard({
    required this.titleTr,
    required this.titleEn,
    required this.descriptionTr,
    required this.descriptionEn,
    required this.icon,
  });
}

class ArchiveScreen extends StatefulWidget {
  final bool isActive;

  const ArchiveScreen({super.key, this.isActive = false});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final LocationDatabaseService _databaseService = LocationDatabaseService();
  bool _isLoading = true;
  List<LegalDocument> _allDocuments = [];
  List<LegalDocument> _filteredDocuments = [];

  // Dilekçe Rehberi Kartları
  final List<GuideCard> _guideCards = [
    GuideCard(
      titleTr: 'Adım Adım Dilekçe Şablonu',
      titleEn: 'Step-by-Step Petition Template',
      descriptionTr:
          'Dilekçe nasıl yazılır? Öncelikle dilekçenin başlığı, taraflar, olay özeti, hukuki gerekçe ve talep kısmı olmalıdır. Dikkat edilmesi gerekenler: Resmi dil kullanın, tarih ve imza zorunludur. Adım adım rehber: 1. Başlık (örneğin "İCRA DAİRESİ BAŞKANLIĞINA"), 2. Taraflar (davacı/davalı bilgileri), 3. Olayın özeti, 4. Hukuki dayanaklar, 5. Talep. Örnek şablonlar ve görseller: Dilekçe örneği görseli (üst kısım: mahkeme adı, alt kısım: imza alanı).',
      descriptionEn:
          'How to write a petition? First, a petition must have a header, parties, case summary, legal grounds, and request section. Things to consider: Use official language; date and signature are mandatory. Step-by-step guide: 1. Header (e.g. "TO THE CHIEF OF ENFORCEMENT OFFICE"), 2. Parties (plaintiff/defendant details), 3. Summary of events, 4. Legal basis, 5. Request. Sample templates and visuals: Petition template image (upper part: court name, lower part: signature area).',
      icon: Icons.description,
    ),
    GuideCard(
      titleTr: 'Delil Listesi Örneği',
      titleEn: 'Sample Evidence List',
      descriptionTr:
          'Delil listesi nasıl hazırlanır? Deliller, tanıklar, belgeler, raporlar şeklinde kategorize edilir. Örnekler: Kira sözleşmesi fotokopisi, faturalar, tanık ifadeleri. Doğru format: Numaralandırılmış liste, her delilin açıklaması. Hangi delillerin gerekli olduğu: Sözleşmeler, makbuzlar, fotoğraflar. Görseller: Delil listesi örneği (tablo formatında, sütunlar: No, Delil Türü, Açıklama).',
      descriptionEn:
          'How to prepare an evidence list? Evidence is categorized as witnesses, documents, and reports. Examples: Copy of the lease agreement, invoices, witness statements. Correct format: Numbered list, description of each evidence. Which evidence is required: Contracts, receipts, photos. Visuals: Sample evidence list (table format, columns: No, Evidence Type, Description).',
      icon: Icons.list,
    ),
    GuideCard(
      titleTr: 'Masraf Bildirim Örneği',
      titleEn: 'Sample Expense Statement',
      descriptionTr:
          'Masraf bildiriminin nasıl doldurulacağı: Harcanan tutarlar, tarihler ve açıklamalar detaylıca yazılır. Örnekler: Noter ücreti 500 TL, dava vekili 2000 TL. Dikkat edilmesi gereken hususlar: Faturalar eklenmeli, toplam tutar hesaplanmalı. Ne anlama gelir: Masraflar dava maliyetlerini karşılar. Görseller: Masraf bildirimi örneği (form formatında, toplam alanlı).',
      descriptionEn:
          'How to fill out the expense statement: Spent amounts, dates, and explanations are written in detail. Examples: Notary fee 500 TL, lawsuit proxy 2000 TL. Points to consider: Invoices must be attached, total amount must be calculated. What it means: Expenses cover lawsuit costs. Visuals: Sample expense statement (form format, with total fields).',
      icon: Icons.receipt,
    ),
    GuideCard(
      titleTr: 'Başvuru İpuçları',
      titleEn: 'Application Tips',
      descriptionTr:
          'Başvuru süreçlerinde nelere dikkat edilmeli? Süreleri kaçırmayın, belgeleri eksiksiz hazırlayın. İpuçları: Önce danışmanlık alın, dilekçeyi kontrol ettirin. Yaygın hatalar: Eksik imza, yanlış mahkeme. Ne yapılması gerektiği: Belgeleri taratın, online başvurun. Görseller: Başvuru süreci akış şeması (adımlar: Belge Hazırlama → Başvuru → Takip).',
      descriptionEn:
          'What should be considered in application processes? Do not miss deadlines, prepare documents completely. Tips: Get consulting first, have the petition checked. Common mistakes: Missing signature, wrong court. What needs to be done: Scan documents, apply online. Visuals: Application process flowchart (steps: Document Preparation → Application → Tracking).',
      icon: Icons.lightbulb,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadDocuments();
  }

  @override
  void didUpdateWidget(covariant ArchiveScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _loadDocuments();
    }
  }

  Future<void> _loadDocuments() async {
    try {
      await _databaseService.init();
      final documents = await _databaseService.fetchLegalDocuments();
      if (!mounted) return;
      setState(() {
        _allDocuments = documents;
        _applySearch(_searchController.text, shouldNotify: false);
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _allDocuments = [];
        _filteredDocuments = [];
        _isLoading = false;
      });
    }
  }

  DateTime _parseDate(String value) {
    return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  String _formatDate(String value) {
    final date = _parseDate(value);
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day.$month.${date.year}';
  }

  void _applySearch(String query, {bool shouldNotify = true}) {
    final normalizedQuery = query.trim().toLowerCase();
    final filtered = _allDocuments
        .where((doc) => doc.isTimelineOnly == 0)
        .where((doc) {
          if (normalizedQuery.isEmpty) return true;
          return doc.title.toLowerCase().contains(normalizedQuery) ||
              doc.category.toLowerCase().contains(normalizedQuery) ||
              doc.fileSizeOrSubtitle.toLowerCase().contains(normalizedQuery);
        })
        .toList()
      ..sort((a, b) => _parseDate(b.date).compareTo(_parseDate(a.date)));

    if (!shouldNotify) {
      _filteredDocuments = filtered;
      return;
    }

    setState(() {
      _filteredDocuments = filtered;
    });
  }

  Future<void> _deleteDocument(LegalDocument doc, SettingsController settings) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(settings.translate('delete_doc')),
        content: Text(settings.translate('delete_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(settings.translate('cancel')),
          ),
          TextButton(
            onPressed: () async {
              navigator.pop();
              if (doc.id != null) {
                await _databaseService.deleteLegalDocument(doc.id!);
              }
              if (!mounted) return;
              await _loadDocuments();
              if (!mounted) return;
              messenger.showSnackBar(
                SnackBar(content: Text(settings.translate('doc_deleted'))),
              );
            },
            child: Text(
              settings.translate('delete'),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsController>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(settings.translate('legal_history'), style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.accent,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.accent,
          tabs: [
            Tab(text: settings.translate('legal_chronology')),
            Tab(text: settings.translate('petition_guide')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChronologyTab(settings),
          _buildGuideTab(settings),
        ],
      ),
    );
  }

  Widget _buildChronologyTab(SettingsController settings) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: _applySearch,
                    decoration: InputDecoration(
                      hintText: settings.translate('search_file'),
                      prefixIcon: const Icon(Icons.search, color: AppColors.text400),
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : _filteredDocuments.isEmpty
                      ? _buildEmptyState(settings)
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _filteredDocuments.length,
                          itemBuilder: (context, index) {
                            final doc = _filteredDocuments[index];
                            return _ArchiveItem(
                              doc: doc,
                              onDelete: () => _deleteDocument(doc, settings),
                              onPreview: () => _showPreview(doc, settings),
                              onShare: () => _shareDoc(doc, settings),
                            );
                          },
                        ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(settings.translate('timeline'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),
                  _buildTimeline(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    final timelineItems = _allDocuments.toList()
      ..sort((a, b) => _parseDate(b.date).compareTo(_parseDate(a.date)));

    if (timelineItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: timelineItems.length,
      itemBuilder: (context, index) {
        final item = timelineItems[index];
        final title = item.title;
        final date = _formatDate(item.date);

        return Row(
          children: [
            Container(width: 2, height: 60, color: AppColors.accent),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(8)),
                child: Text('$date - $title', style: const TextStyle(fontSize: 11)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGuideTab(SettingsController settings) {
    final isTr = settings.language == AppLanguage.tr;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.2
        ),
        itemCount: _guideCards.length,
        itemBuilder: (context, index) {
          final card = _guideCards[index];
          final title = isTr ? card.titleTr : card.titleEn;
          final description = isTr ? card.descriptionTr : card.descriptionEn;
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              onTap: () => _handleGuideTap(index, settings),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(card.icon, color: AppColors.accent, size: 28),
                    const SizedBox(height: 8),
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 4),
                    Expanded(child: Text(description, style: const TextStyle(fontSize: 11), overflow: TextOverflow.ellipsis, maxLines: 2)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleGuideTap(int index, SettingsController settings) {
    if (index == 0) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const PetitionPreviewScreen()));
    } else if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const EvidenceChecklistScreen()));
    } else if (index == 2) {
      _showCostsModal(settings);
    } else if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ProcessFlowScreen()));
    }
  }

  void _showCostsModal(SettingsController settings) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(settings.translate('expense_report'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const Divider(),
            ListTile(title: Text(settings.translate('notary_fee')), trailing: const Text('500 TL')),
            ListTile(title: Text(settings.translate('court_fee')), trailing: const Text('150 TL')),
            ListTile(title: Text(settings.translate('total_cost')), trailing: const Text('650 TL', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(SettingsController settings) {
    return Center(child: Text(settings.translate('no_docs')));
  }

  void _showPreview(LegalDocument doc, SettingsController settings) {
    final previewPrefix = settings.language == AppLanguage.tr ? 'Önizleme' : 'Preview';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$previewPrefix: ${doc.title}')));
  }

  void _shareDoc(LegalDocument doc, SettingsController settings) {
    final sharePrefix = settings.language == AppLanguage.tr ? 'Paylaşılıyor' : 'Sharing';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$sharePrefix: ${doc.title}')));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}

class _ArchiveItem extends StatelessWidget {
  final LegalDocument doc;
  final VoidCallback onDelete;
  final VoidCallback onPreview;
  final VoidCallback onShare;

  const _ArchiveItem({required this.doc, required this.onDelete, required this.onPreview, required this.onShare});

  String _formatDate(String value) {
    final date = DateTime.tryParse(value);
    if (date == null) return value;
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day.$month.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const Icon(Icons.description, color: AppColors.accent),
        title: Text(doc.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text('${Provider.of<SettingsController>(context).translate(doc.category)} • ${_formatDate(doc.date)}'),
        trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: onDelete),
      ),
    );
  }
}
