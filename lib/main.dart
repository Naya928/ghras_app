import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/app_colors.dart';
import 'features/home/home_screen.dart';
import 'models/plant_item.dart';
import 'models/reading_progress.dart';

void main() async {
  // ضروري قبل أي كود async في main
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Hive
  await Hive.initFlutter();

  // تسجيل الـ Models حتى يعرف Hive كيف يحفظها
  Hive.registerAdapter(PlantTypeAdapter());
  Hive.registerAdapter(PlantItemAdapter());
  Hive.registerAdapter(ReadingProgressAdapter());

  // فتح الصندوق (قاعدة البيانات)
  await Hive.openBox<ReadingProgress>('progress_box');
  await Hive.openBox<PlantItem>('plants_box');

  runApp(
    // ProviderScope ضروري لـ Riverpod يشتغل
    const ProviderScope(
      child: GhrasApp(),
    ),
  );
}

class GhrasApp extends StatelessWidget {
  const GhrasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'غراس',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 89, 106, 45),
            foregroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          ),
        ),
        cardTheme: CardTheme(
          color: AppColors.surface,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}