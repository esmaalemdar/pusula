import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';

// Yerel (Relative) Importlar — Hata payını sıfıra indirir
import 'package:pusula/core/theme/app_colors.dart';
import 'package:pusula/presentation/screens/auth/auth_screen.dart';
import 'package:pusula/data/services/settings_controller.dart';
import 'package:pusula/data/providers/workflow_provider.dart';
import 'package:pusula/data/services/database_service.dart';
import 'package:pusula/data/services/location_database_service.dart';
import 'package:pusula/data/providers/app_provider.dart';
import 'package:pusula/data/services/notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('.env dosyası yüklenemedi: $e');
  }

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase başlatılamadı: $e');
  }

  // Hive ve Diğer Servisler
  try {
    await DatabaseService().init();
    await LocationDatabaseService().init();
    await NotificationService().init();
  } catch (e) {
    debugPrint('Servisler başlatılamadı: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => WorkflowProvider()),
        ChangeNotifierProvider(create: (_) => SettingsController()),
      ],
      child: const PusulaApp(),
    ),
  );
}

class PusulaApp extends StatelessWidget {
  const PusulaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsController>(context);
    final isDarkMode = settings.isDarkMode;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: isDarkMode ? Colors.black : Colors.white,
        systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
        statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pusula',
      themeMode: settings.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorSchemeSeed: AppColors.accent,
        scaffoldBackgroundColor: AppColors.background,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        colorSchemeSeed: AppColors.neonSage,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const AuthScreen(),
    );
  }
}


