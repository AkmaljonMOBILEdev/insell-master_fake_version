import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:easy_sell/database/table/category_table.dart';
import 'package:easy_sell/services/https_services.dart';
import 'package:easy_sell/utils/utils.dart';
import '../my_database.dart';
import 'package:http/http.dart' as http;

part 'category_dao.g.dart';

@DriftAccessor(tables: [Category])
class CategoryDao extends DatabaseAccessor<MyDatabase> with _$CategoryDaoMixin {
  CategoryDao(MyDatabase db) : super(db);

  // get all categories
  Future<List<CategoryData>> getAllCategories() => select(category).get();

  // get all unsynced categories
  Future<List<CategoryData>> getAllUnsyncedCategories() =>
      (select(category)..where((tbl) => tbl.isSyncedAt.isNull() | tbl.isSyncedAt.isSmallerThan(tbl.updatedAt))).get();

  // get category by id
  Future<CategoryData> getById(int id) async {
    CategoryData? category = await (select(this.category)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (category == null) {
      category = await (select(this.category)..where((tbl) => tbl.serverId.equals(id))).getSingleOrNull();
      if (category == null) {
        return CategoryData(
          id: -1,
          name: 'Boshqa',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isSynced: false,
        );
      }
    }
    return category;
  }

  // get category by server id
  Future<CategoryData?> getByParentId(int parentId) =>
      (select(category)..where((tbl) => tbl.parentId.equals(parentId))).getSingleOrNull();

  // get category by id if id is null then get all categories
  Future<List<CategoryData>> getAllCategoriesById({int? parentId}) {
    if (parentId == null) {
      return (select(category)..where((tbl) => tbl.parentId.isNull())).get();
    } else {
      return (select(category)..where((tbl) => tbl.parentId.equals(parentId))).get();
    }
  }

  // create new category
  Future<CategoryData> createCategory(
      {required String name,
      int? parentId,
      required DateTime createdAt,
      required DateTime updatedAt,
      String? description}) async {
    int id = await into(category).insert(
      CategoryCompanion(
        name: Value(name),
        parentId: Value(parentId),
        createdAt: Value(createdAt),
        updatedAt: Value(updatedAt),
        description: Value(description),
      ),
    );
    return await getById(id);
  }

  // create new category
  Future<CategoryData?> createCategoryWithCompanion(CategoryCompanion categoryData) async {
    int? serverId = categoryData.serverId.value;
    if (serverId != null) {
      CategoryData? isExist = await getCategoryByServerId(serverId);
      if (isExist != null) {
        int id = await updateCategoryById(
          isExist.id,
          serverId: serverId,
          updatedAt: categoryData.updatedAt.value,
          code: categoryData.code.value ?? '',
        );
        return await getById(id);
      }
    }
    int id = await into(category).insert(categoryData);
    return await getById(id);
  }

  // batch create categories
  Future<void> batchCreateCategory(List<CategoryCompanion> categoriesList) async {
    await batch((batch) {
      batch.insertAll(category, categoriesList);
    });
  }

  // update category by category id
  Future<int> updateCategoryById(int id, {required serverId, required String code, required DateTime updatedAt}) {
    return (update(category)..where((tbl) => tbl.id.equals(id))).write(
      CategoryCompanion(
        serverId: Value(serverId),
        code: Value(code),
        updatedAt: Value(updatedAt),
        isSyncedAt: Value(DateTime.now()),
        isSynced: const Value(true),
      ),
    );
  }

  // update category by categoryData
  Future<CategoryData> updateCategory(CategoryData categoryData) {
    update(category).replace(categoryData);
    return getById(categoryData.id);
  }

  // update category by categoryCompanion
  Future<CategoryData> updateCategoryByCompanion(CategoryCompanion categoryData) {
    update(category).replace(categoryData);
    return getById(categoryData.id.value);
  }

  Future<CategoryData> updateByNameCategory(int id,
      {required String name, required DateTime updatedAt, String? description, int? parentId}) async {
    await (update(category)..where((tbl) => tbl.id.equals(id))).write(CategoryCompanion(
      name: Value(name),
      updatedAt: Value(updatedAt),
      description: Value(description),
      parentId: Value(parentId),
    ));
    return getById(id);
  }

  // update by server id
  Future<bool> updateByServerIdCategory(CategoryCompanion entry) async {
    return await (update(category)..where((tbl) => tbl.serverId.equals(entry.serverId.value ?? -1))).write(entry) > 0;
  }

  // sync category
  Future<void> syncCategory(CategoryData categoryData) async {
    int? serverId;
    if (categoryData.parentId != null) {
      CategoryData currentCategoryData = await getById(categoryData.parentId!);
      if (currentCategoryData.serverId != null) {
        serverId = currentCategoryData.serverId;
      }
    }
    Map<String, dynamic> data = {
      "name": categoryData.name,
      "description": categoryData.description,
      "code": categoryData.code,
      "parentId": serverId,
    };
    final http.Response response;
    if (categoryData.serverId == null) {
      response = await HttpServices.post('/category/create', data);
    } else {
      response = await HttpServices.put('/category/${categoryData.serverId}', data);
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      var json = jsonDecode(response.body);
      updateCategory(categoryData.copyWith(
        isSynced: true,
        isSyncedAt: toValue(DateTime.now()),
        serverId: toValue(json['id']),
        updatedAt: DateTime.now(),
        code: toValue(json['code']),
      ));
    }
  }

  // delete category all
  Future<int> deleteAllCategories() => delete(category).go();

  Future<CategoryData?> getCategoryByServerId(int serverId) {
    return (select(category)..where((tbl) => tbl.serverId.equals(serverId))).getSingleOrNull();
  }

  searchByName({required String search}) {
    return (select(category)..where((tbl) => tbl.name.like('%$search%'))).get();
  }
}
