import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/reading_provider.dart';
import '../../models/plant_item.dart';
import '../farm/mosaic_view.dart';
import '../reading/reading_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(readingProvider);
    final percentage = (progress.pagesRead / 300 * 100).toInt();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // 1. الهيدر
              _buildHeader(),

              const SizedBox(height: 12),

              // 2. نص التقدم
              Text(
                'لوحتك اكتملت $percentage%',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 20),

              // 3. إطار الموزاييك
              const MosaicView(),

              const SizedBox(height: 32),

              // 4. زر ابدأ وردك اليومي
              //
              _buildMainButton(context, ref, progress),
              
              const SizedBox(height: 20),

              // 5. أزرار الأذكار
              _buildAzkarButtons(),

              const SizedBox(height: 16),

              // زر التجربة المؤقت
              TextButton(
                onPressed: () {
                  ref.read(readingProvider.notifier)
                      .updatePages(progress.pagesRead + 15);
                },
                child: const Text(
                  '+ 15 صفحة (للتجربة)',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // أفاتار
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'طاب يومك بذكر الله',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textMain,
          ),
        ),
      ],
    );
  }

Widget _buildMainButton(BuildContext context, WidgetRef ref, progress) {    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ReadingScreen(),
    ),
  );
},
        icon: const Text('🌱', style: TextStyle(fontSize: 20)),
        label: const Text(
          'ابدأ وردك اليومي',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget _buildAzkarButtons() {
    final items = [
      'أذكار الصباح',
      'أذكار المساء',
      'ورد النوم',
      'عداد التسبيح',
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.5,
      children: items.map((label) {
        return ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary.withOpacity(0.15),
            foregroundColor: AppColors.textMain,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(label),
        );
      }).toList(),
    );
  }
}