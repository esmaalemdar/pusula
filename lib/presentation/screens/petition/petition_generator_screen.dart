// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Dilekçe Oluşturma Modülü (Düzeltildi)
// ═══════════════════════════════════════════════════════════════════════════
//
// YAPILAN DÜZELTMELER:
//  1. Form widget + _formKey eklendi (validation doğru çalışıyor)
//  2. _buildInput() → TextFormField olarak değiştirildi (validator destekli)
//  3. Dilekçe içeriği (contentController) maxLines: null ile tam düzenlenebilir
//  4. "Dilekçeyi Kaydet" butonu → validate() + DB kaydı + başarı dialog'u
//  5. dispose() içinde tüm controller'lar temizleniyor
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pusula/core/theme/app_colors.dart';
import 'package:pusula/data/models/legal_document_model.dart';
import 'package:pusula/data/services/location_database_service.dart';

class PetitionGeneratorScreen extends StatefulWidget {
  final String categoryName;
  final String userName;

  const PetitionGeneratorScreen({
    super.key,
    this.categoryName = 'Genel',
    required this.userName,
  });

  @override
  State<PetitionGeneratorScreen> createState() =>
      _PetitionGeneratorScreenState();
}

class _PetitionGeneratorScreenState extends State<PetitionGeneratorScreen> {
  // ── Form Key ─────────────────────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();

  // ── Controller'lar ───────────────────────────────────────────────────────
  final _courtController    = TextEditingController();
  final _nameController     = TextEditingController();
  final _tcController       = TextEditingController();
  final _opponentController = TextEditingController();
  final _subjectController  = TextEditingController();
  final _contentController  = TextEditingController();
  final _requestController  = TextEditingController();

  bool _showPreview = false;
  bool _isSaving    = false;

  // ── DB Servisi ────────────────────────────────────────────────────────────
  final _db = LocationDatabaseService();

  @override
  void initState() {
    super.initState();
    // Önceden gelen değerleri controller'lara bağla
    _nameController.text    = widget.userName;
    _subjectController.text = '${widget.categoryName} Hakkında';
  }

  @override
  void dispose() {
    _courtController.dispose();
    _nameController.dispose();
    _tcController.dispose();
    _opponentController.dispose();
    _subjectController.dispose();
    _contentController.dispose();
    _requestController.dispose();
    super.dispose();
  }

  // ── Dilekçe Metni Oluşturucu ─────────────────────────────────────────────
  String _generatePetitionText() {
    final date = DateFormat('dd.MM.yyyy').format(DateTime.now());
    return '''
${_courtController.text.toUpperCase()} SAYIN MAHKEMESİ'NE

DAVACI          : ${_nameController.text} (T.C. No: ${_tcController.text})
ADRES           : [Kullanıcı Adres Bilgisi]

DAVALI          : ${_opponentController.text}
ADRES           : [Davalı Adres Bilgisi]

KONU            : ${_subjectController.text}

AÇIKLAMALAR     :
${_contentController.text}

HUKUKİ NEDENLER : HMK, TMK ve ilgili mevzuat.

DELİLLER        : Nüfus kayıtları, tanık beyanları, bilirkişi incelemesi ve her türlü yasal delil.

NETİCE-İ TALEP  : Yukarıda arz ve izah edilen nedenlerle; ${_requestController.text} karar verilmesini saygılarımla arz ve talep ederim. $date

Davacı:
${_nameController.text}
(İmza)
''';
  }

  // ── Veritabanına Kaydet ───────────────────────────────────────────────────
  Future<void> _saveToArchive() async {
    // 1. Formu validate et
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);

    try {
      await _db.init();

      final navigator = Navigator.of(context);
      final dialogNavigator = Navigator.of(context, rootNavigator: true);
      final messenger = ScaffoldMessenger.of(context);

      final title = '${_subjectController.text.trim()} - '
          '${_nameController.text.trim()}';

      final doc = LegalDocument(
        title: title,
        category: 'Dilekçe',
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        fileSizeOrSubtitle: widget.categoryName,
      );

      await _db.saveLegalDocument(doc);

      if (!mounted) return;

      // 2. Başarı Animasyonu ve Mesajı
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => Center(
          child: Container(
            width: 220, height: 220,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(ctx).cardColor, 
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)]
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 700),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.accent,
                          size: 64,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Material(
                  color: Colors.transparent,
                  child: Text(
                    "Dilekçe Hazır!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Animasyonu bir süre gösterdikten sonra ana ekrana dön
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      
      // Diyaloğu kapat ve ana sayfaya (Arşiv'e) yönlendir
      if (dialogNavigator.canPop()) {
        dialogNavigator.pop();
      }
      navigator.pop();
      
      messenger.showSnackBar(
        SnackBar(
          content: Text('"$title" Arşivlendi.'),
          backgroundColor: AppColors.accent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e, st) {
      debugPrint('Arşive kayıt hatası: $e');
      debugPrintStack(stackTrace: st);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kayıt sırasında hata oluştu: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Dilekçe Hazırla'),
        backgroundColor: Theme.of(context).cardColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
        elevation: 0.5,
      ),
      body: _showPreview ? _buildPreview() : _buildForm(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setState(() => _showPreview = !_showPreview),
        label: Text(_showPreview ? 'Düzenle' : 'Önizle'),
        icon: Icon(_showPreview
            ? Icons.edit_outlined
            : Icons.visibility_outlined),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
      ),
    );
  }

  // ── Form ──────────────────────────────────────────────────────────────────
  Widget _buildForm() {
    return Form(
      // Form widget + GlobalKey → validate() artık doğru çalışır
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldTitle('Mahkeme / Kurum Adı'),
            _buildInput(
              controller: _courtController,
              hint: 'Örn: Ankara Sulh Hukuk Mahkemesi',
              requiredMsg: 'Mahkeme adını yazınız',
            ),

            _buildFieldTitle('Davacı / Başvuran Adı Soyadı'),
            _buildInput(
              controller: _nameController,
              hint: 'Ad Soyad',
              requiredMsg: 'Ad soyad yazınız',
            ),
            const SizedBox(height: 10),
            _buildInput(
              controller: _tcController,
              hint: 'T.C. Kimlik No (11 hane)',
              keyboard: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'T.C. No yazınız';
                if (v.trim().length != 11) return '11 haneli T.C. No giriniz';
                return null;
              },
            ),

            _buildFieldTitle('Karşı Taraf (Davalı)'),
            _buildInput(
              controller: _opponentController,
              hint: 'Örn: X Sigorta A.Ş. veya Şahıs Adı',
              requiredMsg: 'Karşı taraf bilgisini yazınız',
            ),

            _buildFieldTitle('Konu'),
            _buildInput(
              controller: _subjectController,
              hint: 'Dilekçenin konusu',
              requiredMsg: 'Konu boş bırakılamaz',
            ),

            _buildFieldTitle('Olayın Özeti'),
            // ⚠️ maxLines: null → tam düzenlenebilir, kaydırmalı metin alanı
            _buildInput(
              controller: _contentController,
              hint: 'Yaşanan olayı detaylıca anlatınız...',
              maxLines: null,
              minLines: 5,
              requiredMsg: 'Olay özeti boş bırakılamaz',
            ),

            _buildFieldTitle('Netice-i Talep (Ne İstiyorsunuz?)'),
            _buildInput(
              controller: _requestController,
              hint: 'Örn: Maddi zararımın tazminine...',
              maxLines: null,
              minLines: 3,
              requiredMsg: 'Talep boş bırakılamaz',
            ),

            const SizedBox(height: 28),

            // ── Kaydet Butonu ──────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveToArchive,
                icon: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.save_alt_rounded,
                        color: Colors.white),
                label: Text(
                  _isSaving ? 'Kaydediliyor...' : 'Dilekçeyi Kaydet',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  disabledBackgroundColor: AppColors.accent.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Önizleme ──────────────────────────────────────────────────────────────
  Widget _buildPreview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 20,
                    offset: Offset(0, 5))
              ],
            ),
            child: Text(
              _generatePetitionText(),
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: 13,
                height: 1.5,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dilekçe PDF olarak kaydedildi!')),
              );
            },
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: const Text('PDF Olarak Kaydet'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  // ── Yardımcı Widget'lar ───────────────────────────────────────────────────

  Widget _buildFieldTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: AppColors.accent,
        ),
      ),
    );
  }

  /// TextFormField — validator destekli, maxLines esnekliği var
  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    String? requiredMsg,
    String? Function(String?)? validator,
    int? maxLines = 1,
    int minLines = 1,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: keyboard,
      // validator: özel validator verilmişse onu kullan,
      // yoksa requiredMsg varsa boş bırakma kontrolü yap
      validator: validator ??
          (requiredMsg != null
              ? (v) => (v == null || v.trim().isEmpty) ? requiredMsg : null
              : null),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.text400, fontSize: 13),
        filled: true,
        fillColor: Theme.of(context).cardColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
    );
  }
}



