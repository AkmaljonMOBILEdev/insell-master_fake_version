import 'package:drift/drift.dart';
import 'package:easy_sell/database/table/pos_session_table.dart';
import '../my_database.dart';

part 'posSession_dao.g.dart';

@DriftAccessor(tables: [PosSession])
class PosSessionDao extends DatabaseAccessor<MyDatabase> with _$PosSessionDaoMixin {
  PosSessionDao(MyDatabase db) : super(db);

  // get all pos sessions
  Future<List<PosSessionData>> getAllPosSessions() async {
    return await (select(posSession)).get();
  }

  // get All with join
  Future<List<PosSessionDTO>> getAllPosSessionsWithJoin({bool desc = false}) async {
    final query = select(posSession).join([
      leftOuterJoin(
        employee,
        employee.id.equalsExp(posSession.cashier),
      ),
    ]);
    final typedResult = await query.get();
    return typedResult.map((row) {
      return PosSessionDTO(
        posSessionData: row.readTable(posSession),
        employeeData: row.readTable(employee),
      );
    }).toList();
  }

  // get all pos sessions un synced
  Future<List<PosSessionData>> getAllPosSessionsUnSynced() async {
    return await (select(posSession)..where((tbl) => tbl.syncedAt.isNull() | tbl.syncedAt.isSmallerThan(tbl.updatedAt))).get();
  }

  // get by id
  Future<PosSessionData?> getById(int id) async {
    return await (select(posSession)
          ..where((tbl) => tbl.id.equals(id))
          ..orderBy([
            (tbl) {
              return OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc);
            }
          ]))
        .getSingleOrNull();
  }

  // get last session
  Future<PosSessionData?> getLastSession() async {
    List<PosSessionData> sessions = await (select(posSession)
          ..where((tbl) => tbl.endTime.isNull())
          ..orderBy([
            (tbl) {
              return OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc);
            }
          ]))
        .get();
    if (sessions.isNotEmpty) {
      return sessions.first;
    }
    return null;
  }

  // create new open pos session
  Future<PosSessionData?> createOpenSession(PosSessionCompanion newSession) async {
    int id = await into(posSession).insert(newSession);
    return await getById(id);
  }

  // create new close pos session
  Future<PosSessionData?> createCloseSession(PosSessionCompanion endSession) async {
    int id = await into(posSession).insert(endSession);
    return await getById(id);
  }

  // update pos session
  Future<PosSessionData?> updatePosSession(PosSessionCompanion posSessionData) async {
    int? serverId = posSessionData.serverId.value;
    if (serverId != null) {
      await (update(posSession)..where((tbl) => tbl.serverId.equals(serverId))).write(posSessionData);
      return await getById(serverId);
    } else {
      await (update(posSession)..where((tbl) => tbl.id.equals(posSessionData.id.value))).write(posSessionData);
      return await getById(posSessionData.id.value);
    }
  }

  // update pos session by companion
  Future<void> updatePosSessionByCompanion(PosSessionCompanion posSessionData) async {
    await update(posSession).replace(posSessionData);
  }

  Future<bool> checkIfExistsByServerId(int serverId) async {
    List<PosSessionData> isExist = await (select(posSession)..where((tbl) => tbl.serverId.equals(serverId))).get();
    return isExist.isNotEmpty;
  }

  Future<PosSessionData?> getByServerId(int serverId) async {
    return await (select(posSession)..where((tbl) => tbl.serverId.equals(serverId))).getSingleOrNull();
  }

  Future<void> createPosSession(PosSessionCompanion newPosSession) async {
    await into(posSession).insert(newPosSession);
  }
}

class PosSessionDTO {
  PosSessionDTO({required this.posSessionData, required this.employeeData});

  final PosSessionData posSessionData;
  final EmployeeData? employeeData;
}
