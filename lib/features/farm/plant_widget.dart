import 'package:flutter/material.dart';
import '../../models/plant_item.dart';

class PlantWidget extends StatelessWidget {
  final PlantItem plant;
  final VoidCallback? onLongPress; // للحذف لاحقاً

  const PlantWidget({
    super.key,
    required this.plant,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _getEmoji(),
            style: TextStyle(fontSize: _getSize()),
          ),
        ],
      ),
    );
  }

  String _getEmoji() {
    return switch (plant.type) {
      PlantType.seedling => '🌱',
      PlantType.flower   => '🌸',
      PlantType.tree     => '🌳',
    };
  }

  double _getSize() {
    return switch (plant.type) {
      PlantType.seedling => 28,
      PlantType.flower   => 36,
      PlantType.tree     => 48,
    };
  }
}