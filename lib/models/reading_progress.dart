import 'package:hive/hive.dart';
import 'plant_item.dart';

part 'reading_progress.g.dart';

@HiveType(typeId: 2)
class ReadingProgress extends HiveObject {
  @HiveField(0)
  int pagesRead; // الصفحات المقروءة (0-300)

  @HiveField(1)
  List<PlantItem> placedPlants; // الكائنات الموضوعة في الحديقة

  ReadingProgress({
    this.pagesRead = 0,
    List<PlantItem>? placedPlants,
  }) : placedPlants = placedPlants ?? [];

  // حساب الكائنات المكتسبة
  int get earnedSeedlings => pagesRead ~/ 5;  // كل 5 صفحات
  int get earnedFlowers   => pagesRead ~/ 10; // كل 10 صفحات
  int get earnedTrees     => pagesRead ~/ 20; // كل 20 صفحة

  // حساب الكائنات الموضوعة فعلاً في الحديقة
  int get placedSeedlings =>
      placedPlants.where((p) => p.type == PlantType.seedling).length;
  int get placedFlowers =>
      placedPlants.where((p) => p.type == PlantType.flower).length;
  int get placedTrees =>
      placedPlants.where((p) => p.type == PlantType.tree).length;

  // الكائنات المتاحة للوضع (مكتسبة ولم توضع بعد)
  int get availableSeedlings => earnedSeedlings - placedSeedlings;
  int get availableFlowers   => earnedFlowers   - placedFlowers;
  int get availableTrees     => earnedTrees     - placedTrees;
}