import 'package:drift/drift.dart';
import 'package:easy_sell/database/table/region_table.dart';
import '../my_database.dart';

part 'region_dao.g.dart';

@DriftAccessor(tables: [Region])
class RegionDao extends DatabaseAccessor<MyDatabase> with _$RegionDaoMixin {
  RegionDao(MyDatabase db) : super(db);

  Future<List<RegionData>> getAllRegions() async {
    return await (select(region)).get();
  }

  Future<void> createRegion(RegionData copyWith) async {
    bool isExist = (await (select(region)..where((tbl) => tbl.serverId.equals(copyWith.serverId ?? -1))).get()).isNotEmpty;
    if (!isExist) {
      await into(region).insert(copyWith);
    }
  }

  Future<List<RegionData>> getAllRegionsByParentId({int? parentId}) async {
    return await (select(region)
          ..where((tbl) {
            return parentId == null ? tbl.parentId.isNull() : tbl.parentId.equals(parentId);
          }))
        .get();
  }

  Future createRegionWithCompanion(RegionCompanion newRegion) async {
    return await into(region).insert(newRegion);
  }

  Future updateRegion(RegionData updatedCategory) async {
    await update(region).replace(updatedCategory);
  }

  Future<List<RegionData>> getAllUnsyncedRegions() async {
    return await (select(region)..where((tbl) => tbl.serverId.isNull() | tbl.updatedAt.isBiggerThan(tbl.syncedAt))).get();
  }

  Future<RegionData> getById(int parentId) async {
    return await (select(region)..where((tbl) => tbl.id.equals(parentId))).getSingle();
  }
}
