// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Onboarding (Tanıtım) Ekranları
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:pusula/core/theme/app_colors.dart';
import '../auth/auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: "Hukuk Artık Karmaşık Değil",
      description: "Pusula, karmaşık yasal süreçleri adım adım rehberlerle basitleştirir. Her aşamada yanınızdayız.",
      image: "https://images.unsplash.com/photo-1589829545856-d10d557cf95f?q=80&w=2070&auto=format&fit=crop",
      icon: Icons.explore_rounded,
    ),
    OnboardingData(
      title: "Dilekçeniz Cebinizde",
      description: "Dakikalar içinde resmi formatta dilekçe oluşturun, PDF olarak kaydedin ve süreci başlatın.",
      image: "https://images.unsplash.com/photo-1450101499163-c8848c66ca85?q=80&w=2070&auto=format&fit=crop",
      icon: Icons.description_rounded,
    ),
    OnboardingData(
      title: "Güvenli ve Şeffaf Takip",
      description: "E-devlet entegrasyonu ve güvenli arşiv ile tüm hukuki dökümanlarınız elinizin altında.",
      image: "https://images.unsplash.com/photo-1560518883-ce09059eeffa?q=80&w=1973&auto=format&fit=crop",
      icon: Icons.security_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9), // Off-White
      body: Stack(
        children: [
          // 1. Sayfa İçeriği
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (int page) => setState(() => _currentPage = page),
            itemBuilder: (context, index) {
              return _OnboardingPage(data: _pages[index]);
            },
          ),

          // 2. Alt Kontroller
          Positioned(
            bottom: 60,
            left: 24,
            right: 24,
            child: Column(
              children: [
                // Sayfa Göstergeleri
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages.length, (index) => _buildDot(index)),
                ),
                const SizedBox(height: 40),

                // Butonlar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => _finishOnboarding(),
                      child: const Text("Atla", style: TextStyle(color: AppColors.text400, fontWeight: FontWeight.w600)),
                    ),
                    _currentPage == _pages.length - 1
                        ? ElevatedButton(
                            onPressed: () => _finishOnboarding(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7D9D85), // Sage Green
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: const Text("Hemen Başla", style: TextStyle(fontWeight: FontWeight.bold)),
                          )
                        : IconButton(
                            onPressed: () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                            icon: const Icon(Icons.arrow_forward_rounded, color: Color(0xFF7D9D85), size: 32),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? const Color(0xFF7D9D85) : const Color(0xFF7D9D85).withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  void _finishOnboarding() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthScreen()));
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Görsel Bölümü
        Expanded(
          flex: 6,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(data.image), fit: BoxFit.cover),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.5)],
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
              ),
              child: Center(
                child: Icon(data.icon, size: 100, color: Colors.white.withOpacity(0.8)),
              ),
            ),
          ),
        ),

        // Metin Bölümü
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  data.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String image;
  final IconData icon;
  OnboardingData({required this.title, required this.description, required this.image, required this.icon});
}



