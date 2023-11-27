import 'package:drift/drift.dart';
import 'package:easy_sell/database/table/season_table.dart';
import '../my_database.dart';

part 'season_dao.g.dart';

@DriftAccessor(tables: [Season])
class SeasonDao extends DatabaseAccessor<MyDatabase> with _$SeasonDaoMixin {
  SeasonDao(MyDatabase db) : super(db);

  Future<List<SeasonData>> getAllSeasons() async {
    return await (select(season)).get();
  }

  Future<void> createSeason(SeasonData copyWith) async {
    bool isExist = (await (select(season)..where((tbl) => tbl.serverId.equals(copyWith.serverId ?? -1))).get()).isNotEmpty;
    if (!isExist) {
      await into(season).insert(copyWith);
    }
  }

  Future<bool> checkWithServerId(int item) async {
    return (await (select(season)..where((tbl) => tbl.serverId.equals(item))).get()).isNotEmpty;
  }

  Future<void> updateByServerIdCategory(SeasonCompanion newSeason) async {
    await (update(season)..where((tbl) => tbl.serverId.equals(newSeason.serverId.value ?? -1))).write(newSeason);
  }

  Future<void> batchCreateSeasons(List<SeasonCompanion> seasonsCompanions) async {
    await batch((batch) {
      batch.insertAll(season, seasonsCompanions);
    });
  }
}
