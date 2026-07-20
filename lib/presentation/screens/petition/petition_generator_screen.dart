// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Dilekçe Oluşturma Modülü (Düzeltildi & Yerelleştirildi)
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pusula/core/theme/app_colors.dart';
import 'package:pusula/data/models/legal_document_model.dart';
import 'package:pusula/data/services/location_database_service.dart';
import 'package:pusula/data/services/settings_controller.dart';

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
  bool _initialized = false;

  // ── DB Servisi ────────────────────────────────────────────────────────────
  final _db = LocationDatabaseService();

  @override
  void initState() {
    super.initState();
    // Önceden gelen değerleri controller'lara bağla
    _nameController.text    = widget.userName;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final settings = Provider.of<SettingsController>(context, listen: false);
      _subjectController.text = '${settings.translate(widget.categoryName)} ${settings.translate('petgen_about_suffix')}';
      _initialized = true;
    }
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
  String _generatePetitionText(SettingsController settings) {
    final date = DateFormat('dd.MM.yyyy').format(DateTime.now());
    final courtTo = settings.translate('petgen_court_to');
    final plaintiff = settings.translate('petgen_plaintiff');
    final address = settings.translate('petgen_address');
    final defendant = settings.translate('petgen_defendant');
    final subject = settings.translate('petgen_subject');
    final descriptions = settings.translate('petgen_descriptions');
    final legalGrounds = settings.translate('petgen_legal_grounds');
    final legalGroundsText = settings.translate('petgen_legal_grounds_text');
    final evidences = settings.translate('petgen_evidences');
    final evidencesText = settings.translate('petgen_evidences_text');
    final conclusion = settings.translate('petgen_conclusion');
    final signature = settings.translate('petgen_signature');

    final reqPrefix = settings.language == AppLanguage.tr 
        ? "Yukarıda arz ve izah edilen nedenlerle;" 
        : "For the reasons submitted and explained above;";
    final reqSuffix = settings.language == AppLanguage.tr
        ? "karar verilmesini saygılarımla arz ve talep ederim."
        : "I respectfully submit and request that a decision be rendered.";

    return '''
${_courtController.text.toUpperCase()} $courtTo

$plaintiff          : ${_nameController.text} (T.C. No: ${_tcController.text})
$address           : ${settings.translate('petgen_user_address_placeholder')}

$defendant          : ${_opponentController.text}
$address           : ${settings.translate('petgen_opponent_address_placeholder')}

$subject            : ${_subjectController.text}

$descriptions     :
${_contentController.text}

$legalGrounds : $legalGroundsText

$evidences        : $evidencesText

$conclusion  : $reqPrefix ${_requestController.text} $reqSuffix $date

$plaintiff:
${_nameController.text}
$signature
''';
  }

  // ── Veritabanına Kaydet ───────────────────────────────────────────────────
  Future<void> _saveToArchive(SettingsController settings) async {
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
        fileSizeOrSubtitle: settings.translate(widget.categoryName),
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
                Material(
                  color: Colors.transparent,
                  child: Text(
                    settings.translate("petgen_success"),
                    style: const TextStyle(
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
          content: Text('"$title" ${settings.translate("petgen_saved_to_archive")}'),
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
          content: Text('${settings.translate("petgen_error_occurred")} $e'),
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
    final settings = Provider.of<SettingsController>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(settings.translate('petgen_title')),
        backgroundColor: Theme.of(context).cardColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
        elevation: 0.5,
      ),
      body: _showPreview ? _buildPreview(settings) : _buildForm(settings),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setState(() => _showPreview = !_showPreview),
        label: Text(_showPreview ? settings.translate('petgen_edit') : settings.translate('petgen_preview')),
        icon: Icon(_showPreview
            ? Icons.edit_outlined
            : Icons.visibility_outlined),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
      ),
    );
  }

  // ── Form ──────────────────────────────────────────────────────────────────
  Widget _buildForm(SettingsController settings) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldTitle(settings.translate('petgen_court_label')),
            _buildInput(
              controller: _courtController,
              hint: settings.translate('petgen_court_hint'),
              requiredMsg: settings.translate('petgen_court_req'),
            ),

            _buildFieldTitle(settings.translate('petgen_plaintiff_label')),
            _buildInput(
              controller: _nameController,
              hint: settings.translate('full_name'),
              requiredMsg: settings.translate('petgen_plaintiff_req'),
            ),
            const SizedBox(height: 10),
            _buildInput(
              controller: _tcController,
              hint: settings.translate('petgen_tc_hint'),
              keyboard: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return settings.translate('petgen_tc_req');
                if (v.trim().length != 11) return settings.translate('petgen_tc_invalid');
                return null;
              },
            ),

            _buildFieldTitle(settings.translate('petgen_defendant_label')),
            _buildInput(
              controller: _opponentController,
              hint: settings.translate('petgen_defendant_hint'),
              requiredMsg: settings.translate('petgen_defendant_req'),
            ),

            _buildFieldTitle(settings.translate('petgen_subject_label')),
            _buildInput(
              controller: _subjectController,
              hint: settings.translate('petgen_subject_hint'),
              requiredMsg: settings.translate('petgen_subject_req'),
            ),

            _buildFieldTitle(settings.translate('petgen_event_label')),
            _buildInput(
              controller: _contentController,
              hint: settings.translate('petgen_event_hint'),
              maxLines: null,
              minLines: 5,
              requiredMsg: settings.translate('petgen_event_req'),
            ),

            _buildFieldTitle(settings.translate('petgen_req_label')),
            _buildInput(
              controller: _requestController,
              hint: settings.translate('petgen_req_hint'),
              maxLines: null,
              minLines: 3,
              requiredMsg: settings.translate('petgen_req_req'),
            ),

            const SizedBox(height: 28),

            // ── Kaydet Butonu ──────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : () => _saveToArchive(settings),
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
                  _isSaving ? settings.translate('petgen_saving') : settings.translate('petgen_save_btn'),
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
  Widget _buildPreview(SettingsController settings) {
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
              _generatePetitionText(settings),
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
                SnackBar(content: Text(settings.translate('petgen_pdf_saved'))),
              );
            },
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: Text(settings.translate('petgen_pdf_btn')),
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
