import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/plant_item.dart';
import '../../providers/reading_provider.dart';
import 'plant_widget.dart';

class FarmView extends ConsumerWidget {
  const FarmView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(readingProvider);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFB3E5FC),
            Color(0xFF81C784),
          ],
          stops: [0.0, 0.6],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
  children: [
    // طبقة الأرض
    Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 120,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8D6E63),
              Color(0xFF5D4037),
            ],
          ),
        ),
      ),
    ),

    // خطوط الحرث
    Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 120,
      child: CustomPaint(
        painter: _FurrowPainter(),
      ),
    ),

    // منطقة الـ Drop
    DragTarget<PlantType>(
      onAcceptWithDetails: (details) {
        // نحسب الموقع النسبي داخل الحديقة
        final box = context.findRenderObject() as RenderBox;
        final localOffset = box.globalToLocal(details.offset);
        final size = box.size;

        final x = (localOffset.dx / size.width).clamp(0.05, 0.95);
        final y = (localOffset.dy / size.height).clamp(0.05, 0.85);

        ref.read(readingProvider.notifier).placePlant(
          details.data,
          x,
          y,
        );
      },
      builder: (context, candidateData, rejectedData) {
        // تضيء الحديقة لما تسحب عليها
        final isHovering = candidateData.isNotEmpty;

        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: isHovering
                ? Border.all(color: Colors.white, width: 3)
                : null,
          ),
        );
      },
    ),

    // عرض الكائنات الموضوعة
    LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: progress.placedPlants.map((plant) {
            return Positioned(
              left: plant.x * constraints.maxWidth - 24,
              top: plant.y * constraints.maxHeight - 24,
              child: PlantWidget(
                plant: plant,
                onLongPress: () {
                  ref.read(readingProvider.notifier).removePlant(plant);
                },
              ),
            );
          }).toList(),
        );
      },
    ),

    // لو الحديقة فارغة
    if (progress.placedPlants.isEmpty)
      const Center(
        child: Text(
          'اسحب كائناتك هنا 🌱',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black26,
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ),
  ],
),
      ),
    );
  }
}

class _FurrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4E342E).withOpacity(0.4)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const lineCount = 5;
    final spacing = size.height / lineCount;

    for (int i = 1; i < lineCount; i++) {
      final y = i * spacing;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}