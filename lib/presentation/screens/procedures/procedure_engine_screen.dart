// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Prosedür Motoru: Zenginleştirilmiş Ekran (Checklist + Kartlar + Akıllı Eşleşme)
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:pusula/core/theme/app_colors.dart';
import 'package:pusula/data/models/procedure_model.dart';
import 'package:pusula/data/services/service_definitions.dart';
import 'package:pusula/core/animations/app_animations.dart';
import 'package:pusula/data/services/settings_controller.dart';
import 'package:pusula/data/providers/workflow_provider.dart';
import 'package:provider/provider.dart';
import 'generic_detail_screen.dart';

class ProcedureEngineScreen extends StatefulWidget {
  final ProcedureCategory? initialCategory;
  const ProcedureEngineScreen({super.key, this.initialCategory});

  @override
  State<ProcedureEngineScreen> createState() => _ProcedureEngineScreenState();
}

class _ProcedureEngineScreenState extends State<ProcedureEngineScreen>
    with TickerProviderStateMixin {
  static const _tabs = ProcedureCategory.values;
  late final TabController _tabController;
  final Map<String, bool> _expandedCards = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: _getInitialIndex(),
    );
  }

  @override
  void didUpdateWidget(ProcedureEngineScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategory != oldWidget.initialCategory && widget.initialCategory != null) {
      final newIndex = _getInitialIndex();
      _tabController.animateTo(newIndex);
    }
  }

  int _getInitialIndex() {
    if (widget.initialCategory == null) return 0;
    final index = _tabs.indexOf(widget.initialCategory!);
    return index >= 0 ? index : 0;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleExpand(String id, ProcedureModel procedure) {
    setState(() {
      final isExpanded = _expandedCards[id] ?? false;
      _expandedCards[id] = !isExpanded;
      
      if (!isExpanded) {
        // Kart açıldığında provider'ı haberdar et (arşiv eşleşmesi vb. için)
        final workflow = Provider.of<WorkflowProvider>(context, listen: false);
        workflow.initChecklist(id, procedure);
        // Kritik tarihleri hatırla
        workflow.scheduleReminderFromProcedure(procedure);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsController>(context);
    final workflow = Provider.of<WorkflowProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    settings.translate('Prosedür Motoru'),
                    style: TextStyle(
                      fontSize: 24, // Biraz daha kompakt
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      letterSpacing: -0.6,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    settings.translate('Resmi işlemler için adım adım rehber'),
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? const Color(0xFFAAAAAA) : AppColors.text600,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildTabBar(settings),
            const SizedBox(height: 4),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: _tabs.map((cat) {
                  final procedures = ServiceDefinitions.getByCategory(cat);
                  return _ProcedureListView(
                    procedures: procedures,
                    category: cat,
                    expandedCards: _expandedCards,
                    onToggleExpand: _toggleExpand,
                    onOpenDetail: _openDetail,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(SettingsController settings) {
    return Container(
      height: 42,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.accent,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFFAAAAAA)
            : AppColors.text600,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        tabs: _tabs.map((cat) {
          final config = ProcedureModel.configFor(cat);
          return Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(config.icon, size: 14),
                  const SizedBox(width: 6),
                  Text(settings.translate(config.label)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _openDetail(ProcedureModel procedure) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GenericDetailScreen(procedure: procedure)),
    );
  }
}

class _ProcedureListView extends StatelessWidget {
  final List<ProcedureModel> procedures;
  final ProcedureCategory category;
  final Map<String, bool> expandedCards;
  final void Function(String id, ProcedureModel procedure) onToggleExpand;
  final void Function(ProcedureModel) onOpenDetail;

  const _ProcedureListView({
    required this.procedures,
    required this.category,
    required this.expandedCards,
    required this.onToggleExpand,
    required this.onOpenDetail,
  });

  @override
  Widget build(BuildContext context) {
    if (procedures.isEmpty) {
      return _EmptyState(category: category);
    }

    final config = ProcedureModel.configFor(category);

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
      physics: const BouncingScrollPhysics(),
      itemCount: procedures.length,
      itemBuilder: (_, i) => FadeInStaggered(
        index: i,
        child: _EnhancedProcedureCard(
          procedure: procedures[i],
          config: config,
          isExpanded: expandedCards[procedures[i].id] ?? false,
          onToggleExpand: () => onToggleExpand(procedures[i].id, procedures[i]),
          onOpenDetail: () => onOpenDetail(procedures[i]),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final ProcedureCategory category;
  const _EmptyState({required this.category});

  @override
  Widget build(BuildContext context) {
    final config = ProcedureModel.configFor(category);
    final settings = Provider.of<SettingsController>(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: config.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(config.icon, size: 48, color: config.color.withOpacity(0.7)),
            ),
            const SizedBox(height: 24),
            Text(
              settings.translate('start_procedure'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              settings.translate('pick_category_hint'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.55),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EnhancedProcedureCard extends StatelessWidget {
  final ProcedureModel procedure;
  final CategoryConfig config;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final VoidCallback onOpenDetail;

  const _EnhancedProcedureCard({
    required this.procedure,
    required this.config,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.onOpenDetail,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final workflow = Provider.of<WorkflowProvider>(context);
    final checkedSteps = workflow.checkedSteps[procedure.id] ?? [];
    
    int completedCount = checkedSteps.where((c) => c).length;
    int totalSteps = procedure.steps.length;
    double progress = totalSteps > 0 ? completedCount / totalSteps : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12), // Daha kompakt
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24), // 20-24px BorderRadius
        border: Border.all(
          color: isExpanded
              ? config.color.withOpacity(0.3)
              : Theme.of(context).dividerColor.withOpacity(0.08),
          width: isExpanded ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onToggleExpand,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(16), // %15 daha küçük padding
              child: Row(
                children: [
                  Container(
                    width: 44, // Küçültülmüş boyut
                    height: 44,
                    decoration: BoxDecoration(
                      color: config.color.withOpacity(isDark ? 0.15 : 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(config.icon, size: 22, color: config.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          procedure.name,
                          style: TextStyle(
                            fontSize: 14, // Daha küçük font
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          procedure.applicationVenue,
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: isExpanded ? config.color : Colors.grey[400],
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                _InfoChip(icon: Icons.payments_outlined, text: procedure.fee, color: const Color(0xFFF59E0B)),
                const SizedBox(width: 6),
                _InfoChip(icon: Icons.schedule_outlined, text: procedure.estimatedDuration, color: const Color(0xFF3A9E7A)),
                if (totalSteps > 0) ...[
                  const SizedBox(width: 6),
                  _InfoChip(icon: Icons.checklist_rounded, text: '$completedCount/$totalSteps', color: config.color),
                ],
              ],
            ),
          ),

          if (isExpanded && totalSteps > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: config.color.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(config.color),
                  minHeight: 4,
                ),
              ),
            ),

          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(height: 1, color: Theme.of(context).dividerColor.withOpacity(0.1)),
                
                // Gerekli Belgeler
                if (procedure.requiredDocuments.isNotEmpty)
                  _DocumentsSection(documents: procedure.requiredDocuments, color: config.color),

                // Checklist
                if (procedure.steps.isNotEmpty)
                  _ChecklistSection(
                    procedureId: procedure.id,
                    steps: procedure.steps,
                    checked: checkedSteps,
                    color: config.color,
                    procedure: procedure,
                  ),

                if (procedure.criticalNote != null)
                  _CriticalNoteBox(note: procedure.criticalNote!, isDark: isDark),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onOpenDetail,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: config.color,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Consumer<SettingsController>(
                        builder: (ctx, settings, _) => Text(
                          settings.translate('procedure_detail_btn'),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentsSection extends StatelessWidget {
  final List<RequiredDocument> documents;
  final Color color;
  const _DocumentsSection({required this.documents, required this.color});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsController>(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.folder_copy_rounded, size: 14, color: color),
                const SizedBox(width: 8),
                Text(settings.translate('required_documents'), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
            const SizedBox(height: 10),
            ...documents.map((doc) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline_rounded, size: 12, color: color.withOpacity(0.5)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(doc.name, style: const TextStyle(fontSize: 12))),
                  if (doc.isCritical)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text(settings.translate('mandatory_label'), style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: color)),
                    ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _ChecklistSection extends StatelessWidget {
  final String procedureId;
  final List<String> steps;
  final List<bool> checked;
  final Color color;
  final ProcedureModel procedure;

  const _ChecklistSection({
    required this.procedureId,
    required this.steps,
    required this.checked,
    required this.color,
    required this.procedure,
  });

  @override
  Widget build(BuildContext context) {
    final workflow = Provider.of<WorkflowProvider>(context);
    final settings = Provider.of<SettingsController>(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(settings.translate('checklist'), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6))),
          const SizedBox(height: 8),
          ...List.generate(steps.length, (i) {
            final isChecked = checked.length > i ? checked[i] : false;
            return CheckboxListTile(
              value: isChecked,
              onChanged: (_) => workflow.toggleStep(procedureId, i, procedure),
              title: Text(steps[i], style: TextStyle(fontSize: 12, decoration: isChecked ? TextDecoration.lineThrough : null, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(isChecked ? 0.5 : 1))),
              dense: true,
              contentPadding: EdgeInsets.zero,
              activeColor: color,
              controlAffinity: ListTileControlAffinity.leading,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            );
          }),
        ],
      ),
    );
  }
}

class _CriticalNoteBox extends StatelessWidget {
  final String note;
  final bool isDark;
  const _CriticalNoteBox({required this.note, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFD97706).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFFD97706)),
            const SizedBox(width: 8),
            Expanded(child: Text(note, style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFFFBBF24) : const Color(0xFF92400E)))),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _InfoChip({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}



