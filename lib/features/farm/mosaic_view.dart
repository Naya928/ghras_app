import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/reading_provider.dart';

class MosaicView extends ConsumerWidget {
  const MosaicView({super.key});

  static const int rows = 5;
  static const int cols = 4;
  static const int totalPieces = rows * cols; // 20

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(readingProvider);
    final earned = progress.earnedPieces.clamp(0, totalPieces);

    return Container(
      decoration: BoxDecoration(
        // الإطار الذهبي
        border: Border.all(color: const Color(0xFFD4A853), width: 12),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4A853).withOpacity(0.4),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            childAspectRatio: 1,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: totalPieces,
          itemBuilder: (context, index) {
            final row = index ~/ cols;
            final col = index % cols;
            final isEarned = index < earned;

            return _buildPiece(row, col, isEarned);
          },
        ),
      ),
    );
  }

  Widget _buildPiece(int row, int col, bool isEarned) {
    if (isEarned) {
      // القطعة مكتسبة — اعرض الصورة
      return Image.asset(
        'assets/mosaic/piece_${row}_$col.png',
        fit: BoxFit.cover,
      );
    } else {
      // القطعة غير مكتسبة — placeholder رمادي
      return Container(
        color: const Color(0xFFEDE8E0),
        child: const Icon(
          Icons.lock_outline,
          color: Color(0xFFCCC0B0),
          size: 16,
        ),
      );
    }
  }
}