import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'غراس',
          style:
              TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. بطاقة تتبع التقدم الإجمالي
            Card(
              color: AppColors.lightGreen,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'تَقَدُّمك اليومي',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'اكتملت نبتتك بنسبة 65%.. استمر!',
                            style: TextStyle(
                                color: AppColors.primary.withOpacity(0.8)),
                          ),
                        ],
                      ),
                    ),
                    // مؤشر التقدم الدائري
                    const Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            value: 0.65, // النسبة المؤقتة 65%
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary),
                            strokeWidth: 6,
                          ),
                        ),
                        Text(
                          '65%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // عنوان قائمة المهام
            const Text(
              'غروسك الحالية',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),

            const SizedBox(height: 12),

            // 2. قائمة المهام اليومية (نموذج مؤقت)
            Expanded(
              child: ListView(
                children: [
                  _buildTaskItem('قراءة 10 صفحات من الكتاب', true),
                  _buildTaskItem('مراجعة كود مشروع فلاتر', false),
                  _buildTaskItem('تمارين رياضية خفيفة', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget مخصص لبناء عنصر المهمة في القائمة
  Widget _buildTaskItem(String title, bool isCompleted) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(
          isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isCompleted ? AppColors.secondary : AppColors.textMuted,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.textMain,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
      ),
    );
  }
}
