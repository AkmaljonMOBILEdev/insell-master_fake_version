import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/utils/utils.dart';
import '../my_database.dart';
import '../table/client_table.dart';
import 'package:http/http.dart' as http;

part 'client_dao.g.dart';

@DriftAccessor(tables: [Client])
class ClientDao extends DatabaseAccessor<MyDatabase> with _$ClientDaoMixin {
  ClientDao(MyDatabase db) : super(db);

  Future<ClientData> getById(int id) {
    return (select(client)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  // for count clients
  Future<List<ClientData>> getAllClients() async {
    return await (select(client)).get();
  }

  // get all clients by limit
  Future<List<ClientData>> getAllClientsByLimitOrSearch({int limit = 10, int offset = 0, String search = ''}) async {
    return await (select(client)
          ..where((tbl) => tbl.name.like('%$search%') | tbl.phoneNumber1.like('%$search%') | tbl.discountCard.like('%$search%'))
          ..orderBy([
            (tbl) {
              return OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc);
            }
          ])
          ..limit(limit, offset: limit * offset))
        .get();
  }

  // create new client
  Future<ClientData> createClient(ClientCompanion customerData) async {
    int id = await into(client).insert(customerData);
    return await getById(id);
  }

  // batch create clients
  Future<void> batchCreateClients(List<ClientCompanion> clients) async {
    await batch((batch) {
      batch.insertAll(client, clients);
    });
  }

  // update client
  Future<void> updateClient(ClientData entry) async {
    await update(client).replace(entry);
  }

  // update client by companion
  Future<void> updateClientByCompanion(ClientCompanion entry) async {
    await update(client).replace(entry);
  }

  // update by updateByServerId
  Future<void> updateByServerId(ClientCompanion entry) async {
    await (update(client)..where((tbl) => tbl.serverId.equals(entry.serverId.value ?? -1))).write(entry);
  }

  // sync client
  Future<bool> syncClient(ClientData newClientData) async {
    Map<String, dynamic> request = {
      "name": newClientData.name,
      "address": newClientData.address,
      "phoneNumber": newClientData.phoneNumber1,
      "phoneNumber2": newClientData.phoneNumber2,
      "gender": newClientData.gender,
      "organizationName": newClientData.organizationName,
      "description": newClientData.description,
      "regionId": newClientData.regionId,
    };
    final http.Response response;
    if (newClientData.serverId == null) {
      response = await HttpServices.post("/client/create", request);
    } else {
      response = await HttpServices.put("/client/${newClientData.serverId}", request);
    }
    if (response.statusCode == 201 || response.statusCode == 200) {
      var json = jsonDecode(response.body);
      await updateClient(newClientData.copyWith(
        isSynced: true,
        serverId: toValue(json['id']),
        syncedAt: toValue(DateTime.now()),
        updatedAt: DateTime.now(),
      ));
      return true;
    } else {
      throw Exception('Error: ${response.body}');
    }
  }

  // check if client has unSynced
  Future<bool> hasUnSyncedClient() async {
    return (await (select(client)..where((tbl) => tbl.isSynced.equals(false))).get()).isNotEmpty;
  }

  // check by serverId
  Future<bool> checkIfClientExistsByServerId(ClientCompanion newClientCompanion) async {
    final result =
        await (select(client)..where((tbl) => tbl.serverId.equals(newClientCompanion.serverId.value ?? -1))).getSingleOrNull();
    return result != null;
  }

  Future<List<ClientData>> getAllPosCustomersUnSynced() {
    return (select(client)..where((tbl) => tbl.syncedAt.isNull() | tbl.syncedAt.isSmallerThan(tbl.updatedAt))).get();
  }

  Future<ClientData?> getClientByDiscountCard(String? barcode) async {
    if (barcode == null) return null;
    return await (select(client)
          ..where((tbl) => tbl.discountCard.equals(barcode))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<ClientData?> getByServerId(int id) async {
    return await (select(client)..where((tbl) => tbl.serverId.equals(id))).getSingleOrNull();
  }
}
