// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Prosedür Motoru: Akıllı Detay Ekranı (Animasyonlu)
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:pusula/core/theme/app_colors.dart';
import 'package:pusula/data/models/procedure_model.dart';
import 'package:pusula/data/services/workflow_controller.dart';
import 'package:pusula/data/providers/workflow_provider.dart';
import 'package:pusula/data/services/settings_controller.dart';
import 'package:pusula/core/animations/app_animations.dart';
import '../petition/petition_generator_screen.dart';

class GenericDetailScreen extends StatefulWidget {
  final ProcedureModel procedure;
  const GenericDetailScreen({super.key, required this.procedure});

  @override
  State<GenericDetailScreen> createState() => _GenericDetailScreenState();
}

class _GenericDetailScreenState extends State<GenericDetailScreen> with SingleTickerProviderStateMixin {
  late WorkflowResult _result;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  bool _isStudent = false;
  bool _isDisabled = false;
  bool _isPensioner = false;
  int? _userAge;

  @override
  void initState() {
    super.initState();
    _updateResult();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  void _updateResult() {
    setState(() {
      _result = WorkflowController.evaluate(widget.procedure, isStudent: _isStudent, isDisabled: _isDisabled, isPensioner: _isPensioner, userAge: _userAge);
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // Lottie Başarı Animasyonu Göster
  void _showSuccessAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          width: 200, height: 200,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(24)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 600),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.accent,
                        size: 60,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Text(
                "Dilekçe Hazır!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                  decoration: TextDecoration.none,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Diyaloğu kapat
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PetitionGeneratorScreen(
            categoryName: widget.procedure.category.name,
            userName: "Kullanıcı", // Provider'dan isim çekilebilir
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = ProcedureModel.configFor(widget.procedure.category);
    final workflow = Provider.of<WorkflowProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(config),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // STAGGERED INFO CARDS
                      ...List.generate(3, (i) => FadeInStaggered(index: i, child: _buildInfoCardByIndex(i, config))),
                      const SizedBox(height: 24),
                      FadeInStaggered(index: 3, child: _buildPersonalizationSection(config)),
                      const SizedBox(height: 24),
                      if (_result.reminders.isNotEmpty) FadeInStaggered(index: 4, child: _buildRemindersSection()),
                      const SizedBox(height: 24),
                      _buildDocumentsSection(config),
                      const SizedBox(height: 24),
                      _buildStepsSection(config),
                      const SizedBox(height: 40),
                      _buildOfficialDisclaimer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildStickyAction(config, workflow),
        ],
      ),
    );
  }

  Widget _buildAppBar(CategoryConfig config) {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: config.color,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(widget.procedure.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
        background: Hero(
          tag: widget.procedure.id,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset('assets/images/categories/${widget.procedure.category.name}.png', fit: BoxFit.cover),
              Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withOpacity(0.3), config.color.withOpacity(0.8)]))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCardByIndex(int index, CategoryConfig config) {
    final settings = SettingsController();
    if (index == 0) return _InfoCard(icon: Icons.location_on_outlined, label: settings.translate('application_venue'), value: widget.procedure.applicationVenue, color: config.color);
    if (index == 1) return Padding(padding: const EdgeInsets.only(top: 12), child: _InfoCard(icon: Icons.payments_outlined, label: settings.translate('procedure_fee'), value: _result.calculatedFee ?? widget.procedure.fee, color: const Color(0xFFF59E0B)));
    return Padding(padding: const EdgeInsets.only(top: 12), child: _InfoCard(icon: Icons.schedule_outlined, label: settings.translate('estimated_duration'), value: widget.procedure.estimatedDuration, color: const Color(0xFF3A9E7A)));
  }

  Widget _buildStickyAction(CategoryConfig config, WorkflowProvider workflow) {
    final settings = SettingsController();
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(24)), boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -4))]),
        child: ElevatedButton(
          onPressed: () {
            if (workflow.canCreatePetition) {
              workflow.startProcedure(widget.procedure);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PetitionGeneratorScreen(
                    categoryName: widget.procedure.category.name,
                    userName: "Kullanıcı", 
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: AppColors.error, content: Text(workflow.getMissingFieldWarning() ?? settings.translate('fill_missing_fields'))));
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: config.color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.edit_note_rounded), const SizedBox(width: 10), Text(settings.translate('create_petition'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),
        ),
      ),
    );
  }

  Widget _buildPersonalizationSection(CategoryConfig config) {
    final settings = SettingsController();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(settings.translate('personalization'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        _PersonalToggle(label: settings.translate('student'), value: _isStudent, icon: Icons.school_outlined, onChanged: (v) { _isStudent = v; _updateResult(); }),
        _PersonalToggle(label: settings.translate('pensioner'), value: _isPensioner, icon: Icons.elderly_rounded, onChanged: (v) { _isPensioner = v; _updateResult(); }),
      ]),
    );
  }

  Widget _buildRemindersSection() => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFD97706).withOpacity(0.1), borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: _result.reminders.map((r) => Text(r, style: TextStyle(fontSize: 13, color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFFFBBF24) : const Color(0xFF92400E)))).toList()));

  Widget _buildDocumentsSection(CategoryConfig config) {
    final settings = SettingsController();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(settings.translate('required_documents'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
      const SizedBox(height: 14),
      ...List.generate(widget.procedure.requiredDocuments.length, (i) => FadeInStaggered(index: i + 5, child: _DocumentTile(doc: widget.procedure.requiredDocuments[i], config: config))),
    ]);
  }

  Widget _buildStepsSection(CategoryConfig config) {
    final settings = SettingsController();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(settings.translate('roadmap'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
      const SizedBox(height: 14),
      ...List.generate(widget.procedure.steps.length, (i) => FadeInStaggered(index: i + 10, child: _StepTile(stepNumber: i + 1, text: widget.procedure.steps[i], color: config.color, isLast: i == widget.procedure.steps.length - 1))),
    ]);
  }

  Widget _buildOfficialDisclaimer() => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12)), child: Text(_result.officialDisclaimer, style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5))));
}

class _PersonalToggle extends StatelessWidget {
  final String label; final bool value; final IconData icon; final Function(bool) onChanged;
  const _PersonalToggle({required this.label, required this.value, required this.icon, required this.onChanged});
  @override
  Widget build(BuildContext context) => ListTile(contentPadding: EdgeInsets.zero, leading: Icon(icon, size: 20, color: AppColors.accent), title: Text(label, style: const TextStyle(fontSize: 14)), trailing: Switch.adaptive(value: value, onChanged: onChanged));
}

class _InfoCard extends StatelessWidget {
  final IconData icon; final String label; final String value; final Color color; final String? actionLabel; final VoidCallback? onAction;
  const _InfoCard({required this.icon, required this.label, required this.value, required this.color, this.actionLabel, this.onAction});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 12)]), child: Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)), child: Icon(icon, size: 20, color: color)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.4))), Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.bodyLarge?.color))])), if (actionLabel != null) TextButton(onPressed: onAction, child: Text(actionLabel!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)))]));
}

class _DocumentTile extends StatelessWidget {
  final RequiredDocument doc; final CategoryConfig config;
  const _DocumentTile({required this.doc, required this.config});
  @override
  Widget build(BuildContext context) {
    final settings = SettingsController();
    return Container(
      margin: const EdgeInsets.only(bottom: 10), 
      padding: const EdgeInsets.all(14), 
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, 
        borderRadius: BorderRadius.circular(14), 
        border: Border.all(color: doc.isCritical ? config.color.withOpacity(0.2) : Theme.of(context).dividerColor.withOpacity(0.2))
      ), 
      child: Row(children: [
        Icon(
          doc.source == 'Arşiv' || doc.name == 'Öğrenci Belgesi' || doc.name == 'İkametgah Belgesi'
              ? Icons.check_circle_rounded
              : Icons.description_outlined, 
          size: 18, 
          color: doc.source == 'Arşiv' || doc.name == 'Öğrenci Belgesi' || doc.name == 'İkametgah Belgesi'
              ? Colors.green
              : (doc.isCritical ? config.color : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.4))
        ), 
        const SizedBox(width: 12), 
        Expanded(child: Text(doc.name, style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color))), 
        if (doc.source == 'Arşiv' || doc.name == 'Öğrenci Belgesi' || doc.name == 'İkametgah Belgesi')
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), 
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1), 
              borderRadius: BorderRadius.circular(4)
            ), 
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_done_rounded, size: 10, color: Colors.green),
                const SizedBox(width: 4),
                Text(
                  settings.translate('in_archive'),
                  style: const TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        else if (doc.isCritical) 
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), 
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer, 
              borderRadius: BorderRadius.circular(4)
            ), 
            child: Text(
              settings.translate('mandatory_label'),
              style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold),
            ),
          )
      ])
    );
  }
}

class _StepTile extends StatelessWidget {
  final int stepNumber; final String text; final Color color; final bool isLast;
  const _StepTile({required this.stepNumber, required this.text, required this.color, this.isLast = false});
  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Column(children: [Container(width: 24, height: 24, decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Center(child: Text('$stepNumber', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)))), if (!isLast) Container(width: 2, height: 30, color: color.withOpacity(0.1))]), const SizedBox(width: 12), Expanded(child: Padding(padding: const EdgeInsets.only(bottom: 20), child: Text(text, style: const TextStyle(fontSize: 13, height: 1.4))))]);
}



