import 'package:hive/hive.dart';

part 'plant_item.g.dart';

@HiveType(typeId: 0)
enum PlantType {
  @HiveField(0)
  seedling, // غرسة

  @HiveField(1)
  flower, // زهرة

  @HiveField(2)
  tree, // شجرة
}

@HiveType(typeId: 1)
class PlantItem extends HiveObject {
  @HiveField(0)
  PlantType type;

  @HiveField(1)
  double x; // موقع أفقي في الحديقة (0.0 - 1.0)

  @HiveField(2)
  double y; // موقع رأسي في الحديقة (0.0 - 1.0)

  @HiveField(3)
  bool isPlaced; // هل وضعها المستخدم في الحديقة؟

  PlantItem({
    required this.type,
    required this.x,
    required this.y,
    this.isPlaced = false,
  });
}