import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/skeleton_loaders.dart';
import 'package:pusula/data/providers/app_provider.dart';
import 'package:pusula/data/providers/workflow_provider.dart';
import 'package:pusula/data/models/legal_category_model.dart';
import 'package:pusula/data/repositories/home_repository.dart';
import '../../common_widgets/app_bottom_nav.dart';
import '../procedures/procedure_engine_screen.dart';
import '../archive/archive_screen.dart';
import '../dictionary_screen.dart';
import '../profile/profile_screen.dart';
import '../rights_guide_screen.dart';
import 'package:pusula/core/theme/app_colors.dart';
import 'widgets/category_grid.dart';
import 'widgets/home_header.dart';
import 'widgets/section_title.dart';
import 'widgets/smart_search_bar.dart';
import 'package:pusula/data/models/procedure_model.dart';
import 'package:pusula/data/models/legal_event_model.dart';
import 'widgets/upcoming_deadlines.dart';
import 'package:pusula/data/services/settings_controller.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  const HomeScreen({super.key, required this.userName, required this.userEmail});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repo = HomeRepository();

  int _selectedIndex = 0;
  ProcedureCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppProvider>(context);
    final workflow = Provider.of<WorkflowProvider>(context);
    final settings = Provider.of<SettingsController>(context);

    // Fetch categories and deadlines dynamically depending on active language
    final categories = _repo.getCategories(settings.language);
    final repoDeadlines = _repo.getUpcomingDeadlines(settings.language);

    // Birleştirilmiş Deadline Listesi (Repository + Workflow'dan tetiklenenler)
    final allDeadlines = [...repoDeadlines, ...workflow.procedureDeadlines];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          if (appState.isOffline)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Theme.of(context).colorScheme.errorContainer,
              child: Text(
                settings.translate('offline_mode'),
                style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer, fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                AnimatedCrossFade(
                  firstChild: const HomeSkeleton(),
                  secondChild: _buildHomeContent(allDeadlines, categories),
                  crossFadeState: appState.isLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 500),
                ),
                ProcedureEngineScreen(
                  initialCategory: _selectedCategory,
                ),
                ArchiveScreen(isActive: _selectedIndex == 2),
                ProfileScreen(userName: widget.userName, userEmail: widget.userEmail),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        selectedIndex: _selectedIndex,
        onIndexChanged: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }

  Widget _buildHomeContent(List<LegalEventModel> deadlines, List<LegalCategoryModel> categories) {
    final settings = Provider.of<SettingsController>(context, listen: false);
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeader(userName: widget.userName),
            const SizedBox(height: 20),
            SmartSearchBar(
              onCategoryMatch: (category) {
                setState(() {
                  _selectedCategory = category;
                  _selectedIndex = 1;
                });
              },
            ),
            const SizedBox(height: 24),
            SectionTitle(
              title: settings.translate('upcoming_deadlines'),
            ),
            const SizedBox(height: 12),
            // YATAY LİSTE GÖRÜNÜMÜ
            UpcomingDeadlines(deadlines: deadlines),
            const SizedBox(height: 20),
            _buildRightsGuideCard(context),
            const SizedBox(height: 28),
            SectionTitle(
              title: settings.translate('categories'),
              actionLabel: settings.translate('all'),
              onAction: () {
                setState(() {
                  _selectedCategory = null; // Tümünü gör deyince sıfırla veya ilk sekmeye git
                  _selectedIndex = 1;
                });
              },
            ),
            const SizedBox(height: 14),
            CategoryGrid(
              categories: categories,
              onCategoryTap: _onCategoryTap,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildRightsGuideCard(BuildContext context) {
    final settings = Provider.of<SettingsController>(context);
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RightsGuideScreen()),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary.withOpacity(0.18), width: 1.2),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.gavel_outlined,
                  color: AppColors.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      settings.translate('rights_guide_title'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      settings.translate('rights_guide_desc'),
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 18, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }

  void _onCategoryTap(LegalCategoryModel category) {
    ProcedureCategory? target;
    switch (category.id) {
      case 'cat-1': target = ProcedureCategory.vatandaslik; break;
      case 'cat-2': target = ProcedureCategory.tapu; break;
      case 'cat-3': target = ProcedureCategory.tasit; break;
      case 'cat-4': target = ProcedureCategory.kira; break;
      case 'cat-5': target = ProcedureCategory.pasaport; break;
      case 'cat-6': target = ProcedureCategory.sgk; break;
      case 'cat-7': target = ProcedureCategory.egitim; break;
      case 'cat-8': target = ProcedureCategory.aile; break;
      case 'cat-9': target = ProcedureCategory.dijitalDevlet; break;
      case 'cat-10':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DictionaryScreen()),
        );
        return;
    }

    setState(() {
      _selectedCategory = target;
      _selectedIndex = 1;
    });
  }
}
