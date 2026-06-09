import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'features/home/home_screen.dart';

void main() {
  runApp(const GhrasApp());
}

class GhrasApp extends StatelessWidget {
  const GhrasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'غراس',
      debugShowCheckedModeBanner: false,

      // تطبيق الهوية البصرية لـ غراس
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,

        // تخصيص الأزرار ليكون لها زوايا دائرية ناعمة كما اتفقنا
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          ),
        ),

        // تخصيص شكل البطاقات (Cards) في التطبيق
        cardTheme: CardTheme(
          color: AppColors.surface,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      // الشاشة المؤقتة التي سيبدأ منها التطبيق (سننشئها في الخطوة القادمة)
      home: const HomeScreen(),
    ); // MaterialApp
  }
}
