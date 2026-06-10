import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/reading_provider.dart';
import '../farm/farm_view.dart';
import '../../models/plant_item.dart';

// غيّرنا من StatelessWidget إلى ConsumerWidget لنقدر نقرأ الـ Provider
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // نراقب البيانات — أي تغيير يعيد بناء الشاشة تلقائياً
    final progress = ref.watch(readingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'غراس',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. شريط التقدم
            _buildProgressCard(progress.pagesRead),

            const SizedBox(height: 24),

            // 2. الحديقة (مؤقتاً مستطيل فارغ)
            Expanded(
              child: FarmView(),
              ),

            const SizedBox(height: 16),

            // 3. المخزون (الكائنات المتاحة)
            _buildInventory(progress, ref),

            const SizedBox(height: 16),

            // 4. زر مؤقت للتجربة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref.read(readingProvider.notifier)
                        .updatePages(progress.pagesRead + 5);
                  },
                  child: const Text('+ 5 صفحات'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(readingProvider.notifier).reset();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade300,
                  ),
                  child: const Text('إعادة ضبط'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(int pages) {
    final percentage = pages / 300;

    return Card(
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
                    'تقدّمك في القراءة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$pages / 300 صفحة',
                    style: TextStyle(
                      color: AppColors.primary.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: percentage,
                    backgroundColor: Colors.white,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                    strokeWidth: 6,
                  ),
                ),
                Text(
                  '${(percentage * 100).toInt()}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventory(progress, ref) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _buildDraggableItem(
        '🌱',
        'غرسة',
        progress.availableSeedlings,
        PlantType.seedling,
        ref,
      ),
      _buildDraggableItem(
        '🌸',
        'زهرة',
        progress.availableFlowers,
        PlantType.flower,
        ref,
      ),
      _buildDraggableItem(
        '🌳',
        'شجرة',
        progress.availableTrees,
        PlantType.tree,
        ref,
      ),
    ],
  );
}

Widget _buildDraggableItem(
  String emoji,
  String label,
  int count,
  PlantType type,
  WidgetRef ref,
) {
  // لو ما عنده رصيد — يظهر باهت
  final hasStock = count > 0;

  return Opacity(
    opacity: hasStock ? 1.0 : 0.4,
    child: Column(
      children: [
        // قابل للسحب فقط لو عنده رصيد
        Draggable<PlantType>(
          data: type,
          feedback: Text(
            emoji,
            style: const TextStyle(fontSize: 40),
          ),
          childWhenDragging: Opacity(
            opacity: 0.3,
            child: Text(emoji, style: const TextStyle(fontSize: 32)),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 32)),
        ),
        Text(label, style: const TextStyle(color: AppColors.textMuted)),
        Text(
          '$count متاح',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

  Widget _buildInventoryItem(String emoji, String label, int count) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 32)),
        Text(label, style: const TextStyle(color: AppColors.textMuted)),
        Text(
          '$count متاح',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}