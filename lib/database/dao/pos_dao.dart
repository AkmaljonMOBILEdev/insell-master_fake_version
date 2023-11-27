import 'package:drift/drift.dart';
import 'package:easy_sell/database/table/pos_table.dart';
import '../my_database.dart';

part 'pos_dao.g.dart';

@DriftAccessor(tables: [POS])
class PosDao extends DatabaseAccessor<MyDatabase> with _$PosDaoMixin {
  PosDao(MyDatabase db) : super(db);

  // get all pos
  Future<List<POSData>> getAllPos() async {
    return await (select(pos)).get();
  }

  // get by id
  Future<POSData?> getById(int id) async {
    return await (select(pos)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // create new pos
  Future<POSData?> createPos(POSCompanion newPos) async {
    int id = await into(pos).insert(newPos);
    return await getById(id);
  }

  Future<POSData?> getPosByServerId(posServerId) async {
    return await (select(pos)..where((tbl) => tbl.serverId.equals(posServerId))).getSingleOrNull();
  }

  Future<bool> hasPosWithServerId(int serverId) async {
    return await (select(pos)..where((tbl) => tbl.serverId.equals(serverId))).getSingleOrNull() != null;
  }

  Future<int> updatePos(POSCompanion newPos) async {
    return await (update(pos)..where((tbl) => tbl.serverId.equals(newPos.serverId.value ?? -1))).write(newPos);
  }

}
