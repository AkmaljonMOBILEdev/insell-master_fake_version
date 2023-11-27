// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_database.dart';

// ignore_for_file: type=lint
class $RegionTable extends Region with TableInfo<$RegionTable, RegionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RegionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<RegionType?, String> type =
      GeneratedColumn<String>('type', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<RegionType?>($RegionTable.$convertertypen);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
      'server_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        parentId,
        type,
        name,
        code,
        createdAt,
        updatedAt,
        isSynced,
        syncedAt,
        serverId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'region';
  @override
  VerificationContext validateIntegrity(Insertable<RegionData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    context.handle(_typeMeta, const VerificationResult.success());
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RegionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RegionData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parent_id']),
      type: $RegionTable.$convertertypen.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced']),
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_id']),
    );
  }

  @override
  $RegionTable createAlias(String alias) {
    return $RegionTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RegionType, String, String> $convertertype =
      const EnumNameConverter<RegionType>(RegionType.values);
  static JsonTypeConverter2<RegionType?, String?, String?> $convertertypen =
      JsonTypeConverter2.asNullable($convertertype);
}

class RegionData extends DataClass implements Insertable<RegionData> {
  final int id;
  final int? parentId;
  final RegionType? type;
  final String name;
  final String code;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool? isSynced;
  final DateTime? syncedAt;
  final int? serverId;
  const RegionData(
      {required this.id,
      this.parentId,
      this.type,
      required this.name,
      required this.code,
      required this.createdAt,
      required this.updatedAt,
      this.isSynced,
      this.syncedAt,
      this.serverId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    if (!nullToAbsent || type != null) {
      final converter = $RegionTable.$convertertypen;
      map['type'] = Variable<String>(converter.toSql(type));
    }
    map['name'] = Variable<String>(name);
    map['code'] = Variable<String>(code);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || isSynced != null) {
      map['is_synced'] = Variable<bool>(isSynced);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    return map;
  }

  RegionCompanion toCompanion(bool nullToAbsent) {
    return RegionCompanion(
      id: Value(id),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      name: Value(name),
      code: Value(code),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: isSynced == null && nullToAbsent
          ? const Value.absent()
          : Value(isSynced),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
    );
  }

  factory RegionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RegionData(
      id: serializer.fromJson<int>(json['id']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      type: $RegionTable.$convertertypen
          .fromJson(serializer.fromJson<String?>(json['type'])),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String>(json['code']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool?>(json['isSynced']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      serverId: serializer.fromJson<int?>(json['serverId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'parentId': serializer.toJson<int?>(parentId),
      'type':
          serializer.toJson<String?>($RegionTable.$convertertypen.toJson(type)),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String>(code),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool?>(isSynced),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'serverId': serializer.toJson<int?>(serverId),
    };
  }

  RegionData copyWith(
          {int? id,
          Value<int?> parentId = const Value.absent(),
          Value<RegionType?> type = const Value.absent(),
          String? name,
          String? code,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<bool?> isSynced = const Value.absent(),
          Value<DateTime?> syncedAt = const Value.absent(),
          Value<int?> serverId = const Value.absent()}) =>
      RegionData(
        id: id ?? this.id,
        parentId: parentId.present ? parentId.value : this.parentId,
        type: type.present ? type.value : this.type,
        name: name ?? this.name,
        code: code ?? this.code,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isSynced: isSynced.present ? isSynced.value : this.isSynced,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        serverId: serverId.present ? serverId.value : this.serverId,
      );
  @override
  String toString() {
    return (StringBuffer('RegionData(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, parentId, type, name, code, createdAt,
      updatedAt, isSynced, syncedAt, serverId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RegionData &&
          other.id == this.id &&
          other.parentId == this.parentId &&
          other.type == this.type &&
          other.name == this.name &&
          other.code == this.code &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.syncedAt == this.syncedAt &&
          other.serverId == this.serverId);
}

class RegionCompanion extends UpdateCompanion<RegionData> {
  final Value<int> id;
  final Value<int?> parentId;
  final Value<RegionType?> type;
  final Value<String> name;
  final Value<String> code;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool?> isSynced;
  final Value<DateTime?> syncedAt;
  final Value<int?> serverId;
  const RegionCompanion({
    this.id = const Value.absent(),
    this.parentId = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.serverId = const Value.absent(),
  });
  RegionCompanion.insert({
    this.id = const Value.absent(),
    this.parentId = const Value.absent(),
    this.type = const Value.absent(),
    required String name,
    required String code,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.serverId = const Value.absent(),
  })  : name = Value(name),
        code = Value(code),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<RegionData> custom({
    Expression<int>? id,
    Expression<int>? parentId,
    Expression<String>? type,
    Expression<String>? name,
    Expression<String>? code,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<DateTime>? syncedAt,
    Expression<int>? serverId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (parentId != null) 'parent_id': parentId,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (serverId != null) 'server_id': serverId,
    });
  }

  RegionCompanion copyWith(
      {Value<int>? id,
      Value<int?>? parentId,
      Value<RegionType?>? type,
      Value<String>? name,
      Value<String>? code,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool?>? isSynced,
      Value<DateTime?>? syncedAt,
      Value<int?>? serverId}) {
    return RegionCompanion(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      type: type ?? this.type,
      name: name ?? this.name,
      code: code ?? this.code,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      syncedAt: syncedAt ?? this.syncedAt,
      serverId: serverId ?? this.serverId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (type.present) {
      final converter = $RegionTable.$convertertypen;

      map['type'] = Variable<String>(converter.toSql(type.value));
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RegionCompanion(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }
}

class $ClientTable extends Client with TableInfo<$ClientTable, ClientData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<int> code = GeneratedColumn<int>(
      'code', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dobDayMeta = const VerificationMeta('dobDay');
  @override
  late final GeneratedColumn<DateTime> dobDay = GeneratedColumn<DateTime>(
      'dob_day', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
      'gender', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneNumber1Meta =
      const VerificationMeta('phoneNumber1');
  @override
  late final GeneratedColumn<String> phoneNumber1 = GeneratedColumn<String>(
      'phone_number1', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneNumber2Meta =
      const VerificationMeta('phoneNumber2');
  @override
  late final GeneratedColumn<String> phoneNumber2 = GeneratedColumn<String>(
      'phone_number2', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _regionIdMeta =
      const VerificationMeta('regionId');
  @override
  late final GeneratedColumn<int> regionId = GeneratedColumn<int>(
      'region_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES region (id)'));
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _discountCardMeta =
      const VerificationMeta('discountCard');
  @override
  late final GeneratedColumn<String> discountCard = GeneratedColumn<String>(
      'discount_card', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _organizationNameMeta =
      const VerificationMeta('organizationName');
  @override
  late final GeneratedColumn<String> organizationName = GeneratedColumn<String>(
      'organization_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
      'server_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _clientCurrencyMeta =
      const VerificationMeta('clientCurrency');
  @override
  late final GeneratedColumnWithTypeConverter<ClientCurrency?, String>
      clientCurrency = GeneratedColumn<String>(
              'client_currency', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<ClientCurrency?>(
              $ClientTable.$converterclientCurrencyn);
  static const VerificationMeta _typeIdMeta = const VerificationMeta('typeId');
  @override
  late final GeneratedColumn<int> typeId = GeneratedColumn<int>(
      'type_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _cashbackIdMeta =
      const VerificationMeta('cashbackId');
  @override
  late final GeneratedColumn<int> cashbackId = GeneratedColumn<int>(
      'cashback_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _cashbackMeta =
      const VerificationMeta('cashback');
  @override
  late final GeneratedColumn<double> cashback = GeneratedColumn<double>(
      'cashback', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        code,
        name,
        dobDay,
        gender,
        phoneNumber1,
        phoneNumber2,
        address,
        regionId,
        category,
        discountCard,
        description,
        isSynced,
        organizationName,
        syncedAt,
        createdAt,
        updatedAt,
        serverId,
        clientCurrency,
        typeId,
        cashbackId,
        cashback
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'client';
  @override
  VerificationContext validateIntegrity(Insertable<ClientData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('dob_day')) {
      context.handle(_dobDayMeta,
          dobDay.isAcceptableOrUnknown(data['dob_day']!, _dobDayMeta));
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('phone_number1')) {
      context.handle(
          _phoneNumber1Meta,
          phoneNumber1.isAcceptableOrUnknown(
              data['phone_number1']!, _phoneNumber1Meta));
    }
    if (data.containsKey('phone_number2')) {
      context.handle(
          _phoneNumber2Meta,
          phoneNumber2.isAcceptableOrUnknown(
              data['phone_number2']!, _phoneNumber2Meta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('region_id')) {
      context.handle(_regionIdMeta,
          regionId.isAcceptableOrUnknown(data['region_id']!, _regionIdMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('discount_card')) {
      context.handle(
          _discountCardMeta,
          discountCard.isAcceptableOrUnknown(
              data['discount_card']!, _discountCardMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('organization_name')) {
      context.handle(
          _organizationNameMeta,
          organizationName.isAcceptableOrUnknown(
              data['organization_name']!, _organizationNameMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    context.handle(_clientCurrencyMeta, const VerificationResult.success());
    if (data.containsKey('type_id')) {
      context.handle(_typeIdMeta,
          typeId.isAcceptableOrUnknown(data['type_id']!, _typeIdMeta));
    }
    if (data.containsKey('cashback_id')) {
      context.handle(
          _cashbackIdMeta,
          cashbackId.isAcceptableOrUnknown(
              data['cashback_id']!, _cashbackIdMeta));
    }
    if (data.containsKey('cashback')) {
      context.handle(_cashbackMeta,
          cashback.isAcceptableOrUnknown(data['cashback']!, _cashbackMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClientData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClientData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}code']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      dobDay: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}dob_day']),
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gender'])!,
      phoneNumber1: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone_number1']),
      phoneNumber2: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone_number2']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      regionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}region_id']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      discountCard: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}discount_card']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      organizationName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}organization_name']),
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_id']),
      clientCurrency: $ClientTable.$converterclientCurrencyn.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}client_currency'])),
      typeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type_id']),
      cashbackId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cashback_id']),
      cashback: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cashback']),
    );
  }

  @override
  $ClientTable createAlias(String alias) {
    return $ClientTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ClientCurrency, String, String>
      $converterclientCurrency =
      const EnumNameConverter<ClientCurrency>(ClientCurrency.values);
  static JsonTypeConverter2<ClientCurrency?, String?, String?>
      $converterclientCurrencyn =
      JsonTypeConverter2.asNullable($converterclientCurrency);
}

class ClientData extends DataClass implements Insertable<ClientData> {
  final int id;
  final int? code;
  final String name;
  final DateTime? dobDay;
  final String gender;
  final String? phoneNumber1;
  final String? phoneNumber2;
  final String? address;
  final int? regionId;
  final String? category;
  final String? discountCard;
  final String? description;
  final bool isSynced;
  final String? organizationName;
  final DateTime? syncedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? serverId;
  final ClientCurrency? clientCurrency;
  final int? typeId;
  final int? cashbackId;
  final double? cashback;
  const ClientData(
      {required this.id,
      this.code,
      required this.name,
      this.dobDay,
      required this.gender,
      this.phoneNumber1,
      this.phoneNumber2,
      this.address,
      this.regionId,
      this.category,
      this.discountCard,
      this.description,
      required this.isSynced,
      this.organizationName,
      this.syncedAt,
      required this.createdAt,
      required this.updatedAt,
      this.serverId,
      this.clientCurrency,
      this.typeId,
      this.cashbackId,
      this.cashback});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<int>(code);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || dobDay != null) {
      map['dob_day'] = Variable<DateTime>(dobDay);
    }
    map['gender'] = Variable<String>(gender);
    if (!nullToAbsent || phoneNumber1 != null) {
      map['phone_number1'] = Variable<String>(phoneNumber1);
    }
    if (!nullToAbsent || phoneNumber2 != null) {
      map['phone_number2'] = Variable<String>(phoneNumber2);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || regionId != null) {
      map['region_id'] = Variable<int>(regionId);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || discountCard != null) {
      map['discount_card'] = Variable<String>(discountCard);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || organizationName != null) {
      map['organization_name'] = Variable<String>(organizationName);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    if (!nullToAbsent || clientCurrency != null) {
      final converter = $ClientTable.$converterclientCurrencyn;
      map['client_currency'] =
          Variable<String>(converter.toSql(clientCurrency));
    }
    if (!nullToAbsent || typeId != null) {
      map['type_id'] = Variable<int>(typeId);
    }
    if (!nullToAbsent || cashbackId != null) {
      map['cashback_id'] = Variable<int>(cashbackId);
    }
    if (!nullToAbsent || cashback != null) {
      map['cashback'] = Variable<double>(cashback);
    }
    return map;
  }

  ClientCompanion toCompanion(bool nullToAbsent) {
    return ClientCompanion(
      id: Value(id),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      name: Value(name),
      dobDay:
          dobDay == null && nullToAbsent ? const Value.absent() : Value(dobDay),
      gender: Value(gender),
      phoneNumber1: phoneNumber1 == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber1),
      phoneNumber2: phoneNumber2 == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber2),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      regionId: regionId == null && nullToAbsent
          ? const Value.absent()
          : Value(regionId),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      discountCard: discountCard == null && nullToAbsent
          ? const Value.absent()
          : Value(discountCard),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isSynced: Value(isSynced),
      organizationName: organizationName == null && nullToAbsent
          ? const Value.absent()
          : Value(organizationName),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      clientCurrency: clientCurrency == null && nullToAbsent
          ? const Value.absent()
          : Value(clientCurrency),
      typeId:
          typeId == null && nullToAbsent ? const Value.absent() : Value(typeId),
      cashbackId: cashbackId == null && nullToAbsent
          ? const Value.absent()
          : Value(cashbackId),
      cashback: cashback == null && nullToAbsent
          ? const Value.absent()
          : Value(cashback),
    );
  }

  factory ClientData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClientData(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<int?>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      dobDay: serializer.fromJson<DateTime?>(json['dobDay']),
      gender: serializer.fromJson<String>(json['gender']),
      phoneNumber1: serializer.fromJson<String?>(json['phoneNumber1']),
      phoneNumber2: serializer.fromJson<String?>(json['phoneNumber2']),
      address: serializer.fromJson<String?>(json['address']),
      regionId: serializer.fromJson<int?>(json['regionId']),
      category: serializer.fromJson<String?>(json['category']),
      discountCard: serializer.fromJson<String?>(json['discountCard']),
      description: serializer.fromJson<String?>(json['description']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      organizationName: serializer.fromJson<String?>(json['organizationName']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      clientCurrency: $ClientTable.$converterclientCurrencyn
          .fromJson(serializer.fromJson<String?>(json['clientCurrency'])),
      typeId: serializer.fromJson<int?>(json['typeId']),
      cashbackId: serializer.fromJson<int?>(json['cashbackId']),
      cashback: serializer.fromJson<double?>(json['cashback']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<int?>(code),
      'name': serializer.toJson<String>(name),
      'dobDay': serializer.toJson<DateTime?>(dobDay),
      'gender': serializer.toJson<String>(gender),
      'phoneNumber1': serializer.toJson<String?>(phoneNumber1),
      'phoneNumber2': serializer.toJson<String?>(phoneNumber2),
      'address': serializer.toJson<String?>(address),
      'regionId': serializer.toJson<int?>(regionId),
      'category': serializer.toJson<String?>(category),
      'discountCard': serializer.toJson<String?>(discountCard),
      'description': serializer.toJson<String?>(description),
      'isSynced': serializer.toJson<bool>(isSynced),
      'organizationName': serializer.toJson<String?>(organizationName),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverId': serializer.toJson<int?>(serverId),
      'clientCurrency': serializer.toJson<String?>(
          $ClientTable.$converterclientCurrencyn.toJson(clientCurrency)),
      'typeId': serializer.toJson<int?>(typeId),
      'cashbackId': serializer.toJson<int?>(cashbackId),
      'cashback': serializer.toJson<double?>(cashback),
    };
  }

  ClientData copyWith(
          {int? id,
          Value<int?> code = const Value.absent(),
          String? name,
          Value<DateTime?> dobDay = const Value.absent(),
          String? gender,
          Value<String?> phoneNumber1 = const Value.absent(),
          Value<String?> phoneNumber2 = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<int?> regionId = const Value.absent(),
          Value<String?> category = const Value.absent(),
          Value<String?> discountCard = const Value.absent(),
          Value<String?> description = const Value.absent(),
          bool? isSynced,
          Value<String?> organizationName = const Value.absent(),
          Value<DateTime?> syncedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<int?> serverId = const Value.absent(),
          Value<ClientCurrency?> clientCurrency = const Value.absent(),
          Value<int?> typeId = const Value.absent(),
          Value<int?> cashbackId = const Value.absent(),
          Value<double?> cashback = const Value.absent()}) =>
      ClientData(
        id: id ?? this.id,
        code: code.present ? code.value : this.code,
        name: name ?? this.name,
        dobDay: dobDay.present ? dobDay.value : this.dobDay,
        gender: gender ?? this.gender,
        phoneNumber1:
            phoneNumber1.present ? phoneNumber1.value : this.phoneNumber1,
        phoneNumber2:
            phoneNumber2.present ? phoneNumber2.value : this.phoneNumber2,
        address: address.present ? address.value : this.address,
        regionId: regionId.present ? regionId.value : this.regionId,
        category: category.present ? category.value : this.category,
        discountCard:
            discountCard.present ? discountCard.value : this.discountCard,
        description: description.present ? description.value : this.description,
        isSynced: isSynced ?? this.isSynced,
        organizationName: organizationName.present
            ? organizationName.value
            : this.organizationName,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        serverId: serverId.present ? serverId.value : this.serverId,
        clientCurrency:
            clientCurrency.present ? clientCurrency.value : this.clientCurrency,
        typeId: typeId.present ? typeId.value : this.typeId,
        cashbackId: cashbackId.present ? cashbackId.value : this.cashbackId,
        cashback: cashback.present ? cashback.value : this.cashback,
      );
  @override
  String toString() {
    return (StringBuffer('ClientData(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('dobDay: $dobDay, ')
          ..write('gender: $gender, ')
          ..write('phoneNumber1: $phoneNumber1, ')
          ..write('phoneNumber2: $phoneNumber2, ')
          ..write('address: $address, ')
          ..write('regionId: $regionId, ')
          ..write('category: $category, ')
          ..write('discountCard: $discountCard, ')
          ..write('description: $description, ')
          ..write('isSynced: $isSynced, ')
          ..write('organizationName: $organizationName, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverId: $serverId, ')
          ..write('clientCurrency: $clientCurrency, ')
          ..write('typeId: $typeId, ')
          ..write('cashbackId: $cashbackId, ')
          ..write('cashback: $cashback')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        code,
        name,
        dobDay,
        gender,
        phoneNumber1,
        phoneNumber2,
        address,
        regionId,
        category,
        discountCard,
        description,
        isSynced,
        organizationName,
        syncedAt,
        createdAt,
        updatedAt,
        serverId,
        clientCurrency,
        typeId,
        cashbackId,
        cashback
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClientData &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.dobDay == this.dobDay &&
          other.gender == this.gender &&
          other.phoneNumber1 == this.phoneNumber1 &&
          other.phoneNumber2 == this.phoneNumber2 &&
          other.address == this.address &&
          other.regionId == this.regionId &&
          other.category == this.category &&
          other.discountCard == this.discountCard &&
          other.description == this.description &&
          other.isSynced == this.isSynced &&
          other.organizationName == this.organizationName &&
          other.syncedAt == this.syncedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverId == this.serverId &&
          other.clientCurrency == this.clientCurrency &&
          other.typeId == this.typeId &&
          other.cashbackId == this.cashbackId &&
          other.cashback == this.cashback);
}

class ClientCompanion extends UpdateCompanion<ClientData> {
  final Value<int> id;
  final Value<int?> code;
  final Value<String> name;
  final Value<DateTime?> dobDay;
  final Value<String> gender;
  final Value<String?> phoneNumber1;
  final Value<String?> phoneNumber2;
  final Value<String?> address;
  final Value<int?> regionId;
  final Value<String?> category;
  final Value<String?> discountCard;
  final Value<String?> description;
  final Value<bool> isSynced;
  final Value<String?> organizationName;
  final Value<DateTime?> syncedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int?> serverId;
  final Value<ClientCurrency?> clientCurrency;
  final Value<int?> typeId;
  final Value<int?> cashbackId;
  final Value<double?> cashback;
  const ClientCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.dobDay = const Value.absent(),
    this.gender = const Value.absent(),
    this.phoneNumber1 = const Value.absent(),
    this.phoneNumber2 = const Value.absent(),
    this.address = const Value.absent(),
    this.regionId = const Value.absent(),
    this.category = const Value.absent(),
    this.discountCard = const Value.absent(),
    this.description = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.organizationName = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverId = const Value.absent(),
    this.clientCurrency = const Value.absent(),
    this.typeId = const Value.absent(),
    this.cashbackId = const Value.absent(),
    this.cashback = const Value.absent(),
  });
  ClientCompanion.insert({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    required String name,
    this.dobDay = const Value.absent(),
    required String gender,
    this.phoneNumber1 = const Value.absent(),
    this.phoneNumber2 = const Value.absent(),
    this.address = const Value.absent(),
    this.regionId = const Value.absent(),
    this.category = const Value.absent(),
    this.discountCard = const Value.absent(),
    this.description = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.organizationName = const Value.absent(),
    this.syncedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverId = const Value.absent(),
    this.clientCurrency = const Value.absent(),
    this.typeId = const Value.absent(),
    this.cashbackId = const Value.absent(),
    this.cashback = const Value.absent(),
  })  : name = Value(name),
        gender = Value(gender),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ClientData> custom({
    Expression<int>? id,
    Expression<int>? code,
    Expression<String>? name,
    Expression<DateTime>? dobDay,
    Expression<String>? gender,
    Expression<String>? phoneNumber1,
    Expression<String>? phoneNumber2,
    Expression<String>? address,
    Expression<int>? regionId,
    Expression<String>? category,
    Expression<String>? discountCard,
    Expression<String>? description,
    Expression<bool>? isSynced,
    Expression<String>? organizationName,
    Expression<DateTime>? syncedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverId,
    Expression<String>? clientCurrency,
    Expression<int>? typeId,
    Expression<int>? cashbackId,
    Expression<double>? cashback,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (dobDay != null) 'dob_day': dobDay,
      if (gender != null) 'gender': gender,
      if (phoneNumber1 != null) 'phone_number1': phoneNumber1,
      if (phoneNumber2 != null) 'phone_number2': phoneNumber2,
      if (address != null) 'address': address,
      if (regionId != null) 'region_id': regionId,
      if (category != null) 'category': category,
      if (discountCard != null) 'discount_card': discountCard,
      if (description != null) 'description': description,
      if (isSynced != null) 'is_synced': isSynced,
      if (organizationName != null) 'organization_name': organizationName,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverId != null) 'server_id': serverId,
      if (clientCurrency != null) 'client_currency': clientCurrency,
      if (typeId != null) 'type_id': typeId,
      if (cashbackId != null) 'cashback_id': cashbackId,
      if (cashback != null) 'cashback': cashback,
    });
  }

  ClientCompanion copyWith(
      {Value<int>? id,
      Value<int?>? code,
      Value<String>? name,
      Value<DateTime?>? dobDay,
      Value<String>? gender,
      Value<String?>? phoneNumber1,
      Value<String?>? phoneNumber2,
      Value<String?>? address,
      Value<int?>? regionId,
      Value<String?>? category,
      Value<String?>? discountCard,
      Value<String?>? description,
      Value<bool>? isSynced,
      Value<String?>? organizationName,
      Value<DateTime?>? syncedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int?>? serverId,
      Value<ClientCurrency?>? clientCurrency,
      Value<int?>? typeId,
      Value<int?>? cashbackId,
      Value<double?>? cashback}) {
    return ClientCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      dobDay: dobDay ?? this.dobDay,
      gender: gender ?? this.gender,
      phoneNumber1: phoneNumber1 ?? this.phoneNumber1,
      phoneNumber2: phoneNumber2 ?? this.phoneNumber2,
      address: address ?? this.address,
      regionId: regionId ?? this.regionId,
      category: category ?? this.category,
      discountCard: discountCard ?? this.discountCard,
      description: description ?? this.description,
      isSynced: isSynced ?? this.isSynced,
      organizationName: organizationName ?? this.organizationName,
      syncedAt: syncedAt ?? this.syncedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverId: serverId ?? this.serverId,
      clientCurrency: clientCurrency ?? this.clientCurrency,
      typeId: typeId ?? this.typeId,
      cashbackId: cashbackId ?? this.cashbackId,
      cashback: cashback ?? this.cashback,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<int>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dobDay.present) {
      map['dob_day'] = Variable<DateTime>(dobDay.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (phoneNumber1.present) {
      map['phone_number1'] = Variable<String>(phoneNumber1.value);
    }
    if (phoneNumber2.present) {
      map['phone_number2'] = Variable<String>(phoneNumber2.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (regionId.present) {
      map['region_id'] = Variable<int>(regionId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (discountCard.present) {
      map['discount_card'] = Variable<String>(discountCard.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (organizationName.present) {
      map['organization_name'] = Variable<String>(organizationName.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (clientCurrency.present) {
      final converter = $ClientTable.$converterclientCurrencyn;

      map['client_currency'] =
          Variable<String>(converter.toSql(clientCurrency.value));
    }
    if (typeId.present) {
      map['type_id'] = Variable<int>(typeId.value);
    }
    if (cashbackId.present) {
      map['cashback_id'] = Variable<int>(cashbackId.value);
    }
    if (cashback.present) {
      map['cashback'] = Variable<double>(cashback.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('dobDay: $dobDay, ')
          ..write('gender: $gender, ')
          ..write('phoneNumber1: $phoneNumber1, ')
          ..write('phoneNumber2: $phoneNumber2, ')
          ..write('address: $address, ')
          ..write('regionId: $regionId, ')
          ..write('category: $category, ')
          ..write('discountCard: $discountCard, ')
          ..write('description: $description, ')
          ..write('isSynced: $isSynced, ')
          ..write('organizationName: $organizationName, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverId: $serverId, ')
          ..write('clientCurrency: $clientCurrency, ')
          ..write('typeId: $typeId, ')
          ..write('cashbackId: $cashbackId, ')
          ..write('cashback: $cashback')
          ..write(')'))
        .toString();
  }
}

class $CategoryTable extends Category
    with TableInfo<$CategoryTable, CategoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _groupCodeMeta =
      const VerificationMeta('groupCode');
  @override
  late final GeneratedColumn<String> groupCode = GeneratedColumn<String>(
      'group_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES category (id)'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isSyncedAtMeta =
      const VerificationMeta('isSyncedAt');
  @override
  late final GeneratedColumn<DateTime> isSyncedAt = GeneratedColumn<DateTime>(
      'is_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
      'server_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        code,
        groupCode,
        description,
        parentId,
        createdAt,
        updatedAt,
        isSynced,
        isSyncedAt,
        serverId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category';
  @override
  VerificationContext validateIntegrity(Insertable<CategoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    }
    if (data.containsKey('group_code')) {
      context.handle(_groupCodeMeta,
          groupCode.isAcceptableOrUnknown(data['group_code']!, _groupCodeMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('is_synced_at')) {
      context.handle(
          _isSyncedAtMeta,
          isSyncedAt.isAcceptableOrUnknown(
              data['is_synced_at']!, _isSyncedAtMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code']),
      groupCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group_code']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parent_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      isSyncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}is_synced_at']),
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_id']),
    );
  }

  @override
  $CategoryTable createAlias(String alias) {
    return $CategoryTable(attachedDatabase, alias);
  }
}

class CategoryData extends DataClass implements Insertable<CategoryData> {
  final int id;
  final String name;
  final String? code;
  final String? groupCode;
  final String? description;
  final int? parentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  final DateTime? isSyncedAt;
  final int? serverId;
  const CategoryData(
      {required this.id,
      required this.name,
      this.code,
      this.groupCode,
      this.description,
      this.parentId,
      required this.createdAt,
      required this.updatedAt,
      required this.isSynced,
      this.isSyncedAt,
      this.serverId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    if (!nullToAbsent || groupCode != null) {
      map['group_code'] = Variable<String>(groupCode);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || isSyncedAt != null) {
      map['is_synced_at'] = Variable<DateTime>(isSyncedAt);
    }
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    return map;
  }

  CategoryCompanion toCompanion(bool nullToAbsent) {
    return CategoryCompanion(
      id: Value(id),
      name: Value(name),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      groupCode: groupCode == null && nullToAbsent
          ? const Value.absent()
          : Value(groupCode),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      isSyncedAt: isSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(isSyncedAt),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
    );
  }

  factory CategoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String?>(json['code']),
      groupCode: serializer.fromJson<String?>(json['groupCode']),
      description: serializer.fromJson<String?>(json['description']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      isSyncedAt: serializer.fromJson<DateTime?>(json['isSyncedAt']),
      serverId: serializer.fromJson<int?>(json['serverId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String?>(code),
      'groupCode': serializer.toJson<String?>(groupCode),
      'description': serializer.toJson<String?>(description),
      'parentId': serializer.toJson<int?>(parentId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'isSyncedAt': serializer.toJson<DateTime?>(isSyncedAt),
      'serverId': serializer.toJson<int?>(serverId),
    };
  }

  CategoryData copyWith(
          {int? id,
          String? name,
          Value<String?> code = const Value.absent(),
          Value<String?> groupCode = const Value.absent(),
          Value<String?> description = const Value.absent(),
          Value<int?> parentId = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? isSynced,
          Value<DateTime?> isSyncedAt = const Value.absent(),
          Value<int?> serverId = const Value.absent()}) =>
      CategoryData(
        id: id ?? this.id,
        name: name ?? this.name,
        code: code.present ? code.value : this.code,
        groupCode: groupCode.present ? groupCode.value : this.groupCode,
        description: description.present ? description.value : this.description,
        parentId: parentId.present ? parentId.value : this.parentId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isSynced: isSynced ?? this.isSynced,
        isSyncedAt: isSyncedAt.present ? isSyncedAt.value : this.isSyncedAt,
        serverId: serverId.present ? serverId.value : this.serverId,
      );
  @override
  String toString() {
    return (StringBuffer('CategoryData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('groupCode: $groupCode, ')
          ..write('description: $description, ')
          ..write('parentId: $parentId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isSyncedAt: $isSyncedAt, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, code, groupCode, description,
      parentId, createdAt, updatedAt, isSynced, isSyncedAt, serverId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryData &&
          other.id == this.id &&
          other.name == this.name &&
          other.code == this.code &&
          other.groupCode == this.groupCode &&
          other.description == this.description &&
          other.parentId == this.parentId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.isSyncedAt == this.isSyncedAt &&
          other.serverId == this.serverId);
}

class CategoryCompanion extends UpdateCompanion<CategoryData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> code;
  final Value<String?> groupCode;
  final Value<String?> description;
  final Value<int?> parentId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<DateTime?> isSyncedAt;
  final Value<int?> serverId;
  const CategoryCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.groupCode = const Value.absent(),
    this.description = const Value.absent(),
    this.parentId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isSyncedAt = const Value.absent(),
    this.serverId = const Value.absent(),
  });
  CategoryCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.code = const Value.absent(),
    this.groupCode = const Value.absent(),
    this.description = const Value.absent(),
    this.parentId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isSynced = const Value.absent(),
    this.isSyncedAt = const Value.absent(),
    this.serverId = const Value.absent(),
  })  : name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<CategoryData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? code,
    Expression<String>? groupCode,
    Expression<String>? description,
    Expression<int>? parentId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<DateTime>? isSyncedAt,
    Expression<int>? serverId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (groupCode != null) 'group_code': groupCode,
      if (description != null) 'description': description,
      if (parentId != null) 'parent_id': parentId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (isSyncedAt != null) 'is_synced_at': isSyncedAt,
      if (serverId != null) 'server_id': serverId,
    });
  }

  CategoryCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? code,
      Value<String?>? groupCode,
      Value<String?>? description,
      Value<int?>? parentId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? isSynced,
      Value<DateTime?>? isSyncedAt,
      Value<int?>? serverId}) {
    return CategoryCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      groupCode: groupCode ?? this.groupCode,
      description: description ?? this.description,
      parentId: parentId ?? this.parentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      isSyncedAt: isSyncedAt ?? this.isSyncedAt,
      serverId: serverId ?? this.serverId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (groupCode.present) {
      map['group_code'] = Variable<String>(groupCode.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (isSyncedAt.present) {
      map['is_synced_at'] = Variable<DateTime>(isSyncedAt.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('groupCode: $groupCode, ')
          ..write('description: $description, ')
          ..write('parentId: $parentId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isSyncedAt: $isSyncedAt, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }
}

class $ProductTable extends Product with TableInfo<$ProductTable, ProductData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueAddedTaxMeta =
      const VerificationMeta('valueAddedTax');
  @override
  late final GeneratedColumn<double> valueAddedTax = GeneratedColumn<double>(
      'value_added_tax', aliasedName, true,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _vendorCodeMeta =
      const VerificationMeta('vendorCode');
  @override
  late final GeneratedColumn<String> vendorCode = GeneratedColumn<String>(
      'vendor_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isKitMeta = const VerificationMeta('isKit');
  @override
  late final GeneratedColumn<bool> isKit = GeneratedColumn<bool>(
      'is_kit', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_kit" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _productsInBoxMeta =
      const VerificationMeta('productsInBox');
  @override
  late final GeneratedColumn<String> productsInBox = GeneratedColumn<String>(
      'products_in_box', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _volumeMeta = const VerificationMeta('volume');
  @override
  late final GeneratedColumn<String> volume = GeneratedColumn<String>(
      'volume', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<String> weight = GeneratedColumn<String>(
      'weight', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES category (id)'));
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
      'server_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        valueAddedTax,
        barcode,
        code,
        vendorCode,
        description,
        isKit,
        productsInBox,
        unit,
        volume,
        weight,
        categoryId,
        isSynced,
        syncedAt,
        createdAt,
        updatedAt,
        serverId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product';
  @override
  VerificationContext validateIntegrity(Insertable<ProductData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('value_added_tax')) {
      context.handle(
          _valueAddedTaxMeta,
          valueAddedTax.isAcceptableOrUnknown(
              data['value_added_tax']!, _valueAddedTaxMeta));
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    }
    if (data.containsKey('vendor_code')) {
      context.handle(
          _vendorCodeMeta,
          vendorCode.isAcceptableOrUnknown(
              data['vendor_code']!, _vendorCodeMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('is_kit')) {
      context.handle(
          _isKitMeta, isKit.isAcceptableOrUnknown(data['is_kit']!, _isKitMeta));
    }
    if (data.containsKey('products_in_box')) {
      context.handle(
          _productsInBoxMeta,
          productsInBox.isAcceptableOrUnknown(
              data['products_in_box']!, _productsInBoxMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('volume')) {
      context.handle(_volumeMeta,
          volume.isAcceptableOrUnknown(data['volume']!, _volumeMeta));
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      valueAddedTax: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value_added_tax']),
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode']),
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code']),
      vendorCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vendor_code']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      isKit: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_kit'])!,
      productsInBox: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}products_in_box']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      volume: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}volume']),
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}weight']),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_id']),
    );
  }

  @override
  $ProductTable createAlias(String alias) {
    return $ProductTable(attachedDatabase, alias);
  }
}

class ProductData extends DataClass implements Insertable<ProductData> {
  final int id;
  final String name;
  final double? valueAddedTax;
  final String? barcode;
  final String? code;
  final String? vendorCode;
  final String? description;
  final bool isKit;
  final String? productsInBox;
  final String unit;
  final String? volume;
  final String? weight;
  final int? categoryId;
  final bool isSynced;
  final DateTime? syncedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? serverId;
  const ProductData(
      {required this.id,
      required this.name,
      this.valueAddedTax,
      this.barcode,
      this.code,
      this.vendorCode,
      this.description,
      required this.isKit,
      this.productsInBox,
      required this.unit,
      this.volume,
      this.weight,
      this.categoryId,
      required this.isSynced,
      this.syncedAt,
      required this.createdAt,
      required this.updatedAt,
      this.serverId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || valueAddedTax != null) {
      map['value_added_tax'] = Variable<double>(valueAddedTax);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    if (!nullToAbsent || vendorCode != null) {
      map['vendor_code'] = Variable<String>(vendorCode);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_kit'] = Variable<bool>(isKit);
    if (!nullToAbsent || productsInBox != null) {
      map['products_in_box'] = Variable<String>(productsInBox);
    }
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || volume != null) {
      map['volume'] = Variable<String>(volume);
    }
    if (!nullToAbsent || weight != null) {
      map['weight'] = Variable<String>(weight);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    return map;
  }

  ProductCompanion toCompanion(bool nullToAbsent) {
    return ProductCompanion(
      id: Value(id),
      name: Value(name),
      valueAddedTax: valueAddedTax == null && nullToAbsent
          ? const Value.absent()
          : Value(valueAddedTax),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      vendorCode: vendorCode == null && nullToAbsent
          ? const Value.absent()
          : Value(vendorCode),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isKit: Value(isKit),
      productsInBox: productsInBox == null && nullToAbsent
          ? const Value.absent()
          : Value(productsInBox),
      unit: Value(unit),
      volume:
          volume == null && nullToAbsent ? const Value.absent() : Value(volume),
      weight:
          weight == null && nullToAbsent ? const Value.absent() : Value(weight),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      isSynced: Value(isSynced),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
    );
  }

  factory ProductData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      valueAddedTax: serializer.fromJson<double?>(json['valueAddedTax']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      code: serializer.fromJson<String?>(json['code']),
      vendorCode: serializer.fromJson<String?>(json['vendorCode']),
      description: serializer.fromJson<String?>(json['description']),
      isKit: serializer.fromJson<bool>(json['isKit']),
      productsInBox: serializer.fromJson<String?>(json['productsInBox']),
      unit: serializer.fromJson<String>(json['unit']),
      volume: serializer.fromJson<String?>(json['volume']),
      weight: serializer.fromJson<String?>(json['weight']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverId: serializer.fromJson<int?>(json['serverId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'valueAddedTax': serializer.toJson<double?>(valueAddedTax),
      'barcode': serializer.toJson<String?>(barcode),
      'code': serializer.toJson<String?>(code),
      'vendorCode': serializer.toJson<String?>(vendorCode),
      'description': serializer.toJson<String?>(description),
      'isKit': serializer.toJson<bool>(isKit),
      'productsInBox': serializer.toJson<String?>(productsInBox),
      'unit': serializer.toJson<String>(unit),
      'volume': serializer.toJson<String?>(volume),
      'weight': serializer.toJson<String?>(weight),
      'categoryId': serializer.toJson<int?>(categoryId),
      'isSynced': serializer.toJson<bool>(isSynced),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverId': serializer.toJson<int?>(serverId),
    };
  }

  ProductData copyWith(
          {int? id,
          String? name,
          Value<double?> valueAddedTax = const Value.absent(),
          Value<String?> barcode = const Value.absent(),
          Value<String?> code = const Value.absent(),
          Value<String?> vendorCode = const Value.absent(),
          Value<String?> description = const Value.absent(),
          bool? isKit,
          Value<String?> productsInBox = const Value.absent(),
          String? unit,
          Value<String?> volume = const Value.absent(),
          Value<String?> weight = const Value.absent(),
          Value<int?> categoryId = const Value.absent(),
          bool? isSynced,
          Value<DateTime?> syncedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<int?> serverId = const Value.absent()}) =>
      ProductData(
        id: id ?? this.id,
        name: name ?? this.name,
        valueAddedTax:
            valueAddedTax.present ? valueAddedTax.value : this.valueAddedTax,
        barcode: barcode.present ? barcode.value : this.barcode,
        code: code.present ? code.value : this.code,
        vendorCode: vendorCode.present ? vendorCode.value : this.vendorCode,
        description: description.present ? description.value : this.description,
        isKit: isKit ?? this.isKit,
        productsInBox:
            productsInBox.present ? productsInBox.value : this.productsInBox,
        unit: unit ?? this.unit,
        volume: volume.present ? volume.value : this.volume,
        weight: weight.present ? weight.value : this.weight,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        isSynced: isSynced ?? this.isSynced,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        serverId: serverId.present ? serverId.value : this.serverId,
      );
  @override
  String toString() {
    return (StringBuffer('ProductData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('valueAddedTax: $valueAddedTax, ')
          ..write('barcode: $barcode, ')
          ..write('code: $code, ')
          ..write('vendorCode: $vendorCode, ')
          ..write('description: $description, ')
          ..write('isKit: $isKit, ')
          ..write('productsInBox: $productsInBox, ')
          ..write('unit: $unit, ')
          ..write('volume: $volume, ')
          ..write('weight: $weight, ')
          ..write('categoryId: $categoryId, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      valueAddedTax,
      barcode,
      code,
      vendorCode,
      description,
      isKit,
      productsInBox,
      unit,
      volume,
      weight,
      categoryId,
      isSynced,
      syncedAt,
      createdAt,
      updatedAt,
      serverId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductData &&
          other.id == this.id &&
          other.name == this.name &&
          other.valueAddedTax == this.valueAddedTax &&
          other.barcode == this.barcode &&
          other.code == this.code &&
          other.vendorCode == this.vendorCode &&
          other.description == this.description &&
          other.isKit == this.isKit &&
          other.productsInBox == this.productsInBox &&
          other.unit == this.unit &&
          other.volume == this.volume &&
          other.weight == this.weight &&
          other.categoryId == this.categoryId &&
          other.isSynced == this.isSynced &&
          other.syncedAt == this.syncedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverId == this.serverId);
}

class ProductCompanion extends UpdateCompanion<ProductData> {
  final Value<int> id;
  final Value<String> name;
  final Value<double?> valueAddedTax;
  final Value<String?> barcode;
  final Value<String?> code;
  final Value<String?> vendorCode;
  final Value<String?> description;
  final Value<bool> isKit;
  final Value<String?> productsInBox;
  final Value<String> unit;
  final Value<String?> volume;
  final Value<String?> weight;
  final Value<int?> categoryId;
  final Value<bool> isSynced;
  final Value<DateTime?> syncedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int?> serverId;
  const ProductCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.valueAddedTax = const Value.absent(),
    this.barcode = const Value.absent(),
    this.code = const Value.absent(),
    this.vendorCode = const Value.absent(),
    this.description = const Value.absent(),
    this.isKit = const Value.absent(),
    this.productsInBox = const Value.absent(),
    this.unit = const Value.absent(),
    this.volume = const Value.absent(),
    this.weight = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverId = const Value.absent(),
  });
  ProductCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.valueAddedTax = const Value.absent(),
    this.barcode = const Value.absent(),
    this.code = const Value.absent(),
    this.vendorCode = const Value.absent(),
    this.description = const Value.absent(),
    this.isKit = const Value.absent(),
    this.productsInBox = const Value.absent(),
    required String unit,
    this.volume = const Value.absent(),
    this.weight = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverId = const Value.absent(),
  })  : name = Value(name),
        unit = Value(unit),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ProductData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? valueAddedTax,
    Expression<String>? barcode,
    Expression<String>? code,
    Expression<String>? vendorCode,
    Expression<String>? description,
    Expression<bool>? isKit,
    Expression<String>? productsInBox,
    Expression<String>? unit,
    Expression<String>? volume,
    Expression<String>? weight,
    Expression<int>? categoryId,
    Expression<bool>? isSynced,
    Expression<DateTime>? syncedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (valueAddedTax != null) 'value_added_tax': valueAddedTax,
      if (barcode != null) 'barcode': barcode,
      if (code != null) 'code': code,
      if (vendorCode != null) 'vendor_code': vendorCode,
      if (description != null) 'description': description,
      if (isKit != null) 'is_kit': isKit,
      if (productsInBox != null) 'products_in_box': productsInBox,
      if (unit != null) 'unit': unit,
      if (volume != null) 'volume': volume,
      if (weight != null) 'weight': weight,
      if (categoryId != null) 'category_id': categoryId,
      if (isSynced != null) 'is_synced': isSynced,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverId != null) 'server_id': serverId,
    });
  }

  ProductCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<double?>? valueAddedTax,
      Value<String?>? barcode,
      Value<String?>? code,
      Value<String?>? vendorCode,
      Value<String?>? description,
      Value<bool>? isKit,
      Value<String?>? productsInBox,
      Value<String>? unit,
      Value<String?>? volume,
      Value<String?>? weight,
      Value<int?>? categoryId,
      Value<bool>? isSynced,
      Value<DateTime?>? syncedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int?>? serverId}) {
    return ProductCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      valueAddedTax: valueAddedTax ?? this.valueAddedTax,
      barcode: barcode ?? this.barcode,
      code: code ?? this.code,
      vendorCode: vendorCode ?? this.vendorCode,
      description: description ?? this.description,
      isKit: isKit ?? this.isKit,
      productsInBox: productsInBox ?? this.productsInBox,
      unit: unit ?? this.unit,
      volume: volume ?? this.volume,
      weight: weight ?? this.weight,
      categoryId: categoryId ?? this.categoryId,
      isSynced: isSynced ?? this.isSynced,
      syncedAt: syncedAt ?? this.syncedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverId: serverId ?? this.serverId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (valueAddedTax.present) {
      map['value_added_tax'] = Variable<double>(valueAddedTax.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (vendorCode.present) {
      map['vendor_code'] = Variable<String>(vendorCode.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isKit.present) {
      map['is_kit'] = Variable<bool>(isKit.value);
    }
    if (productsInBox.present) {
      map['products_in_box'] = Variable<String>(productsInBox.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (volume.present) {
      map['volume'] = Variable<String>(volume.value);
    }
    if (weight.present) {
      map['weight'] = Variable<String>(weight.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('valueAddedTax: $valueAddedTax, ')
          ..write('barcode: $barcode, ')
          ..write('code: $code, ')
          ..write('vendorCode: $vendorCode, ')
          ..write('description: $description, ')
          ..write('isKit: $isKit, ')
          ..write('productsInBox: $productsInBox, ')
          ..write('unit: $unit, ')
          ..write('volume: $volume, ')
          ..write('weight: $weight, ')
          ..write('categoryId: $categoryId, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }
}

class $ProductIncomeTable extends ProductIncome
    with TableInfo<$ProductIncomeTable, ProductIncomeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductIncomeTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES product (id)'));
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumnWithTypeConverter<ProductIncomeCurrency?, String>
      currency = GeneratedColumn<String>('currency', aliasedName, true,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(ProductIncomeCurrency.UZS.name.toString()))
          .withConverter<ProductIncomeCurrency?>(
              $ProductIncomeTable.$convertercurrencyn);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _expireDateMeta =
      const VerificationMeta('expireDate');
  @override
  late final GeneratedColumn<DateTime> expireDate = GeneratedColumn<DateTime>(
      'expire_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
      'server_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        isSynced,
        syncedAt,
        createdAt,
        updatedAt,
        productId,
        currency,
        price,
        amount,
        description,
        expireDate,
        deleted,
        serverId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_income';
  @override
  VerificationContext validateIntegrity(Insertable<ProductIncomeData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    context.handle(_currencyMeta, const VerificationResult.success());
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('expire_date')) {
      context.handle(
          _expireDateMeta,
          expireDate.isAcceptableOrUnknown(
              data['expire_date']!, _expireDateMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductIncomeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductIncomeData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      currency: $ProductIncomeTable.$convertercurrencyn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])),
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      expireDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expire_date']),
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_id']),
    );
  }

  @override
  $ProductIncomeTable createAlias(String alias) {
    return $ProductIncomeTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ProductIncomeCurrency, String, String>
      $convertercurrency = const EnumNameConverter<ProductIncomeCurrency>(
          ProductIncomeCurrency.values);
  static JsonTypeConverter2<ProductIncomeCurrency?, String?, String?>
      $convertercurrencyn = JsonTypeConverter2.asNullable($convertercurrency);
}

class ProductIncomeData extends DataClass
    implements Insertable<ProductIncomeData> {
  final int id;
  final bool isSynced;
  final DateTime? syncedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int productId;
  final ProductIncomeCurrency? currency;
  final double price;
  final double amount;
  final String? description;
  final DateTime? expireDate;
  final bool deleted;
  final int? serverId;
  const ProductIncomeData(
      {required this.id,
      required this.isSynced,
      this.syncedAt,
      required this.createdAt,
      required this.updatedAt,
      required this.productId,
      this.currency,
      required this.price,
      required this.amount,
      this.description,
      this.expireDate,
      required this.deleted,
      this.serverId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['product_id'] = Variable<int>(productId);
    if (!nullToAbsent || currency != null) {
      final converter = $ProductIncomeTable.$convertercurrencyn;
      map['currency'] = Variable<String>(converter.toSql(currency));
    }
    map['price'] = Variable<double>(price);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || expireDate != null) {
      map['expire_date'] = Variable<DateTime>(expireDate);
    }
    map['deleted'] = Variable<bool>(deleted);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    return map;
  }

  ProductIncomeCompanion toCompanion(bool nullToAbsent) {
    return ProductIncomeCompanion(
      id: Value(id),
      isSynced: Value(isSynced),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      productId: Value(productId),
      currency: currency == null && nullToAbsent
          ? const Value.absent()
          : Value(currency),
      price: Value(price),
      amount: Value(amount),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      expireDate: expireDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expireDate),
      deleted: Value(deleted),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
    );
  }

  factory ProductIncomeData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductIncomeData(
      id: serializer.fromJson<int>(json['id']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      productId: serializer.fromJson<int>(json['productId']),
      currency: $ProductIncomeTable.$convertercurrencyn
          .fromJson(serializer.fromJson<String?>(json['currency'])),
      price: serializer.fromJson<double>(json['price']),
      amount: serializer.fromJson<double>(json['amount']),
      description: serializer.fromJson<String?>(json['description']),
      expireDate: serializer.fromJson<DateTime?>(json['expireDate']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      serverId: serializer.fromJson<int?>(json['serverId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'isSynced': serializer.toJson<bool>(isSynced),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'productId': serializer.toJson<int>(productId),
      'currency': serializer.toJson<String?>(
          $ProductIncomeTable.$convertercurrencyn.toJson(currency)),
      'price': serializer.toJson<double>(price),
      'amount': serializer.toJson<double>(amount),
      'description': serializer.toJson<String?>(description),
      'expireDate': serializer.toJson<DateTime?>(expireDate),
      'deleted': serializer.toJson<bool>(deleted),
      'serverId': serializer.toJson<int?>(serverId),
    };
  }

  ProductIncomeData copyWith(
          {int? id,
          bool? isSynced,
          Value<DateTime?> syncedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          int? productId,
          Value<ProductIncomeCurrency?> currency = const Value.absent(),
          double? price,
          double? amount,
          Value<String?> description = const Value.absent(),
          Value<DateTime?> expireDate = const Value.absent(),
          bool? deleted,
          Value<int?> serverId = const Value.absent()}) =>
      ProductIncomeData(
        id: id ?? this.id,
        isSynced: isSynced ?? this.isSynced,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        productId: productId ?? this.productId,
        currency: currency.present ? currency.value : this.currency,
        price: price ?? this.price,
        amount: amount ?? this.amount,
        description: description.present ? description.value : this.description,
        expireDate: expireDate.present ? expireDate.value : this.expireDate,
        deleted: deleted ?? this.deleted,
        serverId: serverId.present ? serverId.value : this.serverId,
      );
  @override
  String toString() {
    return (StringBuffer('ProductIncomeData(')
          ..write('id: $id, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('productId: $productId, ')
          ..write('currency: $currency, ')
          ..write('price: $price, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('expireDate: $expireDate, ')
          ..write('deleted: $deleted, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      isSynced,
      syncedAt,
      createdAt,
      updatedAt,
      productId,
      currency,
      price,
      amount,
      description,
      expireDate,
      deleted,
      serverId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductIncomeData &&
          other.id == this.id &&
          other.isSynced == this.isSynced &&
          other.syncedAt == this.syncedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.productId == this.productId &&
          other.currency == this.currency &&
          other.price == this.price &&
          other.amount == this.amount &&
          other.description == this.description &&
          other.expireDate == this.expireDate &&
          other.deleted == this.deleted &&
          other.serverId == this.serverId);
}

class ProductIncomeCompanion extends UpdateCompanion<ProductIncomeData> {
  final Value<int> id;
  final Value<bool> isSynced;
  final Value<DateTime?> syncedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> productId;
  final Value<ProductIncomeCurrency?> currency;
  final Value<double> price;
  final Value<double> amount;
  final Value<String?> description;
  final Value<DateTime?> expireDate;
  final Value<bool> deleted;
  final Value<int?> serverId;
  const ProductIncomeCompanion({
    this.id = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.productId = const Value.absent(),
    this.currency = const Value.absent(),
    this.price = const Value.absent(),
    this.amount = const Value.absent(),
    this.description = const Value.absent(),
    this.expireDate = const Value.absent(),
    this.deleted = const Value.absent(),
    this.serverId = const Value.absent(),
  });
  ProductIncomeCompanion.insert({
    this.id = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    required int productId,
    this.currency = const Value.absent(),
    this.price = const Value.absent(),
    this.amount = const Value.absent(),
    this.description = const Value.absent(),
    this.expireDate = const Value.absent(),
    this.deleted = const Value.absent(),
    this.serverId = const Value.absent(),
  })  : createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        productId = Value(productId);
  static Insertable<ProductIncomeData> custom({
    Expression<int>? id,
    Expression<bool>? isSynced,
    Expression<DateTime>? syncedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? productId,
    Expression<String>? currency,
    Expression<double>? price,
    Expression<double>? amount,
    Expression<String>? description,
    Expression<DateTime>? expireDate,
    Expression<bool>? deleted,
    Expression<int>? serverId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (isSynced != null) 'is_synced': isSynced,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (productId != null) 'product_id': productId,
      if (currency != null) 'currency': currency,
      if (price != null) 'price': price,
      if (amount != null) 'amount': amount,
      if (description != null) 'description': description,
      if (expireDate != null) 'expire_date': expireDate,
      if (deleted != null) 'deleted': deleted,
      if (serverId != null) 'server_id': serverId,
    });
  }

  ProductIncomeCompanion copyWith(
      {Value<int>? id,
      Value<bool>? isSynced,
      Value<DateTime?>? syncedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? productId,
      Value<ProductIncomeCurrency?>? currency,
      Value<double>? price,
      Value<double>? amount,
      Value<String?>? description,
      Value<DateTime?>? expireDate,
      Value<bool>? deleted,
      Value<int?>? serverId}) {
    return ProductIncomeCompanion(
      id: id ?? this.id,
      isSynced: isSynced ?? this.isSynced,
      syncedAt: syncedAt ?? this.syncedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      productId: productId ?? this.productId,
      currency: currency ?? this.currency,
      price: price ?? this.price,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      expireDate: expireDate ?? this.expireDate,
      deleted: deleted ?? this.deleted,
      serverId: serverId ?? this.serverId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (currency.present) {
      final converter = $ProductIncomeTable.$convertercurrencyn;

      map['currency'] = Variable<String>(converter.toSql(currency.value));
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (expireDate.present) {
      map['expire_date'] = Variable<DateTime>(expireDate.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductIncomeCompanion(')
          ..write('id: $id, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('productId: $productId, ')
          ..write('currency: $currency, ')
          ..write('price: $price, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('expireDate: $expireDate, ')
          ..write('deleted: $deleted, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }
}

class $CurrencyTableTable extends CurrencyTable
    with TableInfo<$CurrencyTableTable, CurrencyTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurrencyTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _abbreviationMeta =
      const VerificationMeta('abbreviation');
  @override
  late final GeneratedColumn<String> abbreviation = GeneratedColumn<String>(
      'abbreviation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _defaultCurrencyMeta =
      const VerificationMeta('defaultCurrency');
  @override
  late final GeneratedColumn<bool> defaultCurrency = GeneratedColumn<bool>(
      'default_currency', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("default_currency" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
      'server_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        abbreviation,
        symbol,
        defaultCurrency,
        createdAt,
        updatedAt,
        serverId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'currency_table';
  @override
  VerificationContext validateIntegrity(Insertable<CurrencyTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('abbreviation')) {
      context.handle(
          _abbreviationMeta,
          abbreviation.isAcceptableOrUnknown(
              data['abbreviation']!, _abbreviationMeta));
    } else if (isInserting) {
      context.missing(_abbreviationMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('default_currency')) {
      context.handle(
          _defaultCurrencyMeta,
          defaultCurrency.isAcceptableOrUnknown(
              data['default_currency']!, _defaultCurrencyMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CurrencyTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CurrencyTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      abbreviation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}abbreviation'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      defaultCurrency: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}default_currency'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_id']),
    );
  }

  @override
  $CurrencyTableTable createAlias(String alias) {
    return $CurrencyTableTable(attachedDatabase, alias);
  }
}

class CurrencyTableData extends DataClass
    implements Insertable<CurrencyTableData> {
  final int id;
  final String name;
  final String abbreviation;
  final String symbol;
  final bool defaultCurrency;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? serverId;
  const CurrencyTableData(
      {required this.id,
      required this.name,
      required this.abbreviation,
      required this.symbol,
      required this.defaultCurrency,
      required this.createdAt,
      required this.updatedAt,
      this.serverId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['abbreviation'] = Variable<String>(abbreviation);
    map['symbol'] = Variable<String>(symbol);
    map['default_currency'] = Variable<bool>(defaultCurrency);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    return map;
  }

  CurrencyTableCompanion toCompanion(bool nullToAbsent) {
    return CurrencyTableCompanion(
      id: Value(id),
      name: Value(name),
      abbreviation: Value(abbreviation),
      symbol: Value(symbol),
      defaultCurrency: Value(defaultCurrency),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
    );
  }

  factory CurrencyTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CurrencyTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      abbreviation: serializer.fromJson<String>(json['abbreviation']),
      symbol: serializer.fromJson<String>(json['symbol']),
      defaultCurrency: serializer.fromJson<bool>(json['defaultCurrency']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverId: serializer.fromJson<int?>(json['serverId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'abbreviation': serializer.toJson<String>(abbreviation),
      'symbol': serializer.toJson<String>(symbol),
      'defaultCurrency': serializer.toJson<bool>(defaultCurrency),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverId': serializer.toJson<int?>(serverId),
    };
  }

  CurrencyTableData copyWith(
          {int? id,
          String? name,
          String? abbreviation,
          String? symbol,
          bool? defaultCurrency,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<int?> serverId = const Value.absent()}) =>
      CurrencyTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        abbreviation: abbreviation ?? this.abbreviation,
        symbol: symbol ?? this.symbol,
        defaultCurrency: defaultCurrency ?? this.defaultCurrency,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        serverId: serverId.present ? serverId.value : this.serverId,
      );
  @override
  String toString() {
    return (StringBuffer('CurrencyTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('abbreviation: $abbreviation, ')
          ..write('symbol: $symbol, ')
          ..write('defaultCurrency: $defaultCurrency, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, abbreviation, symbol,
      defaultCurrency, createdAt, updatedAt, serverId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CurrencyTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.abbreviation == this.abbreviation &&
          other.symbol == this.symbol &&
          other.defaultCurrency == this.defaultCurrency &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverId == this.serverId);
}

class CurrencyTableCompanion extends UpdateCompanion<CurrencyTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> abbreviation;
  final Value<String> symbol;
  final Value<bool> defaultCurrency;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int?> serverId;
  const CurrencyTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.abbreviation = const Value.absent(),
    this.symbol = const Value.absent(),
    this.defaultCurrency = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverId = const Value.absent(),
  });
  CurrencyTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String abbreviation,
    required String symbol,
    this.defaultCurrency = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverId = const Value.absent(),
  })  : name = Value(name),
        abbreviation = Value(abbreviation),
        symbol = Value(symbol),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<CurrencyTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? abbreviation,
    Expression<String>? symbol,
    Expression<bool>? defaultCurrency,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (abbreviation != null) 'abbreviation': abbreviation,
      if (symbol != null) 'symbol': symbol,
      if (defaultCurrency != null) 'default_currency': defaultCurrency,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverId != null) 'server_id': serverId,
    });
  }

  CurrencyTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? abbreviation,
      Value<String>? symbol,
      Value<bool>? defaultCurrency,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int?>? serverId}) {
    return CurrencyTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      abbreviation: abbreviation ?? this.abbreviation,
      symbol: symbol ?? this.symbol,
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverId: serverId ?? this.serverId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (abbreviation.present) {
      map['abbreviation'] = Variable<String>(abbreviation.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (defaultCurrency.present) {
      map['default_currency'] = Variable<bool>(defaultCurrency.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrencyTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('abbreviation: $abbreviation, ')
          ..write('symbol: $symbol, ')
          ..write('defaultCurrency: $defaultCurrency, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }
}

class $PriceTable extends Price with TableInfo<$PriceTable, PriceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PriceTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _currencyIdMeta =
      const VerificationMeta('currencyId');
  @override
  late final GeneratedColumn<int> currencyId = GeneratedColumn<int>(
      'currency_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES currency_table (id)'));
  static const VerificationMeta _discountExpiredMeta =
      const VerificationMeta('discountExpired');
  @override
  late final GeneratedColumn<DateTime> discountExpired =
      GeneratedColumn<DateTime>('discount_expired', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _discountMeta =
      const VerificationMeta('discount');
  @override
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
      'discount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES product (id)'));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
      'server_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        currencyId,
        discountExpired,
        discount,
        value,
        isSynced,
        productId,
        syncedAt,
        createdAt,
        updatedAt,
        serverId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'price';
  @override
  VerificationContext validateIntegrity(Insertable<PriceData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('currency_id')) {
      context.handle(
          _currencyIdMeta,
          currencyId.isAcceptableOrUnknown(
              data['currency_id']!, _currencyIdMeta));
    } else if (isInserting) {
      context.missing(_currencyIdMeta);
    }
    if (data.containsKey('discount_expired')) {
      context.handle(
          _discountExpiredMeta,
          discountExpired.isAcceptableOrUnknown(
              data['discount_expired']!, _discountExpiredMeta));
    }
    if (data.containsKey('discount')) {
      context.handle(_discountMeta,
          discount.isAcceptableOrUnknown(data['discount']!, _discountMeta));
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PriceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PriceData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      currencyId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}currency_id'])!,
      discountExpired: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}discount_expired']),
      discount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}discount'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_id']),
    );
  }

  @override
  $PriceTable createAlias(String alias) {
    return $PriceTable(attachedDatabase, alias);
  }
}

class PriceData extends DataClass implements Insertable<PriceData> {
  final int id;
  final int currencyId;
  final DateTime? discountExpired;
  final double discount;
  final double value;
  final bool isSynced;
  final int productId;
  final DateTime? syncedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? serverId;
  const PriceData(
      {required this.id,
      required this.currencyId,
      this.discountExpired,
      required this.discount,
      required this.value,
      required this.isSynced,
      required this.productId,
      this.syncedAt,
      required this.createdAt,
      required this.updatedAt,
      this.serverId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['currency_id'] = Variable<int>(currencyId);
    if (!nullToAbsent || discountExpired != null) {
      map['discount_expired'] = Variable<DateTime>(discountExpired);
    }
    map['discount'] = Variable<double>(discount);
    map['value'] = Variable<double>(value);
    map['is_synced'] = Variable<bool>(isSynced);
    map['product_id'] = Variable<int>(productId);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    return map;
  }

  PriceCompanion toCompanion(bool nullToAbsent) {
    return PriceCompanion(
      id: Value(id),
      currencyId: Value(currencyId),
      discountExpired: discountExpired == null && nullToAbsent
          ? const Value.absent()
          : Value(discountExpired),
      discount: Value(discount),
      value: Value(value),
      isSynced: Value(isSynced),
      productId: Value(productId),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
    );
  }

  factory PriceData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PriceData(
      id: serializer.fromJson<int>(json['id']),
      currencyId: serializer.fromJson<int>(json['currencyId']),
      discountExpired: serializer.fromJson<DateTime?>(json['discountExpired']),
      discount: serializer.fromJson<double>(json['discount']),
      value: serializer.fromJson<double>(json['value']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      productId: serializer.fromJson<int>(json['productId']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverId: serializer.fromJson<int?>(json['serverId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currencyId': serializer.toJson<int>(currencyId),
      'discountExpired': serializer.toJson<DateTime?>(discountExpired),
      'discount': serializer.toJson<double>(discount),
      'value': serializer.toJson<double>(value),
      'isSynced': serializer.toJson<bool>(isSynced),
      'productId': serializer.toJson<int>(productId),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverId': serializer.toJson<int?>(serverId),
    };
  }

  PriceData copyWith(
          {int? id,
          int? currencyId,
          Value<DateTime?> discountExpired = const Value.absent(),
          double? discount,
          double? value,
          bool? isSynced,
          int? productId,
          Value<DateTime?> syncedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<int?> serverId = const Value.absent()}) =>
      PriceData(
        id: id ?? this.id,
        currencyId: currencyId ?? this.currencyId,
        discountExpired: discountExpired.present
            ? discountExpired.value
            : this.discountExpired,
        discount: discount ?? this.discount,
        value: value ?? this.value,
        isSynced: isSynced ?? this.isSynced,
        productId: productId ?? this.productId,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        serverId: serverId.present ? serverId.value : this.serverId,
      );
  @override
  String toString() {
    return (StringBuffer('PriceData(')
          ..write('id: $id, ')
          ..write('currencyId: $currencyId, ')
          ..write('discountExpired: $discountExpired, ')
          ..write('discount: $discount, ')
          ..write('value: $value, ')
          ..write('isSynced: $isSynced, ')
          ..write('productId: $productId, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, currencyId, discountExpired, discount,
      value, isSynced, productId, syncedAt, createdAt, updatedAt, serverId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PriceData &&
          other.id == this.id &&
          other.currencyId == this.currencyId &&
          other.discountExpired == this.discountExpired &&
          other.discount == this.discount &&
          other.value == this.value &&
          other.isSynced == this.isSynced &&
          other.productId == this.productId &&
          other.syncedAt == this.syncedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverId == this.serverId);
}

class PriceCompanion extends UpdateCompanion<PriceData> {
  final Value<int> id;
  final Value<int> currencyId;
  final Value<DateTime?> discountExpired;
  final Value<double> discount;
  final Value<double> value;
  final Value<bool> isSynced;
  final Value<int> productId;
  final Value<DateTime?> syncedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int?> serverId;
  const PriceCompanion({
    this.id = const Value.absent(),
    this.currencyId = const Value.absent(),
    this.discountExpired = const Value.absent(),
    this.discount = const Value.absent(),
    this.value = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.productId = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverId = const Value.absent(),
  });
  PriceCompanion.insert({
    this.id = const Value.absent(),
    required int currencyId,
    this.discountExpired = const Value.absent(),
    this.discount = const Value.absent(),
    this.value = const Value.absent(),
    this.isSynced = const Value.absent(),
    required int productId,
    this.syncedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverId = const Value.absent(),
  })  : currencyId = Value(currencyId),
        productId = Value(productId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<PriceData> custom({
    Expression<int>? id,
    Expression<int>? currencyId,
    Expression<DateTime>? discountExpired,
    Expression<double>? discount,
    Expression<double>? value,
    Expression<bool>? isSynced,
    Expression<int>? productId,
    Expression<DateTime>? syncedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currencyId != null) 'currency_id': currencyId,
      if (discountExpired != null) 'discount_expired': discountExpired,
      if (discount != null) 'discount': discount,
      if (value != null) 'value': value,
      if (isSynced != null) 'is_synced': isSynced,
      if (productId != null) 'product_id': productId,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverId != null) 'server_id': serverId,
    });
  }

  PriceCompanion copyWith(
      {Value<int>? id,
      Value<int>? currencyId,
      Value<DateTime?>? discountExpired,
      Value<double>? discount,
      Value<double>? value,
      Value<bool>? isSynced,
      Value<int>? productId,
      Value<DateTime?>? syncedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int?>? serverId}) {
    return PriceCompanion(
      id: id ?? this.id,
      currencyId: currencyId ?? this.currencyId,
      discountExpired: discountExpired ?? this.discountExpired,
      discount: discount ?? this.discount,
      value: value ?? this.value,
      isSynced: isSynced ?? this.isSynced,
      productId: productId ?? this.productId,
      syncedAt: syncedAt ?? this.syncedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverId: serverId ?? this.serverId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currencyId.present) {
      map['currency_id'] = Variable<int>(currencyId.value);
    }
    if (discountExpired.present) {
      map['discount_expired'] = Variable<DateTime>(discountExpired.value);
    }
    if (discount.present) {
      map['discount'] = Variable<double>(discount.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PriceCompanion(')
          ..write('id: $id, ')
          ..write('currencyId: $currencyId, ')
          ..write('discountExpired: $discountExpired, ')
          ..write('discount: $discount, ')
          ..write('value: $value, ')
          ..write('isSynced: $isSynced, ')
          ..write('productId: $productId, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }
}

class $EmployeeTable extends Employee
    with TableInfo<$EmployeeTable, EmployeeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeeTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _firstNameMeta =
      const VerificationMeta('firstName');
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
      'first_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastNameMeta =
      const VerificationMeta('lastName');
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneNumberMeta =
      const VerificationMeta('phoneNumber');
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
      'phone_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneNumber2Meta =
      const VerificationMeta('phoneNumber2');
  @override
  late final GeneratedColumn<String> phoneNumber2 = GeneratedColumn<String>(
      'phone_number2', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dobDayMeta = const VerificationMeta('dobDay');
  @override
  late final GeneratedColumn<DateTime> dobDay = GeneratedColumn<DateTime>(
      'dob_day', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<String> position = GeneratedColumn<String>(
      'position', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
      'gender', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cardNumberMeta =
      const VerificationMeta('cardNumber');
  @override
  late final GeneratedColumn<String> cardNumber = GeneratedColumn<String>(
      'card_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
      'server_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        firstName,
        lastName,
        address,
        phoneNumber,
        phoneNumber2,
        dobDay,
        position,
        gender,
        cardNumber,
        isSynced,
        syncedAt,
        createdAt,
        updatedAt,
        serverId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employee';
  @override
  VerificationContext validateIntegrity(Insertable<EmployeeData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta));
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('phone_number')) {
      context.handle(
          _phoneNumberMeta,
          phoneNumber.isAcceptableOrUnknown(
              data['phone_number']!, _phoneNumberMeta));
    }
    if (data.containsKey('phone_number2')) {
      context.handle(
          _phoneNumber2Meta,
          phoneNumber2.isAcceptableOrUnknown(
              data['phone_number2']!, _phoneNumber2Meta));
    }
    if (data.containsKey('dob_day')) {
      context.handle(_dobDayMeta,
          dobDay.isAcceptableOrUnknown(data['dob_day']!, _dobDayMeta));
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    }
    if (data.containsKey('card_number')) {
      context.handle(
          _cardNumberMeta,
          cardNumber.isAcceptableOrUnknown(
              data['card_number']!, _cardNumberMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmployeeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      firstName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_name'])!,
      lastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_name']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      phoneNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone_number']),
      phoneNumber2: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone_number2']),
      dobDay: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}dob_day']),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}position']),
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gender']),
      cardNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}card_number']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced']),
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_id']),
    );
  }

  @override
  $EmployeeTable createAlias(String alias) {
    return $EmployeeTable(attachedDatabase, alias);
  }
}

class EmployeeData extends DataClass implements Insertable<EmployeeData> {
  final int id;
  final String firstName;
  final String? lastName;
  final String? address;
  final String? phoneNumber;
  final String? phoneNumber2;
  final DateTime? dobDay;
  final String? position;
  final String? gender;
  final String? cardNumber;
  final bool? isSynced;
  final DateTime? syncedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? serverId;
  const EmployeeData(
      {required this.id,
      required this.firstName,
      this.lastName,
      this.address,
      this.phoneNumber,
      this.phoneNumber2,
      this.dobDay,
      this.position,
      this.gender,
      this.cardNumber,
      this.isSynced,
      this.syncedAt,
      required this.createdAt,
      required this.updatedAt,
      this.serverId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['first_name'] = Variable<String>(firstName);
    if (!nullToAbsent || lastName != null) {
      map['last_name'] = Variable<String>(lastName);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || phoneNumber2 != null) {
      map['phone_number2'] = Variable<String>(phoneNumber2);
    }
    if (!nullToAbsent || dobDay != null) {
      map['dob_day'] = Variable<DateTime>(dobDay);
    }
    if (!nullToAbsent || position != null) {
      map['position'] = Variable<String>(position);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || cardNumber != null) {
      map['card_number'] = Variable<String>(cardNumber);
    }
    if (!nullToAbsent || isSynced != null) {
      map['is_synced'] = Variable<bool>(isSynced);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    return map;
  }

  EmployeeCompanion toCompanion(bool nullToAbsent) {
    return EmployeeCompanion(
      id: Value(id),
      firstName: Value(firstName),
      lastName: lastName == null && nullToAbsent
          ? const Value.absent()
          : Value(lastName),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      phoneNumber2: phoneNumber2 == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber2),
      dobDay:
          dobDay == null && nullToAbsent ? const Value.absent() : Value(dobDay),
      position: position == null && nullToAbsent
          ? const Value.absent()
          : Value(position),
      gender:
          gender == null && nullToAbsent ? const Value.absent() : Value(gender),
      cardNumber: cardNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(cardNumber),
      isSynced: isSynced == null && nullToAbsent
          ? const Value.absent()
          : Value(isSynced),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
    );
  }

  factory EmployeeData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeData(
      id: serializer.fromJson<int>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String?>(json['lastName']),
      address: serializer.fromJson<String?>(json['address']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      phoneNumber2: serializer.fromJson<String?>(json['phoneNumber2']),
      dobDay: serializer.fromJson<DateTime?>(json['dobDay']),
      position: serializer.fromJson<String?>(json['position']),
      gender: serializer.fromJson<String?>(json['gender']),
      cardNumber: serializer.fromJson<String?>(json['cardNumber']),
      isSynced: serializer.fromJson<bool?>(json['isSynced']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverId: serializer.fromJson<int?>(json['serverId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String?>(lastName),
      'address': serializer.toJson<String?>(address),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'phoneNumber2': serializer.toJson<String?>(phoneNumber2),
      'dobDay': serializer.toJson<DateTime?>(dobDay),
      'position': serializer.toJson<String?>(position),
      'gender': serializer.toJson<String?>(gender),
      'cardNumber': serializer.toJson<String?>(cardNumber),
      'isSynced': serializer.toJson<bool?>(isSynced),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverId': serializer.toJson<int?>(serverId),
    };
  }

  EmployeeData copyWith(
          {int? id,
          String? firstName,
          Value<String?> lastName = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> phoneNumber = const Value.absent(),
          Value<String?> phoneNumber2 = const Value.absent(),
          Value<DateTime?> dobDay = const Value.absent(),
          Value<String?> position = const Value.absent(),
          Value<String?> gender = const Value.absent(),
          Value<String?> cardNumber = const Value.absent(),
          Value<bool?> isSynced = const Value.absent(),
          Value<DateTime?> syncedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<int?> serverId = const Value.absent()}) =>
      EmployeeData(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName.present ? lastName.value : this.lastName,
        address: address.present ? address.value : this.address,
        phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
        phoneNumber2:
            phoneNumber2.present ? phoneNumber2.value : this.phoneNumber2,
        dobDay: dobDay.present ? dobDay.value : this.dobDay,
        position: position.present ? position.value : this.position,
        gender: gender.present ? gender.value : this.gender,
        cardNumber: cardNumber.present ? cardNumber.value : this.cardNumber,
        isSynced: isSynced.present ? isSynced.value : this.isSynced,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        serverId: serverId.present ? serverId.value : this.serverId,
      );
  @override
  String toString() {
    return (StringBuffer('EmployeeData(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('address: $address, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('phoneNumber2: $phoneNumber2, ')
          ..write('dobDay: $dobDay, ')
          ..write('position: $position, ')
          ..write('gender: $gender, ')
          ..write('cardNumber: $cardNumber, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      firstName,
      lastName,
      address,
      phoneNumber,
      phoneNumber2,
      dobDay,
      position,
      gender,
      cardNumber,
      isSynced,
      syncedAt,
      createdAt,
      updatedAt,
      serverId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeData &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.address == this.address &&
          other.phoneNumber == this.phoneNumber &&
          other.phoneNumber2 == this.phoneNumber2 &&
          other.dobDay == this.dobDay &&
          other.position == this.position &&
          other.gender == this.gender &&
          other.cardNumber == this.cardNumber &&
          other.isSynced == this.isSynced &&
          other.syncedAt == this.syncedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverId == this.serverId);
}

class EmployeeCompanion extends UpdateCompanion<EmployeeData> {
  final Value<int> id;
  final Value<String> firstName;
  final Value<String?> lastName;
  final Value<String?> address;
  final Value<String?> phoneNumber;
  final Value<String?> phoneNumber2;
  final Value<DateTime?> dobDay;
  final Value<String?> position;
  final Value<String?> gender;
  final Value<String?> cardNumber;
  final Value<bool?> isSynced;
  final Value<DateTime?> syncedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int?> serverId;
  const EmployeeCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.address = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.phoneNumber2 = const Value.absent(),
    this.dobDay = const Value.absent(),
    this.position = const Value.absent(),
    this.gender = const Value.absent(),
    this.cardNumber = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverId = const Value.absent(),
  });
  EmployeeCompanion.insert({
    this.id = const Value.absent(),
    required String firstName,
    this.lastName = const Value.absent(),
    this.address = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.phoneNumber2 = const Value.absent(),
    this.dobDay = const Value.absent(),
    this.position = const Value.absent(),
    this.gender = const Value.absent(),
    this.cardNumber = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverId = const Value.absent(),
  })  : firstName = Value(firstName),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<EmployeeData> custom({
    Expression<int>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? address,
    Expression<String>? phoneNumber,
    Expression<String>? phoneNumber2,
    Expression<DateTime>? dobDay,
    Expression<String>? position,
    Expression<String>? gender,
    Expression<String>? cardNumber,
    Expression<bool>? isSynced,
    Expression<DateTime>? syncedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (address != null) 'address': address,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (phoneNumber2 != null) 'phone_number2': phoneNumber2,
      if (dobDay != null) 'dob_day': dobDay,
      if (position != null) 'position': position,
      if (gender != null) 'gender': gender,
      if (cardNumber != null) 'card_number': cardNumber,
      if (isSynced != null) 'is_synced': isSynced,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverId != null) 'server_id': serverId,
    });
  }

  EmployeeCompanion copyWith(
      {Value<int>? id,
      Value<String>? firstName,
      Value<String?>? lastName,
      Value<String?>? address,
      Value<String?>? phoneNumber,
      Value<String?>? phoneNumber2,
      Value<DateTime?>? dobDay,
      Value<String?>? position,
      Value<String?>? gender,
      Value<String?>? cardNumber,
      Value<bool?>? isSynced,
      Value<DateTime?>? syncedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int?>? serverId}) {
    return EmployeeCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      phoneNumber2: phoneNumber2 ?? this.phoneNumber2,
      dobDay: dobDay ?? this.dobDay,
      position: position ?? this.position,
      gender: gender ?? this.gender,
      cardNumber: cardNumber ?? this.cardNumber,
      isSynced: isSynced ?? this.isSynced,
      syncedAt: syncedAt ?? this.syncedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverId: serverId ?? this.serverId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (phoneNumber2.present) {
      map['phone_number2'] = Variable<String>(phoneNumber2.value);
    }
    if (dobDay.present) {
      map['dob_day'] = Variable<DateTime>(dobDay.value);
    }
    if (position.present) {
      map['position'] = Variable<String>(position.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (cardNumber.present) {
      map['card_number'] = Variable<String>(cardNumber.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('address: $address, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('phoneNumber2: $phoneNumber2, ')
          ..write('dobDay: $dobDay, ')
          ..write('position: $position, ')
          ..write('gender: $gender, ')
          ..write('cardNumber: $cardNumber, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }
}

class $POSTable extends POS with TableInfo<$POSTable, POSData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $POSTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
      'active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("active" IN (0, 1))'));
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
      'server_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<PosType?, String> type =
      GeneratedColumn<String>('type', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<PosType?>($POSTable.$convertertypen);
  @override
  List<GeneratedColumn> get $columns => [
        name,
        isSynced,
        syncedAt,
        createdAt,
        updatedAt,
        id,
        active,
        serverId,
        type
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pos';
  @override
  VerificationContext validateIntegrity(Insertable<POSData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('active')) {
      context.handle(_activeMeta,
          active.isAcceptableOrUnknown(data['active']!, _activeMeta));
    } else if (isInserting) {
      context.missing(_activeMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    context.handle(_typeMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  POSData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return POSData(
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      active: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}active'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_id']),
      type: $POSTable.$convertertypen.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])),
    );
  }

  @override
  $POSTable createAlias(String alias) {
    return $POSTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PosType, String, String> $convertertype =
      const EnumNameConverter<PosType>(PosType.values);
  static JsonTypeConverter2<PosType?, String?, String?> $convertertypen =
      JsonTypeConverter2.asNullable($convertertype);
}

class POSData extends DataClass implements Insertable<POSData> {
  final String name;
  final bool isSynced;
  final DateTime? syncedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int id;
  final bool active;
  final int? serverId;
  final PosType? type;
  const POSData(
      {required this.name,
      required this.isSynced,
      this.syncedAt,
      required this.createdAt,
      required this.updatedAt,
      required this.id,
      required this.active,
      this.serverId,
      this.type});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['id'] = Variable<int>(id);
    map['active'] = Variable<bool>(active);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    if (!nullToAbsent || type != null) {
      final converter = $POSTable.$convertertypen;
      map['type'] = Variable<String>(converter.toSql(type));
    }
    return map;
  }

  POSCompanion toCompanion(bool nullToAbsent) {
    return POSCompanion(
      name: Value(name),
      isSynced: Value(isSynced),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      id: Value(id),
      active: Value(active),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
    );
  }

  factory POSData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return POSData(
      name: serializer.fromJson<String>(json['name']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      id: serializer.fromJson<int>(json['id']),
      active: serializer.fromJson<bool>(json['active']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      type: $POSTable.$convertertypen
          .fromJson(serializer.fromJson<String?>(json['type'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'isSynced': serializer.toJson<bool>(isSynced),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'id': serializer.toJson<int>(id),
      'active': serializer.toJson<bool>(active),
      'serverId': serializer.toJson<int?>(serverId),
      'type':
          serializer.toJson<String?>($POSTable.$convertertypen.toJson(type)),
    };
  }

  POSData copyWith(
          {String? name,
          bool? isSynced,
          Value<DateTime?> syncedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          int? id,
          bool? active,
          Value<int?> serverId = const Value.absent(),
          Value<PosType?> type = const Value.absent()}) =>
      POSData(
        name: name ?? this.name,
        isSynced: isSynced ?? this.isSynced,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        id: id ?? this.id,
        active: active ?? this.active,
        serverId: serverId.present ? serverId.value : this.serverId,
        type: type.present ? type.value : this.type,
      );
  @override
  String toString() {
    return (StringBuffer('POSData(')
          ..write('name: $name, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('active: $active, ')
          ..write('serverId: $serverId, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(name, isSynced, syncedAt, createdAt,
      updatedAt, id, active, serverId, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is POSData &&
          other.name == this.name &&
          other.isSynced == this.isSynced &&
          other.syncedAt == this.syncedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.id == this.id &&
          other.active == this.active &&
          other.serverId == this.serverId &&
          other.type == this.type);
}

class POSCompanion extends UpdateCompanion<POSData> {
  final Value<String> name;
  final Value<bool> isSynced;
  final Value<DateTime?> syncedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> id;
  final Value<bool> active;
  final Value<int?> serverId;
  final Value<PosType?> type;
  const POSCompanion({
    this.name = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.active = const Value.absent(),
    this.serverId = const Value.absent(),
    this.type = const Value.absent(),
  });
  POSCompanion.insert({
    required String name,
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.id = const Value.absent(),
    required bool active,
    this.serverId = const Value.absent(),
    this.type = const Value.absent(),
  })  : name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        active = Value(active);
  static Insertable<POSData> custom({
    Expression<String>? name,
    Expression<bool>? isSynced,
    Expression<DateTime>? syncedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? id,
    Expression<bool>? active,
    Expression<int>? serverId,
    Expression<String>? type,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (isSynced != null) 'is_synced': isSynced,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (id != null) 'id': id,
      if (active != null) 'active': active,
      if (serverId != null) 'server_id': serverId,
      if (type != null) 'type': type,
    });
  }

  POSCompanion copyWith(
      {Value<String>? name,
      Value<bool>? isSynced,
      Value<DateTime?>? syncedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? id,
      Value<bool>? active,
      Value<int?>? serverId,
      Value<PosType?>? type}) {
    return POSCompanion(
      name: name ?? this.name,
      isSynced: isSynced ?? this.isSynced,
      syncedAt: syncedAt ?? this.syncedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      active: active ?? this.active,
      serverId: serverId ?? this.serverId,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (type.present) {
      final converter = $POSTable.$convertertypen;

      map['type'] = Variable<String>(converter.toSql(type.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('POSCompanion(')
          ..write('name: $name, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('active: $active, ')
          ..write('serverId: $serverId, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $PosSessionTable extends PosSession
    with TableInfo<$PosSessionTable, PosSessionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PosSessionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _posMeta = const VerificationMeta('pos');
  @override
  late final GeneratedColumn<int> pos = GeneratedColumn<int>(
      'pos', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES pos (id)'));
  static const VerificationMeta _cashierMeta =
      const VerificationMeta('cashier');
  @override
  late final GeneratedColumn<int> cashier = GeneratedColumn<int>(
      'cashier', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES employee (id)'));
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
      'end_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _sessionStartNoteMeta =
      const VerificationMeta('sessionStartNote');
  @override
  late final GeneratedColumn<String> sessionStartNote = GeneratedColumn<String>(
      'session_start_note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sessionEndNoteMeta =
      const VerificationMeta('sessionEndNote');
  @override
  late final GeneratedColumn<String> sessionEndNote = GeneratedColumn<String>(
      'session_end_note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
      'server_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        pos,
        cashier,
        startTime,
        endTime,
        sessionStartNote,
        sessionEndNote,
        createdAt,
        updatedAt,
        isSynced,
        syncedAt,
        serverId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pos_session';
  @override
  VerificationContext validateIntegrity(Insertable<PosSessionData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pos')) {
      context.handle(
          _posMeta, pos.isAcceptableOrUnknown(data['pos']!, _posMeta));
    }
    if (data.containsKey('cashier')) {
      context.handle(_cashierMeta,
          cashier.isAcceptableOrUnknown(data['cashier']!, _cashierMeta));
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    }
    if (data.containsKey('session_start_note')) {
      context.handle(
          _sessionStartNoteMeta,
          sessionStartNote.isAcceptableOrUnknown(
              data['session_start_note']!, _sessionStartNoteMeta));
    }
    if (data.containsKey('session_end_note')) {
      context.handle(
          _sessionEndNoteMeta,
          sessionEndNote.isAcceptableOrUnknown(
              data['session_end_note']!, _sessionEndNoteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PosSessionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PosSessionData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      pos: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pos']),
      cashier: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cashier']),
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time']),
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_time']),
      sessionStartNote: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}session_start_note']),
      sessionEndNote: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}session_end_note']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced']),
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_id']),
    );
  }

  @override
  $PosSessionTable createAlias(String alias) {
    return $PosSessionTable(attachedDatabase, alias);
  }
}

class PosSessionData extends DataClass implements Insertable<PosSessionData> {
  final int id;
  final int? pos;
  final int? cashier;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? sessionStartNote;
  final String? sessionEndNote;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool? isSynced;
  final DateTime? syncedAt;
  final int? serverId;
  const PosSessionData(
      {required this.id,
      this.pos,
      this.cashier,
      this.startTime,
      this.endTime,
      this.sessionStartNote,
      this.sessionEndNote,
      required this.createdAt,
      required this.updatedAt,
      this.isSynced,
      this.syncedAt,
      this.serverId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || pos != null) {
      map['pos'] = Variable<int>(pos);
    }
    if (!nullToAbsent || cashier != null) {
      map['cashier'] = Variable<int>(cashier);
    }
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = Variable<DateTime>(startTime);
    }
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    if (!nullToAbsent || sessionStartNote != null) {
      map['session_start_note'] = Variable<String>(sessionStartNote);
    }
    if (!nullToAbsent || sessionEndNote != null) {
      map['session_end_note'] = Variable<String>(sessionEndNote);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || isSynced != null) {
      map['is_synced'] = Variable<bool>(isSynced);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    return map;
  }

  PosSessionCompanion toCompanion(bool nullToAbsent) {
    return PosSessionCompanion(
      id: Value(id),
      pos: pos == null && nullToAbsent ? const Value.absent() : Value(pos),
      cashier: cashier == null && nullToAbsent
          ? const Value.absent()
          : Value(cashier),
      startTime: startTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      sessionStartNote: sessionStartNote == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionStartNote),
      sessionEndNote: sessionEndNote == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionEndNote),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: isSynced == null && nullToAbsent
          ? const Value.absent()
          : Value(isSynced),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
    );
  }

  factory PosSessionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PosSessionData(
      id: serializer.fromJson<int>(json['id']),
      pos: serializer.fromJson<int?>(json['pos']),
      cashier: serializer.fromJson<int?>(json['cashier']),
      startTime: serializer.fromJson<DateTime?>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      sessionStartNote: serializer.fromJson<String?>(json['sessionStartNote']),
      sessionEndNote: serializer.fromJson<String?>(json['sessionEndNote']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool?>(json['isSynced']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      serverId: serializer.fromJson<int?>(json['serverId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pos': serializer.toJson<int?>(pos),
      'cashier': serializer.toJson<int?>(cashier),
      'startTime': serializer.toJson<DateTime?>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'sessionStartNote': serializer.toJson<String?>(sessionStartNote),
      'sessionEndNote': serializer.toJson<String?>(sessionEndNote),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool?>(isSynced),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'serverId': serializer.toJson<int?>(serverId),
    };
  }

  PosSessionData copyWith(
          {int? id,
          Value<int?> pos = const Value.absent(),
          Value<int?> cashier = const Value.absent(),
          Value<DateTime?> startTime = const Value.absent(),
          Value<DateTime?> endTime = const Value.absent(),
          Value<String?> sessionStartNote = const Value.absent(),
          Value<String?> sessionEndNote = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<bool?> isSynced = const Value.absent(),
          Value<DateTime?> syncedAt = const Value.absent(),
          Value<int?> serverId = const Value.absent()}) =>
      PosSessionData(
        id: id ?? this.id,
        pos: pos.present ? pos.value : this.pos,
        cashier: cashier.present ? cashier.value : this.cashier,
        startTime: startTime.present ? startTime.value : this.startTime,
        endTime: endTime.present ? endTime.value : this.endTime,
        sessionStartNote: sessionStartNote.present
            ? sessionStartNote.value
            : this.sessionStartNote,
        sessionEndNote:
            sessionEndNote.present ? sessionEndNote.value : this.sessionEndNote,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isSynced: isSynced.present ? isSynced.value : this.isSynced,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        serverId: serverId.present ? serverId.value : this.serverId,
      );
  @override
  String toString() {
    return (StringBuffer('PosSessionData(')
          ..write('id: $id, ')
          ..write('pos: $pos, ')
          ..write('cashier: $cashier, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('sessionStartNote: $sessionStartNote, ')
          ..write('sessionEndNote: $sessionEndNote, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      pos,
      cashier,
      startTime,
      endTime,
      sessionStartNote,
      sessionEndNote,
      createdAt,
      updatedAt,
      isSynced,
      syncedAt,
      serverId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PosSessionData &&
          other.id == this.id &&
          other.pos == this.pos &&
          other.cashier == this.cashier &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.sessionStartNote == this.sessionStartNote &&
          other.sessionEndNote == this.sessionEndNote &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.syncedAt == this.syncedAt &&
          other.serverId == this.serverId);
}

class PosSessionCompanion extends UpdateCompanion<PosSessionData> {
  final Value<int> id;
  final Value<int?> pos;
  final Value<int?> cashier;
  final Value<DateTime?> startTime;
  final Value<DateTime?> endTime;
  final Value<String?> sessionStartNote;
  final Value<String?> sessionEndNote;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool?> isSynced;
  final Value<DateTime?> syncedAt;
  final Value<int?> serverId;
  const PosSessionCompanion({
    this.id = const Value.absent(),
    this.pos = const Value.absent(),
    this.cashier = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.sessionStartNote = const Value.absent(),
    this.sessionEndNote = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.serverId = const Value.absent(),
  });
  PosSessionCompanion.insert({
    this.id = const Value.absent(),
    this.pos = const Value.absent(),
    this.cashier = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.sessionStartNote = const Value.absent(),
    this.sessionEndNote = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.serverId = const Value.absent(),
  })  : createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<PosSessionData> custom({
    Expression<int>? id,
    Expression<int>? pos,
    Expression<int>? cashier,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<String>? sessionStartNote,
    Expression<String>? sessionEndNote,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<DateTime>? syncedAt,
    Expression<int>? serverId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pos != null) 'pos': pos,
      if (cashier != null) 'cashier': cashier,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (sessionStartNote != null) 'session_start_note': sessionStartNote,
      if (sessionEndNote != null) 'session_end_note': sessionEndNote,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (serverId != null) 'server_id': serverId,
    });
  }

  PosSessionCompanion copyWith(
      {Value<int>? id,
      Value<int?>? pos,
      Value<int?>? cashier,
      Value<DateTime?>? startTime,
      Value<DateTime?>? endTime,
      Value<String?>? sessionStartNote,
      Value<String?>? sessionEndNote,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool?>? isSynced,
      Value<DateTime?>? syncedAt,
      Value<int?>? serverId}) {
    return PosSessionCompanion(
      id: id ?? this.id,
      pos: pos ?? this.pos,
      cashier: cashier ?? this.cashier,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      sessionStartNote: sessionStartNote ?? this.sessionStartNote,
      sessionEndNote: sessionEndNote ?? this.sessionEndNote,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      syncedAt: syncedAt ?? this.syncedAt,
      serverId: serverId ?? this.serverId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pos.present) {
      map['pos'] = Variable<int>(pos.value);
    }
    if (cashier.present) {
      map['cashier'] = Variable<int>(cashier.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (sessionStartNote.present) {
      map['session_start_note'] = Variable<String>(sessionStartNote.value);
    }
    if (sessionEndNote.present) {
      map['session_end_note'] = Variable<String>(sessionEndNote.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PosSessionCompanion(')
          ..write('id: $id, ')
          ..write('pos: $pos, ')
          ..write('cashier: $cashier, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('sessionStartNote: $sessionStartNote, ')
          ..write('sessionEndNote: $sessionEndNote, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }
}

class $TradeTable extends Trade with TableInfo<$TradeTable, TradeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TradeTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _posSessionIdMeta =
      const VerificationMeta('posSessionId');
  @override
  late final GeneratedColumn<int> posSessionId = GeneratedColumn<int>(
      'pos_session_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES pos_session (id)'));
  static const VerificationMeta _clientIdMeta =
      const VerificationMeta('clientId');
  @override
  late final GeneratedColumn<int> clientId = GeneratedColumn<int>(
      'client_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES client (id)'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _discountMeta =
      const VerificationMeta('discount');
  @override
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
      'discount', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _refundMeta = const VerificationMeta('refund');
  @override
  late final GeneratedColumn<double> refund = GeneratedColumn<double>(
      'refund', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _isFinishedMeta =
      const VerificationMeta('isFinished');
  @override
  late final GeneratedColumn<bool> isFinished = GeneratedColumn<bool>(
      'is_finished', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_finished" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isCanceledMeta =
      const VerificationMeta('isCanceled');
  @override
  late final GeneratedColumn<bool> isCanceled = GeneratedColumn<bool>(
      'is_canceled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_canceled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isReturnedMeta =
      const VerificationMeta('isReturned');
  @override
  late final GeneratedColumn<bool> isReturned = GeneratedColumn<bool>(
      'is_returned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_returned" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _returnedMoneyMeta =
      const VerificationMeta('returnedMoney');
  @override
  late final GeneratedColumn<bool> returnedMoney = GeneratedColumn<bool>(
      'returned_money', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("returned_money" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _returnedProductsIncomeMeta =
      const VerificationMeta('returnedProductsIncome');
  @override
  late final GeneratedColumn<bool> returnedProductsIncome =
      GeneratedColumn<bool>('returned_products_income', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("returned_products_income" IN (0, 1))'),
          defaultValue: const Constant(false));
  static const VerificationMeta _finishedAtMeta =
      const VerificationMeta('finishedAt');
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
      'finished_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
      'server_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        posSessionId,
        clientId,
        description,
        discount,
        refund,
        isFinished,
        isCanceled,
        isReturned,
        returnedMoney,
        returnedProductsIncome,
        finishedAt,
        updatedAt,
        createdAt,
        syncedAt,
        isSynced,
        serverId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trade';
  @override
  VerificationContext validateIntegrity(Insertable<TradeData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pos_session_id')) {
      context.handle(
          _posSessionIdMeta,
          posSessionId.isAcceptableOrUnknown(
              data['pos_session_id']!, _posSessionIdMeta));
    }
    if (data.containsKey('client_id')) {
      context.handle(_clientIdMeta,
          clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('discount')) {
      context.handle(_discountMeta,
          discount.isAcceptableOrUnknown(data['discount']!, _discountMeta));
    }
    if (data.containsKey('refund')) {
      context.handle(_refundMeta,
          refund.isAcceptableOrUnknown(data['refund']!, _refundMeta));
    }
    if (data.containsKey('is_finished')) {
      context.handle(
          _isFinishedMeta,
          isFinished.isAcceptableOrUnknown(
              data['is_finished']!, _isFinishedMeta));
    }
    if (data.containsKey('is_canceled')) {
      context.handle(
          _isCanceledMeta,
          isCanceled.isAcceptableOrUnknown(
              data['is_canceled']!, _isCanceledMeta));
    }
    if (data.containsKey('is_returned')) {
      context.handle(
          _isReturnedMeta,
          isReturned.isAcceptableOrUnknown(
              data['is_returned']!, _isReturnedMeta));
    }
    if (data.containsKey('returned_money')) {
      context.handle(
          _returnedMoneyMeta,
          returnedMoney.isAcceptableOrUnknown(
              data['returned_money']!, _returnedMoneyMeta));
    }
    if (data.containsKey('returned_products_income')) {
      context.handle(
          _returnedProductsIncomeMeta,
          returnedProductsIncome.isAcceptableOrUnknown(
              data['returned_products_income']!, _returnedProductsIncomeMeta));
    }
    if (data.containsKey('finished_at')) {
      context.handle(
          _finishedAtMeta,
          finishedAt.isAcceptableOrUnknown(
              data['finished_at']!, _finishedAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TradeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TradeData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      posSessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pos_session_id']),
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}client_id']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      discount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}discount']),
      refund: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}refund']),
      isFinished: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_finished'])!,
      isCanceled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_canceled'])!,
      isReturned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_returned'])!,
      returnedMoney: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}returned_money'])!,
      returnedProductsIncome: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}returned_products_income'])!,
      finishedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}finished_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_id']),
    );
  }

  @override
  $TradeTable createAlias(String alias) {
    return $TradeTable(attachedDatabase, alias);
  }
}

class TradeData extends DataClass implements Insertable<TradeData> {
  final int id;
  final int? posSessionId;
  final int? clientId;
  final String? description;
  final double? discount;
  final double? refund;
  final bool isFinished;
  final bool isCanceled;
  final bool isReturned;
  final bool returnedMoney;
  final bool returnedProductsIncome;
  final DateTime? finishedAt;
  final DateTime updatedAt;
  final DateTime createdAt;
  final DateTime? syncedAt;
  final bool isSynced;
  final int? serverId;
  const TradeData(
      {required this.id,
      this.posSessionId,
      this.clientId,
      this.description,
      this.discount,
      this.refund,
      required this.isFinished,
      required this.isCanceled,
      required this.isReturned,
      required this.returnedMoney,
      required this.returnedProductsIncome,
      this.finishedAt,
      required this.updatedAt,
      required this.createdAt,
      this.syncedAt,
      required this.isSynced,
      this.serverId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || posSessionId != null) {
      map['pos_session_id'] = Variable<int>(posSessionId);
    }
    if (!nullToAbsent || clientId != null) {
      map['client_id'] = Variable<int>(clientId);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || discount != null) {
      map['discount'] = Variable<double>(discount);
    }
    if (!nullToAbsent || refund != null) {
      map['refund'] = Variable<double>(refund);
    }
    map['is_finished'] = Variable<bool>(isFinished);
    map['is_canceled'] = Variable<bool>(isCanceled);
    map['is_returned'] = Variable<bool>(isReturned);
    map['returned_money'] = Variable<bool>(returnedMoney);
    map['returned_products_income'] = Variable<bool>(returnedProductsIncome);
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    return map;
  }

  TradeCompanion toCompanion(bool nullToAbsent) {
    return TradeCompanion(
      id: Value(id),
      posSessionId: posSessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(posSessionId),
      clientId: clientId == null && nullToAbsent
          ? const Value.absent()
          : Value(clientId),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      discount: discount == null && nullToAbsent
          ? const Value.absent()
          : Value(discount),
      refund:
          refund == null && nullToAbsent ? const Value.absent() : Value(refund),
      isFinished: Value(isFinished),
      isCanceled: Value(isCanceled),
      isReturned: Value(isReturned),
      returnedMoney: Value(returnedMoney),
      returnedProductsIncome: Value(returnedProductsIncome),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      isSynced: Value(isSynced),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
    );
  }

  factory TradeData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TradeData(
      id: serializer.fromJson<int>(json['id']),
      posSessionId: serializer.fromJson<int?>(json['posSessionId']),
      clientId: serializer.fromJson<int?>(json['clientId']),
      description: serializer.fromJson<String?>(json['description']),
      discount: serializer.fromJson<double?>(json['discount']),
      refund: serializer.fromJson<double?>(json['refund']),
      isFinished: serializer.fromJson<bool>(json['isFinished']),
      isCanceled: serializer.fromJson<bool>(json['isCanceled']),
      isReturned: serializer.fromJson<bool>(json['isReturned']),
      returnedMoney: serializer.fromJson<bool>(json['returnedMoney']),
      returnedProductsIncome:
          serializer.fromJson<bool>(json['returnedProductsIncome']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      serverId: serializer.fromJson<int?>(json['serverId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'posSessionId': serializer.toJson<int?>(posSessionId),
      'clientId': serializer.toJson<int?>(clientId),
      'description': serializer.toJson<String?>(description),
      'discount': serializer.toJson<double?>(discount),
      'refund': serializer.toJson<double?>(refund),
      'isFinished': serializer.toJson<bool>(isFinished),
      'isCanceled': serializer.toJson<bool>(isCanceled),
      'isReturned': serializer.toJson<bool>(isReturned),
      'returnedMoney': serializer.toJson<bool>(returnedMoney),
      'returnedProductsIncome': serializer.toJson<bool>(returnedProductsIncome),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'serverId': serializer.toJson<int?>(serverId),
    };
  }

  TradeData copyWith(
          {int? id,
          Value<int?> posSessionId = const Value.absent(),
          Value<int?> clientId = const Value.absent(),
          Value<String?> description = const Value.absent(),
          Value<double?> discount = const Value.absent(),
          Value<double?> refund = const Value.absent(),
          bool? isFinished,
          bool? isCanceled,
          bool? isReturned,
          bool? returnedMoney,
          bool? returnedProductsIncome,
          Value<DateTime?> finishedAt = const Value.absent(),
          DateTime? updatedAt,
          DateTime? createdAt,
          Value<DateTime?> syncedAt = const Value.absent(),
          bool? isSynced,
          Value<int?> serverId = const Value.absent()}) =>
      TradeData(
        id: id ?? this.id,
        posSessionId:
            posSessionId.present ? posSessionId.value : this.posSessionId,
        clientId: clientId.present ? clientId.value : this.clientId,
        description: description.present ? description.value : this.description,
        discount: discount.present ? discount.value : this.discount,
        refund: refund.present ? refund.value : this.refund,
        isFinished: isFinished ?? this.isFinished,
        isCanceled: isCanceled ?? this.isCanceled,
        isReturned: isReturned ?? this.isReturned,
        returnedMoney: returnedMoney ?? this.returnedMoney,
        returnedProductsIncome:
            returnedProductsIncome ?? this.returnedProductsIncome,
        finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        isSynced: isSynced ?? this.isSynced,
        serverId: serverId.present ? serverId.value : this.serverId,
      );
  @override
  String toString() {
    return (StringBuffer('TradeData(')
          ..write('id: $id, ')
          ..write('posSessionId: $posSessionId, ')
          ..write('clientId: $clientId, ')
          ..write('description: $description, ')
          ..write('discount: $discount, ')
          ..write('refund: $refund, ')
          ..write('isFinished: $isFinished, ')
          ..write('isCanceled: $isCanceled, ')
          ..write('isReturned: $isReturned, ')
          ..write('returnedMoney: $returnedMoney, ')
          ..write('returnedProductsIncome: $returnedProductsIncome, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      posSessionId,
      clientId,
      description,
      discount,
      refund,
      isFinished,
      isCanceled,
      isReturned,
      returnedMoney,
      returnedProductsIncome,
      finishedAt,
      updatedAt,
      createdAt,
      syncedAt,
      isSynced,
      serverId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TradeData &&
          other.id == this.id &&
          other.posSessionId == this.posSessionId &&
          other.clientId == this.clientId &&
          other.description == this.description &&
          other.discount == this.discount &&
          other.refund == this.refund &&
          other.isFinished == this.isFinished &&
          other.isCanceled == this.isCanceled &&
          other.isReturned == this.isReturned &&
          other.returnedMoney == this.returnedMoney &&
          other.returnedProductsIncome == this.returnedProductsIncome &&
          other.finishedAt == this.finishedAt &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt &&
          other.syncedAt == this.syncedAt &&
          other.isSynced == this.isSynced &&
          other.serverId == this.serverId);
}

class TradeCompanion extends UpdateCompanion<TradeData> {
  final Value<int> id;
  final Value<int?> posSessionId;
  final Value<int?> clientId;
  final Value<String?> description;
  final Value<double?> discount;
  final Value<double?> refund;
  final Value<bool> isFinished;
  final Value<bool> isCanceled;
  final Value<bool> isReturned;
  final Value<bool> returnedMoney;
  final Value<bool> returnedProductsIncome;
  final Value<DateTime?> finishedAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime?> syncedAt;
  final Value<bool> isSynced;
  final Value<int?> serverId;
  const TradeCompanion({
    this.id = const Value.absent(),
    this.posSessionId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.description = const Value.absent(),
    this.discount = const Value.absent(),
    this.refund = const Value.absent(),
    this.isFinished = const Value.absent(),
    this.isCanceled = const Value.absent(),
    this.isReturned = const Value.absent(),
    this.returnedMoney = const Value.absent(),
    this.returnedProductsIncome = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.serverId = const Value.absent(),
  });
  TradeCompanion.insert({
    this.id = const Value.absent(),
    this.posSessionId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.description = const Value.absent(),
    this.discount = const Value.absent(),
    this.refund = const Value.absent(),
    this.isFinished = const Value.absent(),
    this.isCanceled = const Value.absent(),
    this.isReturned = const Value.absent(),
    this.returnedMoney = const Value.absent(),
    this.returnedProductsIncome = const Value.absent(),
    this.finishedAt = const Value.absent(),
    required DateTime updatedAt,
    required DateTime createdAt,
    this.syncedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.serverId = const Value.absent(),
  })  : updatedAt = Value(updatedAt),
        createdAt = Value(createdAt);
  static Insertable<TradeData> custom({
    Expression<int>? id,
    Expression<int>? posSessionId,
    Expression<int>? clientId,
    Expression<String>? description,
    Expression<double>? discount,
    Expression<double>? refund,
    Expression<bool>? isFinished,
    Expression<bool>? isCanceled,
    Expression<bool>? isReturned,
    Expression<bool>? returnedMoney,
    Expression<bool>? returnedProductsIncome,
    Expression<DateTime>? finishedAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? syncedAt,
    Expression<bool>? isSynced,
    Expression<int>? serverId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (posSessionId != null) 'pos_session_id': posSessionId,
      if (clientId != null) 'client_id': clientId,
      if (description != null) 'description': description,
      if (discount != null) 'discount': discount,
      if (refund != null) 'refund': refund,
      if (isFinished != null) 'is_finished': isFinished,
      if (isCanceled != null) 'is_canceled': isCanceled,
      if (isReturned != null) 'is_returned': isReturned,
      if (returnedMoney != null) 'returned_money': returnedMoney,
      if (returnedProductsIncome != null)
        'returned_products_income': returnedProductsIncome,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (serverId != null) 'server_id': serverId,
    });
  }

  TradeCompanion copyWith(
      {Value<int>? id,
      Value<int?>? posSessionId,
      Value<int?>? clientId,
      Value<String?>? description,
      Value<double?>? discount,
      Value<double?>? refund,
      Value<bool>? isFinished,
      Value<bool>? isCanceled,
      Value<bool>? isReturned,
      Value<bool>? returnedMoney,
      Value<bool>? returnedProductsIncome,
      Value<DateTime?>? finishedAt,
      Value<DateTime>? updatedAt,
      Value<DateTime>? createdAt,
      Value<DateTime?>? syncedAt,
      Value<bool>? isSynced,
      Value<int?>? serverId}) {
    return TradeCompanion(
      id: id ?? this.id,
      posSessionId: posSessionId ?? this.posSessionId,
      clientId: clientId ?? this.clientId,
      description: description ?? this.description,
      discount: discount ?? this.discount,
      refund: refund ?? this.refund,
      isFinished: isFinished ?? this.isFinished,
      isCanceled: isCanceled ?? this.isCanceled,
      isReturned: isReturned ?? this.isReturned,
      returnedMoney: returnedMoney ?? this.returnedMoney,
      returnedProductsIncome:
          returnedProductsIncome ?? this.returnedProductsIncome,
      finishedAt: finishedAt ?? this.finishedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      isSynced: isSynced ?? this.isSynced,
      serverId: serverId ?? this.serverId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (posSessionId.present) {
      map['pos_session_id'] = Variable<int>(posSessionId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<int>(clientId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (discount.present) {
      map['discount'] = Variable<double>(discount.value);
    }
    if (refund.present) {
      map['refund'] = Variable<double>(refund.value);
    }
    if (isFinished.present) {
      map['is_finished'] = Variable<bool>(isFinished.value);
    }
    if (isCanceled.present) {
      map['is_canceled'] = Variable<bool>(isCanceled.value);
    }
    if (isReturned.present) {
      map['is_returned'] = Variable<bool>(isReturned.value);
    }
    if (returnedMoney.present) {
      map['returned_money'] = Variable<bool>(returnedMoney.value);
    }
    if (returnedProductsIncome.present) {
      map['returned_products_income'] =
          Variable<bool>(returnedProductsIncome.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TradeCompanion(')
          ..write('id: $id, ')
          ..write('posSessionId: $posSessionId, ')
          ..write('clientId: $clientId, ')
          ..write('description: $description, ')
          ..write('discount: $discount, ')
          ..write('refund: $refund, ')
          ..write('isFinished: $isFinished, ')
          ..write('isCanceled: $isCanceled, ')
          ..write('isReturned: $isReturned, ')
          ..write('returnedMoney: $returnedMoney, ')
          ..write('returnedProductsIncome: $returnedProductsIncome, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
      'server_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _incomeMeta = const VerificationMeta('income');
  @override
  late final GeneratedColumn<bool> income = GeneratedColumn<bool>(
      'income', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("income" IN (0, 1))'));
  static const VerificationMeta _payTypeMeta =
      const VerificationMeta('payType');
  @override
  late final GeneratedColumnWithTypeConverter<InvoiceType, String> payType =
      GeneratedColumn<String>('pay_type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<InvoiceType>($TransactionsTable.$converterpayType);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _tradeIdMeta =
      const VerificationMeta('tradeId');
  @override
  late final GeneratedColumn<int> tradeId = GeneratedColumn<int>(
      'trade_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES trade (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        serverId,
        amount,
        description,
        income,
        payType,
        createdAt,
        updatedAt,
        syncedAt,
        isSynced,
        tradeId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('income')) {
      context.handle(_incomeMeta,
          income.isAcceptableOrUnknown(data['income']!, _incomeMeta));
    } else if (isInserting) {
      context.missing(_incomeMeta);
    }
    context.handle(_payTypeMeta, const VerificationResult.success());
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('trade_id')) {
      context.handle(_tradeIdMeta,
          tradeId.isAcceptableOrUnknown(data['trade_id']!, _tradeIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_id']),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      income: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}income'])!,
      payType: $TransactionsTable.$converterpayType.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pay_type'])!),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      tradeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}trade_id']),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<InvoiceType, String, String> $converterpayType =
      const EnumNameConverter<InvoiceType>(InvoiceType.values);
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final int? serverId;
  final double amount;
  final String? description;
  final bool income;
  final InvoiceType payType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  final bool isSynced;
  final int? tradeId;
  const Transaction(
      {required this.id,
      this.serverId,
      required this.amount,
      this.description,
      required this.income,
      required this.payType,
      required this.createdAt,
      required this.updatedAt,
      this.syncedAt,
      required this.isSynced,
      this.tradeId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['income'] = Variable<bool>(income);
    {
      final converter = $TransactionsTable.$converterpayType;
      map['pay_type'] = Variable<String>(converter.toSql(payType));
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || tradeId != null) {
      map['trade_id'] = Variable<int>(tradeId);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      amount: Value(amount),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      income: Value(income),
      payType: Value(payType),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      isSynced: Value(isSynced),
      tradeId: tradeId == null && nullToAbsent
          ? const Value.absent()
          : Value(tradeId),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      amount: serializer.fromJson<double>(json['amount']),
      description: serializer.fromJson<String?>(json['description']),
      income: serializer.fromJson<bool>(json['income']),
      payType: $TransactionsTable.$converterpayType
          .fromJson(serializer.fromJson<String>(json['payType'])),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      tradeId: serializer.fromJson<int?>(json['tradeId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<int?>(serverId),
      'amount': serializer.toJson<double>(amount),
      'description': serializer.toJson<String?>(description),
      'income': serializer.toJson<bool>(income),
      'payType': serializer
          .toJson<String>($TransactionsTable.$converterpayType.toJson(payType)),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'tradeId': serializer.toJson<int?>(tradeId),
    };
  }

  Transaction copyWith(
          {int? id,
          Value<int?> serverId = const Value.absent(),
          double? amount,
          Value<String?> description = const Value.absent(),
          bool? income,
          InvoiceType? payType,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> syncedAt = const Value.absent(),
          bool? isSynced,
          Value<int?> tradeId = const Value.absent()}) =>
      Transaction(
        id: id ?? this.id,
        serverId: serverId.present ? serverId.value : this.serverId,
        amount: amount ?? this.amount,
        description: description.present ? description.value : this.description,
        income: income ?? this.income,
        payType: payType ?? this.payType,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        isSynced: isSynced ?? this.isSynced,
        tradeId: tradeId.present ? tradeId.value : this.tradeId,
      );
  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('income: $income, ')
          ..write('payType: $payType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('tradeId: $tradeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, serverId, amount, description, income,
      payType, createdAt, updatedAt, syncedAt, isSynced, tradeId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.amount == this.amount &&
          other.description == this.description &&
          other.income == this.income &&
          other.payType == this.payType &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt &&
          other.isSynced == this.isSynced &&
          other.tradeId == this.tradeId);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<int?> serverId;
  final Value<double> amount;
  final Value<String?> description;
  final Value<bool> income;
  final Value<InvoiceType> payType;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<bool> isSynced;
  final Value<int?> tradeId;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.amount = const Value.absent(),
    this.description = const Value.absent(),
    this.income = const Value.absent(),
    this.payType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.tradeId = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    required double amount,
    this.description = const Value.absent(),
    required bool income,
    required InvoiceType payType,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.tradeId = const Value.absent(),
  })  : amount = Value(amount),
        income = Value(income),
        payType = Value(payType),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<int>? serverId,
    Expression<double>? amount,
    Expression<String>? description,
    Expression<bool>? income,
    Expression<String>? payType,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<bool>? isSynced,
    Expression<int>? tradeId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (amount != null) 'amount': amount,
      if (description != null) 'description': description,
      if (income != null) 'income': income,
      if (payType != null) 'pay_type': payType,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (tradeId != null) 'trade_id': tradeId,
    });
  }

  TransactionsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? serverId,
      Value<double>? amount,
      Value<String?>? description,
      Value<bool>? income,
      Value<InvoiceType>? payType,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? syncedAt,
      Value<bool>? isSynced,
      Value<int?>? tradeId}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      income: income ?? this.income,
      payType: payType ?? this.payType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      isSynced: isSynced ?? this.isSynced,
      tradeId: tradeId ?? this.tradeId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (income.present) {
      map['income'] = Variable<bool>(income.value);
    }
    if (payType.present) {
      final converter = $TransactionsTable.$converterpayType;

      map['pay_type'] = Variable<String>(converter.toSql(payType.value));
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (tradeId.present) {
      map['trade_id'] = Variable<int>(tradeId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('income: $income, ')
          ..write('payType: $payType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('tradeId: $tradeId')
          ..write(')'))
        .toString();
  }
}

class $TradeProductTable extends TradeProduct
    with TableInfo<$TradeProductTable, TradeProductData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TradeProductTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES product (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _priceNameMeta =
      const VerificationMeta('priceName');
  @override
  late final GeneratedColumn<String> priceName = GeneratedColumn<String>(
      'price_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _discountMeta =
      const VerificationMeta('discount');
  @override
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
      'discount', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tradeIdMeta =
      const VerificationMeta('tradeId');
  @override
  late final GeneratedColumn<int> tradeId = GeneratedColumn<int>(
      'trade_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES trade (id)'));
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
      'server_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        productId,
        amount,
        price,
        priceName,
        discount,
        unit,
        tradeId,
        serverId,
        isSynced,
        syncedAt,
        updatedAt,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trade_product';
  @override
  VerificationContext validateIntegrity(Insertable<TradeProductData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('price_name')) {
      context.handle(_priceNameMeta,
          priceName.isAcceptableOrUnknown(data['price_name']!, _priceNameMeta));
    }
    if (data.containsKey('discount')) {
      context.handle(_discountMeta,
          discount.isAcceptableOrUnknown(data['discount']!, _discountMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('trade_id')) {
      context.handle(_tradeIdMeta,
          tradeId.isAcceptableOrUnknown(data['trade_id']!, _tradeIdMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TradeProductData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TradeProductData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      priceName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}price_name']),
      discount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}discount']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      tradeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}trade_id']),
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_id']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TradeProductTable createAlias(String alias) {
    return $TradeProductTable(attachedDatabase, alias);
  }
}

class TradeProductData extends DataClass
    implements Insertable<TradeProductData> {
  final int id;
  final int productId;
  final double amount;
  final double price;
  final String? priceName;
  final double? discount;
  final String unit;
  final int? tradeId;
  final int? serverId;
  final bool isSynced;
  final DateTime? syncedAt;
  final DateTime updatedAt;
  final DateTime createdAt;
  const TradeProductData(
      {required this.id,
      required this.productId,
      required this.amount,
      required this.price,
      this.priceName,
      this.discount,
      required this.unit,
      this.tradeId,
      this.serverId,
      required this.isSynced,
      this.syncedAt,
      required this.updatedAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['amount'] = Variable<double>(amount);
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || priceName != null) {
      map['price_name'] = Variable<String>(priceName);
    }
    if (!nullToAbsent || discount != null) {
      map['discount'] = Variable<double>(discount);
    }
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || tradeId != null) {
      map['trade_id'] = Variable<int>(tradeId);
    }
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TradeProductCompanion toCompanion(bool nullToAbsent) {
    return TradeProductCompanion(
      id: Value(id),
      productId: Value(productId),
      amount: Value(amount),
      price: Value(price),
      priceName: priceName == null && nullToAbsent
          ? const Value.absent()
          : Value(priceName),
      discount: discount == null && nullToAbsent
          ? const Value.absent()
          : Value(discount),
      unit: Value(unit),
      tradeId: tradeId == null && nullToAbsent
          ? const Value.absent()
          : Value(tradeId),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      isSynced: Value(isSynced),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
    );
  }

  factory TradeProductData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TradeProductData(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      amount: serializer.fromJson<double>(json['amount']),
      price: serializer.fromJson<double>(json['price']),
      priceName: serializer.fromJson<String?>(json['priceName']),
      discount: serializer.fromJson<double?>(json['discount']),
      unit: serializer.fromJson<String>(json['unit']),
      tradeId: serializer.fromJson<int?>(json['tradeId']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'amount': serializer.toJson<double>(amount),
      'price': serializer.toJson<double>(price),
      'priceName': serializer.toJson<String?>(priceName),
      'discount': serializer.toJson<double?>(discount),
      'unit': serializer.toJson<String>(unit),
      'tradeId': serializer.toJson<int?>(tradeId),
      'serverId': serializer.toJson<int?>(serverId),
      'isSynced': serializer.toJson<bool>(isSynced),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TradeProductData copyWith(
          {int? id,
          int? productId,
          double? amount,
          double? price,
          Value<String?> priceName = const Value.absent(),
          Value<double?> discount = const Value.absent(),
          String? unit,
          Value<int?> tradeId = const Value.absent(),
          Value<int?> serverId = const Value.absent(),
          bool? isSynced,
          Value<DateTime?> syncedAt = const Value.absent(),
          DateTime? updatedAt,
          DateTime? createdAt}) =>
      TradeProductData(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        amount: amount ?? this.amount,
        price: price ?? this.price,
        priceName: priceName.present ? priceName.value : this.priceName,
        discount: discount.present ? discount.value : this.discount,
        unit: unit ?? this.unit,
        tradeId: tradeId.present ? tradeId.value : this.tradeId,
        serverId: serverId.present ? serverId.value : this.serverId,
        isSynced: isSynced ?? this.isSynced,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('TradeProductData(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('amount: $amount, ')
          ..write('price: $price, ')
          ..write('priceName: $priceName, ')
          ..write('discount: $discount, ')
          ..write('unit: $unit, ')
          ..write('tradeId: $tradeId, ')
          ..write('serverId: $serverId, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      productId,
      amount,
      price,
      priceName,
      discount,
      unit,
      tradeId,
      serverId,
      isSynced,
      syncedAt,
      updatedAt,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TradeProductData &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.amount == this.amount &&
          other.price == this.price &&
          other.priceName == this.priceName &&
          other.discount == this.discount &&
          other.unit == this.unit &&
          other.tradeId == this.tradeId &&
          other.serverId == this.serverId &&
          other.isSynced == this.isSynced &&
          other.syncedAt == this.syncedAt &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt);
}

class TradeProductCompanion extends UpdateCompanion<TradeProductData> {
  final Value<int> id;
  final Value<int> productId;
  final Value<double> amount;
  final Value<double> price;
  final Value<String?> priceName;
  final Value<double?> discount;
  final Value<String> unit;
  final Value<int?> tradeId;
  final Value<int?> serverId;
  final Value<bool> isSynced;
  final Value<DateTime?> syncedAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  const TradeProductCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.amount = const Value.absent(),
    this.price = const Value.absent(),
    this.priceName = const Value.absent(),
    this.discount = const Value.absent(),
    this.unit = const Value.absent(),
    this.tradeId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TradeProductCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required double amount,
    required double price,
    this.priceName = const Value.absent(),
    this.discount = const Value.absent(),
    required String unit,
    this.tradeId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    required DateTime updatedAt,
    required DateTime createdAt,
  })  : productId = Value(productId),
        amount = Value(amount),
        price = Value(price),
        unit = Value(unit),
        updatedAt = Value(updatedAt),
        createdAt = Value(createdAt);
  static Insertable<TradeProductData> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<double>? amount,
    Expression<double>? price,
    Expression<String>? priceName,
    Expression<double>? discount,
    Expression<String>? unit,
    Expression<int>? tradeId,
    Expression<int>? serverId,
    Expression<bool>? isSynced,
    Expression<DateTime>? syncedAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (amount != null) 'amount': amount,
      if (price != null) 'price': price,
      if (priceName != null) 'price_name': priceName,
      if (discount != null) 'discount': discount,
      if (unit != null) 'unit': unit,
      if (tradeId != null) 'trade_id': tradeId,
      if (serverId != null) 'server_id': serverId,
      if (isSynced != null) 'is_synced': isSynced,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TradeProductCompanion copyWith(
      {Value<int>? id,
      Value<int>? productId,
      Value<double>? amount,
      Value<double>? price,
      Value<String?>? priceName,
      Value<double?>? discount,
      Value<String>? unit,
      Value<int?>? tradeId,
      Value<int?>? serverId,
      Value<bool>? isSynced,
      Value<DateTime?>? syncedAt,
      Value<DateTime>? updatedAt,
      Value<DateTime>? createdAt}) {
    return TradeProductCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      amount: amount ?? this.amount,
      price: price ?? this.price,
      priceName: priceName ?? this.priceName,
      discount: discount ?? this.discount,
      unit: unit ?? this.unit,
      tradeId: tradeId ?? this.tradeId,
      serverId: serverId ?? this.serverId,
      isSynced: isSynced ?? this.isSynced,
      syncedAt: syncedAt ?? this.syncedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (priceName.present) {
      map['price_name'] = Variable<String>(priceName.value);
    }
    if (discount.present) {
      map['discount'] = Variable<double>(discount.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (tradeId.present) {
      map['trade_id'] = Variable<int>(tradeId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TradeProductCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('amount: $amount, ')
          ..write('price: $price, ')
          ..write('priceName: $priceName, ')
          ..write('discount: $discount, ')
          ..write('unit: $unit, ')
          ..write('tradeId: $tradeId, ')
          ..write('serverId: $serverId, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $BarcodeTable extends Barcode with TableInfo<$BarcodeTable, BarcodeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BarcodeTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES product (id)'));
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
      'server_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        productId,
        barcode,
        createdAt,
        updatedAt,
        syncedAt,
        isSynced,
        serverId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'barcode';
  @override
  VerificationContext validateIntegrity(Insertable<BarcodeData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    } else if (isInserting) {
      context.missing(_barcodeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BarcodeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BarcodeData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_id']),
    );
  }

  @override
  $BarcodeTable createAlias(String alias) {
    return $BarcodeTable(attachedDatabase, alias);
  }
}

class BarcodeData extends DataClass implements Insertable<BarcodeData> {
  final int id;
  final int productId;
  final String barcode;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? syncedAt;
  final bool isSynced;
  final int? serverId;
  const BarcodeData(
      {required this.id,
      required this.productId,
      required this.barcode,
      this.createdAt,
      this.updatedAt,
      this.syncedAt,
      required this.isSynced,
      this.serverId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['barcode'] = Variable<String>(barcode);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    return map;
  }

  BarcodeCompanion toCompanion(bool nullToAbsent) {
    return BarcodeCompanion(
      id: Value(id),
      productId: Value(productId),
      barcode: Value(barcode),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      isSynced: Value(isSynced),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
    );
  }

  factory BarcodeData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BarcodeData(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      barcode: serializer.fromJson<String>(json['barcode']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      serverId: serializer.fromJson<int?>(json['serverId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'barcode': serializer.toJson<String>(barcode),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'serverId': serializer.toJson<int?>(serverId),
    };
  }

  BarcodeData copyWith(
          {int? id,
          int? productId,
          String? barcode,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<DateTime?> syncedAt = const Value.absent(),
          bool? isSynced,
          Value<int?> serverId = const Value.absent()}) =>
      BarcodeData(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        barcode: barcode ?? this.barcode,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        isSynced: isSynced ?? this.isSynced,
        serverId: serverId.present ? serverId.value : this.serverId,
      );
  @override
  String toString() {
    return (StringBuffer('BarcodeData(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('barcode: $barcode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productId, barcode, createdAt, updatedAt,
      syncedAt, isSynced, serverId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BarcodeData &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.barcode == this.barcode &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt &&
          other.isSynced == this.isSynced &&
          other.serverId == this.serverId);
}

class BarcodeCompanion extends UpdateCompanion<BarcodeData> {
  final Value<int> id;
  final Value<int> productId;
  final Value<String> barcode;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<bool> isSynced;
  final Value<int?> serverId;
  const BarcodeCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.barcode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.serverId = const Value.absent(),
  });
  BarcodeCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required String barcode,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.serverId = const Value.absent(),
  })  : productId = Value(productId),
        barcode = Value(barcode);
  static Insertable<BarcodeData> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<String>? barcode,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<bool>? isSynced,
    Expression<int>? serverId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (barcode != null) 'barcode': barcode,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (serverId != null) 'server_id': serverId,
    });
  }

  BarcodeCompanion copyWith(
      {Value<int>? id,
      Value<int>? productId,
      Value<String>? barcode,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<DateTime?>? syncedAt,
      Value<bool>? isSynced,
      Value<int?>? serverId}) {
    return BarcodeCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      barcode: barcode ?? this.barcode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      isSynced: isSynced ?? this.isSynced,
      serverId: serverId ?? this.serverId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BarcodeCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('barcode: $barcode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }
}

class $ProductKitTable extends ProductKit
    with TableInfo<$ProductKitTable, ProductKitData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductKitTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES product (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
      'server_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        productId,
        amount,
        price,
        createdAt,
        updatedAt,
        isSynced,
        syncedAt,
        serverId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_kit';
  @override
  VerificationContext validateIntegrity(Insertable<ProductKitData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductKitData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductKitData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_id']),
    );
  }

  @override
  $ProductKitTable createAlias(String alias) {
    return $ProductKitTable(attachedDatabase, alias);
  }
}

class ProductKitData extends DataClass implements Insertable<ProductKitData> {
  final int id;
  final int productId;
  final double amount;
  final double price;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isSynced;
  final DateTime? syncedAt;
  final int? serverId;
  const ProductKitData(
      {required this.id,
      required this.productId,
      required this.amount,
      required this.price,
      this.createdAt,
      this.updatedAt,
      required this.isSynced,
      this.syncedAt,
      this.serverId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['amount'] = Variable<double>(amount);
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    return map;
  }

  ProductKitCompanion toCompanion(bool nullToAbsent) {
    return ProductKitCompanion(
      id: Value(id),
      productId: Value(productId),
      amount: Value(amount),
      price: Value(price),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      isSynced: Value(isSynced),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
    );
  }

  factory ProductKitData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductKitData(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      amount: serializer.fromJson<double>(json['amount']),
      price: serializer.fromJson<double>(json['price']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      serverId: serializer.fromJson<int?>(json['serverId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'amount': serializer.toJson<double>(amount),
      'price': serializer.toJson<double>(price),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'serverId': serializer.toJson<int?>(serverId),
    };
  }

  ProductKitData copyWith(
          {int? id,
          int? productId,
          double? amount,
          double? price,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          bool? isSynced,
          Value<DateTime?> syncedAt = const Value.absent(),
          Value<int?> serverId = const Value.absent()}) =>
      ProductKitData(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        amount: amount ?? this.amount,
        price: price ?? this.price,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        isSynced: isSynced ?? this.isSynced,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        serverId: serverId.present ? serverId.value : this.serverId,
      );
  @override
  String toString() {
    return (StringBuffer('ProductKitData(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('amount: $amount, ')
          ..write('price: $price, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productId, amount, price, createdAt,
      updatedAt, isSynced, syncedAt, serverId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductKitData &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.amount == this.amount &&
          other.price == this.price &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.syncedAt == this.syncedAt &&
          other.serverId == this.serverId);
}

class ProductKitCompanion extends UpdateCompanion<ProductKitData> {
  final Value<int> id;
  final Value<int> productId;
  final Value<double> amount;
  final Value<double> price;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<bool> isSynced;
  final Value<DateTime?> syncedAt;
  final Value<int?> serverId;
  const ProductKitCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.amount = const Value.absent(),
    this.price = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.serverId = const Value.absent(),
  });
  ProductKitCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required double amount,
    required double price,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.serverId = const Value.absent(),
  })  : productId = Value(productId),
        amount = Value(amount),
        price = Value(price);
  static Insertable<ProductKitData> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<double>? amount,
    Expression<double>? price,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<DateTime>? syncedAt,
    Expression<int>? serverId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (amount != null) 'amount': amount,
      if (price != null) 'price': price,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (serverId != null) 'server_id': serverId,
    });
  }

  ProductKitCompanion copyWith(
      {Value<int>? id,
      Value<int>? productId,
      Value<double>? amount,
      Value<double>? price,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<bool>? isSynced,
      Value<DateTime?>? syncedAt,
      Value<int?>? serverId}) {
    return ProductKitCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      amount: amount ?? this.amount,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      syncedAt: syncedAt ?? this.syncedAt,
      serverId: serverId ?? this.serverId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductKitCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('amount: $amount, ')
          ..write('price: $price, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }
}

class $SeasonTable extends Season with TableInfo<$SeasonTable, SeasonData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SeasonTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
      'server_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        startDate,
        endDate,
        createdAt,
        updatedAt,
        syncedAt,
        isSynced,
        serverId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'season';
  @override
  VerificationContext validateIntegrity(Insertable<SeasonData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SeasonData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SeasonData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_id']),
    );
  }

  @override
  $SeasonTable createAlias(String alias) {
    return $SeasonTable(attachedDatabase, alias);
  }
}

class SeasonData extends DataClass implements Insertable<SeasonData> {
  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  final bool isSynced;
  final int? serverId;
  const SeasonData(
      {required this.id,
      required this.name,
      required this.startDate,
      required this.endDate,
      required this.createdAt,
      required this.updatedAt,
      this.syncedAt,
      required this.isSynced,
      this.serverId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    return map;
  }

  SeasonCompanion toCompanion(bool nullToAbsent) {
    return SeasonCompanion(
      id: Value(id),
      name: Value(name),
      startDate: Value(startDate),
      endDate: Value(endDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      isSynced: Value(isSynced),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
    );
  }

  factory SeasonData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SeasonData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      serverId: serializer.fromJson<int?>(json['serverId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'serverId': serializer.toJson<int?>(serverId),
    };
  }

  SeasonData copyWith(
          {int? id,
          String? name,
          DateTime? startDate,
          DateTime? endDate,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> syncedAt = const Value.absent(),
          bool? isSynced,
          Value<int?> serverId = const Value.absent()}) =>
      SeasonData(
        id: id ?? this.id,
        name: name ?? this.name,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        isSynced: isSynced ?? this.isSynced,
        serverId: serverId.present ? serverId.value : this.serverId,
      );
  @override
  String toString() {
    return (StringBuffer('SeasonData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, startDate, endDate, createdAt,
      updatedAt, syncedAt, isSynced, serverId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SeasonData &&
          other.id == this.id &&
          other.name == this.name &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt &&
          other.isSynced == this.isSynced &&
          other.serverId == this.serverId);
}

class SeasonCompanion extends UpdateCompanion<SeasonData> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<bool> isSynced;
  final Value<int?> serverId;
  const SeasonCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.serverId = const Value.absent(),
  });
  SeasonCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.serverId = const Value.absent(),
  })  : name = Value(name),
        startDate = Value(startDate),
        endDate = Value(endDate),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<SeasonData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<bool>? isSynced,
    Expression<int>? serverId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (serverId != null) 'server_id': serverId,
    });
  }

  SeasonCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<DateTime>? startDate,
      Value<DateTime>? endDate,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? syncedAt,
      Value<bool>? isSynced,
      Value<int?>? serverId}) {
    return SeasonCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      isSynced: isSynced ?? this.isSynced,
      serverId: serverId ?? this.serverId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SeasonCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }
}

class $ProductWithSeasonTable extends ProductWithSeason
    with TableInfo<$ProductWithSeasonTable, ProductWithSeasonData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductWithSeasonTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES product (id)'));
  static const VerificationMeta _seasonIdMeta =
      const VerificationMeta('seasonId');
  @override
  late final GeneratedColumn<int> seasonId = GeneratedColumn<int>(
      'season_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES season (id)'));
  @override
  List<GeneratedColumn> get $columns => [productId, seasonId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_with_season';
  @override
  VerificationContext validateIntegrity(
      Insertable<ProductWithSeasonData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    }
    if (data.containsKey('season_id')) {
      context.handle(_seasonIdMeta,
          seasonId.isAcceptableOrUnknown(data['season_id']!, _seasonIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  ProductWithSeasonData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductWithSeasonData(
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id']),
      seasonId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}season_id']),
    );
  }

  @override
  $ProductWithSeasonTable createAlias(String alias) {
    return $ProductWithSeasonTable(attachedDatabase, alias);
  }
}

class ProductWithSeasonData extends DataClass
    implements Insertable<ProductWithSeasonData> {
  final int? productId;
  final int? seasonId;
  const ProductWithSeasonData({this.productId, this.seasonId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<int>(productId);
    }
    if (!nullToAbsent || seasonId != null) {
      map['season_id'] = Variable<int>(seasonId);
    }
    return map;
  }

  ProductWithSeasonCompanion toCompanion(bool nullToAbsent) {
    return ProductWithSeasonCompanion(
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      seasonId: seasonId == null && nullToAbsent
          ? const Value.absent()
          : Value(seasonId),
    );
  }

  factory ProductWithSeasonData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductWithSeasonData(
      productId: serializer.fromJson<int?>(json['productId']),
      seasonId: serializer.fromJson<int?>(json['seasonId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productId': serializer.toJson<int?>(productId),
      'seasonId': serializer.toJson<int?>(seasonId),
    };
  }

  ProductWithSeasonData copyWith(
          {Value<int?> productId = const Value.absent(),
          Value<int?> seasonId = const Value.absent()}) =>
      ProductWithSeasonData(
        productId: productId.present ? productId.value : this.productId,
        seasonId: seasonId.present ? seasonId.value : this.seasonId,
      );
  @override
  String toString() {
    return (StringBuffer('ProductWithSeasonData(')
          ..write('productId: $productId, ')
          ..write('seasonId: $seasonId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(productId, seasonId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductWithSeasonData &&
          other.productId == this.productId &&
          other.seasonId == this.seasonId);
}

class ProductWithSeasonCompanion
    extends UpdateCompanion<ProductWithSeasonData> {
  final Value<int?> productId;
  final Value<int?> seasonId;
  final Value<int> rowid;
  const ProductWithSeasonCompanion({
    this.productId = const Value.absent(),
    this.seasonId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductWithSeasonCompanion.insert({
    this.productId = const Value.absent(),
    this.seasonId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<ProductWithSeasonData> custom({
    Expression<int>? productId,
    Expression<int>? seasonId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (productId != null) 'product_id': productId,
      if (seasonId != null) 'season_id': seasonId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductWithSeasonCompanion copyWith(
      {Value<int?>? productId, Value<int?>? seasonId, Value<int>? rowid}) {
    return ProductWithSeasonCompanion(
      productId: productId ?? this.productId,
      seasonId: seasonId ?? this.seasonId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (seasonId.present) {
      map['season_id'] = Variable<int>(seasonId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductWithSeasonCompanion(')
          ..write('productId: $productId, ')
          ..write('seasonId: $seasonId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(e);
  late final $RegionTable region = $RegionTable(this);
  late final $ClientTable client = $ClientTable(this);
  late final $CategoryTable category = $CategoryTable(this);
  late final $ProductTable product = $ProductTable(this);
  late final $ProductIncomeTable productIncome = $ProductIncomeTable(this);
  late final $CurrencyTableTable currencyTable = $CurrencyTableTable(this);
  late final $PriceTable price = $PriceTable(this);
  late final $EmployeeTable employee = $EmployeeTable(this);
  late final $POSTable pos = $POSTable(this);
  late final $PosSessionTable posSession = $PosSessionTable(this);
  late final $TradeTable trade = $TradeTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $TradeProductTable tradeProduct = $TradeProductTable(this);
  late final $BarcodeTable barcode = $BarcodeTable(this);
  late final $ProductKitTable productKit = $ProductKitTable(this);
  late final $SeasonTable season = $SeasonTable(this);
  late final $ProductWithSeasonTable productWithSeason =
      $ProductWithSeasonTable(this);
  late final ClientDao clientDao = ClientDao(this as MyDatabase);
  late final ProductDao productDao = ProductDao(this as MyDatabase);
  late final PriceDao priceDao = PriceDao(this as MyDatabase);
  late final EmployeeDao employeeDao = EmployeeDao(this as MyDatabase);
  late final PosSessionDao posSessionDao = PosSessionDao(this as MyDatabase);
  late final PosDao posDao = PosDao(this as MyDatabase);
  late final CategoryDao categoryDao = CategoryDao(this as MyDatabase);
  late final TransactionsDao transactionsDao =
      TransactionsDao(this as MyDatabase);
  late final TradeProductDao tradeProductDao =
      TradeProductDao(this as MyDatabase);
  late final TradeDao tradeDao = TradeDao(this as MyDatabase);
  late final BarcodeDao barcodeDao = BarcodeDao(this as MyDatabase);
  late final ProductKitDao productKitDao = ProductKitDao(this as MyDatabase);
  late final RegionDao regionDao = RegionDao(this as MyDatabase);
  late final SeasonDao seasonDao = SeasonDao(this as MyDatabase);
  late final ProductWithSeasonDao productWithSeasonDao =
      ProductWithSeasonDao(this as MyDatabase);
  late final CurrencyDao currencyDao = CurrencyDao(this as MyDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        region,
        client,
        category,
        product,
        productIncome,
        currencyTable,
        price,
        employee,
        pos,
        posSession,
        trade,
        transactions,
        tradeProduct,
        barcode,
        productKit,
        season,
        productWithSeason
      ];
}
