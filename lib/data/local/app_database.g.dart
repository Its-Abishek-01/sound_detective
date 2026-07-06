// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $EventsTable extends Events with TableInfo<$EventsTable, Event> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMsMeta = const VerificationMeta(
    'timestampMs',
  );
  @override
  late final GeneratedColumn<int> timestampMs = GeneratedColumn<int>(
    'timestamp_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tierMeta = const VerificationMeta('tier');
  @override
  late final GeneratedColumn<String> tier = GeneratedColumn<String>(
    'tier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtypeMeta = const VerificationMeta(
    'subtype',
  );
  @override
  late final GeneratedColumn<String> subtype = GeneratedColumn<String>(
    'subtype',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _sourceLabelMeta = const VerificationMeta(
    'sourceLabel',
  );
  @override
  late final GeneratedColumn<String> sourceLabel = GeneratedColumn<String>(
    'source_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _packageNameMeta = const VerificationMeta(
    'packageName',
  );
  @override
  late final GeneratedColumn<String> packageName = GeneratedColumn<String>(
    'package_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _appNameMeta = const VerificationMeta(
    'appName',
  );
  @override
  late final GeneratedColumn<String> appName = GeneratedColumn<String>(
    'app_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _metadataJsonMeta = const VerificationMeta(
    'metadataJson',
  );
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
    'metadata_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _confidenceWeightMeta = const VerificationMeta(
    'confidenceWeight',
  );
  @override
  late final GeneratedColumn<double> confidenceWeight = GeneratedColumn<double>(
    'confidence_weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestampMs,
    category,
    tier,
    subtype,
    sourceLabel,
    packageName,
    appName,
    metadataJson,
    confidenceWeight,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(
    Insertable<Event> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('timestamp_ms')) {
      context.handle(
        _timestampMsMeta,
        timestampMs.isAcceptableOrUnknown(
          data['timestamp_ms']!,
          _timestampMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_timestampMsMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('tier')) {
      context.handle(
        _tierMeta,
        tier.isAcceptableOrUnknown(data['tier']!, _tierMeta),
      );
    } else if (isInserting) {
      context.missing(_tierMeta);
    }
    if (data.containsKey('subtype')) {
      context.handle(
        _subtypeMeta,
        subtype.isAcceptableOrUnknown(data['subtype']!, _subtypeMeta),
      );
    }
    if (data.containsKey('source_label')) {
      context.handle(
        _sourceLabelMeta,
        sourceLabel.isAcceptableOrUnknown(
          data['source_label']!,
          _sourceLabelMeta,
        ),
      );
    }
    if (data.containsKey('package_name')) {
      context.handle(
        _packageNameMeta,
        packageName.isAcceptableOrUnknown(
          data['package_name']!,
          _packageNameMeta,
        ),
      );
    }
    if (data.containsKey('app_name')) {
      context.handle(
        _appNameMeta,
        appName.isAcceptableOrUnknown(data['app_name']!, _appNameMeta),
      );
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
        _metadataJsonMeta,
        metadataJson.isAcceptableOrUnknown(
          data['metadata_json']!,
          _metadataJsonMeta,
        ),
      );
    }
    if (data.containsKey('confidence_weight')) {
      context.handle(
        _confidenceWeightMeta,
        confidenceWeight.isAcceptableOrUnknown(
          data['confidence_weight']!,
          _confidenceWeightMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Event(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      timestampMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timestamp_ms'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      tier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tier'],
      )!,
      subtype: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtype'],
      )!,
      sourceLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_label'],
      )!,
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      ),
      appName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_name'],
      ),
      metadataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata_json'],
      )!,
      confidenceWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence_weight'],
      )!,
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }
}

class Event extends DataClass implements Insertable<Event> {
  final String id;
  final int timestampMs;
  final String category;
  final String tier;
  final String subtype;
  final String sourceLabel;
  final String? packageName;
  final String? appName;
  final String metadataJson;
  final double confidenceWeight;
  const Event({
    required this.id,
    required this.timestampMs,
    required this.category,
    required this.tier,
    required this.subtype,
    required this.sourceLabel,
    this.packageName,
    this.appName,
    required this.metadataJson,
    required this.confidenceWeight,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['timestamp_ms'] = Variable<int>(timestampMs);
    map['category'] = Variable<String>(category);
    map['tier'] = Variable<String>(tier);
    map['subtype'] = Variable<String>(subtype);
    map['source_label'] = Variable<String>(sourceLabel);
    if (!nullToAbsent || packageName != null) {
      map['package_name'] = Variable<String>(packageName);
    }
    if (!nullToAbsent || appName != null) {
      map['app_name'] = Variable<String>(appName);
    }
    map['metadata_json'] = Variable<String>(metadataJson);
    map['confidence_weight'] = Variable<double>(confidenceWeight);
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      timestampMs: Value(timestampMs),
      category: Value(category),
      tier: Value(tier),
      subtype: Value(subtype),
      sourceLabel: Value(sourceLabel),
      packageName: packageName == null && nullToAbsent
          ? const Value.absent()
          : Value(packageName),
      appName: appName == null && nullToAbsent
          ? const Value.absent()
          : Value(appName),
      metadataJson: Value(metadataJson),
      confidenceWeight: Value(confidenceWeight),
    );
  }

  factory Event.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Event(
      id: serializer.fromJson<String>(json['id']),
      timestampMs: serializer.fromJson<int>(json['timestampMs']),
      category: serializer.fromJson<String>(json['category']),
      tier: serializer.fromJson<String>(json['tier']),
      subtype: serializer.fromJson<String>(json['subtype']),
      sourceLabel: serializer.fromJson<String>(json['sourceLabel']),
      packageName: serializer.fromJson<String?>(json['packageName']),
      appName: serializer.fromJson<String?>(json['appName']),
      metadataJson: serializer.fromJson<String>(json['metadataJson']),
      confidenceWeight: serializer.fromJson<double>(json['confidenceWeight']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'timestampMs': serializer.toJson<int>(timestampMs),
      'category': serializer.toJson<String>(category),
      'tier': serializer.toJson<String>(tier),
      'subtype': serializer.toJson<String>(subtype),
      'sourceLabel': serializer.toJson<String>(sourceLabel),
      'packageName': serializer.toJson<String?>(packageName),
      'appName': serializer.toJson<String?>(appName),
      'metadataJson': serializer.toJson<String>(metadataJson),
      'confidenceWeight': serializer.toJson<double>(confidenceWeight),
    };
  }

  Event copyWith({
    String? id,
    int? timestampMs,
    String? category,
    String? tier,
    String? subtype,
    String? sourceLabel,
    Value<String?> packageName = const Value.absent(),
    Value<String?> appName = const Value.absent(),
    String? metadataJson,
    double? confidenceWeight,
  }) => Event(
    id: id ?? this.id,
    timestampMs: timestampMs ?? this.timestampMs,
    category: category ?? this.category,
    tier: tier ?? this.tier,
    subtype: subtype ?? this.subtype,
    sourceLabel: sourceLabel ?? this.sourceLabel,
    packageName: packageName.present ? packageName.value : this.packageName,
    appName: appName.present ? appName.value : this.appName,
    metadataJson: metadataJson ?? this.metadataJson,
    confidenceWeight: confidenceWeight ?? this.confidenceWeight,
  );
  Event copyWithCompanion(EventsCompanion data) {
    return Event(
      id: data.id.present ? data.id.value : this.id,
      timestampMs: data.timestampMs.present
          ? data.timestampMs.value
          : this.timestampMs,
      category: data.category.present ? data.category.value : this.category,
      tier: data.tier.present ? data.tier.value : this.tier,
      subtype: data.subtype.present ? data.subtype.value : this.subtype,
      sourceLabel: data.sourceLabel.present
          ? data.sourceLabel.value
          : this.sourceLabel,
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
      appName: data.appName.present ? data.appName.value : this.appName,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
      confidenceWeight: data.confidenceWeight.present
          ? data.confidenceWeight.value
          : this.confidenceWeight,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('timestampMs: $timestampMs, ')
          ..write('category: $category, ')
          ..write('tier: $tier, ')
          ..write('subtype: $subtype, ')
          ..write('sourceLabel: $sourceLabel, ')
          ..write('packageName: $packageName, ')
          ..write('appName: $appName, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('confidenceWeight: $confidenceWeight')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    timestampMs,
    category,
    tier,
    subtype,
    sourceLabel,
    packageName,
    appName,
    metadataJson,
    confidenceWeight,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.timestampMs == this.timestampMs &&
          other.category == this.category &&
          other.tier == this.tier &&
          other.subtype == this.subtype &&
          other.sourceLabel == this.sourceLabel &&
          other.packageName == this.packageName &&
          other.appName == this.appName &&
          other.metadataJson == this.metadataJson &&
          other.confidenceWeight == this.confidenceWeight);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<String> id;
  final Value<int> timestampMs;
  final Value<String> category;
  final Value<String> tier;
  final Value<String> subtype;
  final Value<String> sourceLabel;
  final Value<String?> packageName;
  final Value<String?> appName;
  final Value<String> metadataJson;
  final Value<double> confidenceWeight;
  final Value<int> rowid;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.timestampMs = const Value.absent(),
    this.category = const Value.absent(),
    this.tier = const Value.absent(),
    this.subtype = const Value.absent(),
    this.sourceLabel = const Value.absent(),
    this.packageName = const Value.absent(),
    this.appName = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.confidenceWeight = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventsCompanion.insert({
    required String id,
    required int timestampMs,
    required String category,
    required String tier,
    this.subtype = const Value.absent(),
    this.sourceLabel = const Value.absent(),
    this.packageName = const Value.absent(),
    this.appName = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.confidenceWeight = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       timestampMs = Value(timestampMs),
       category = Value(category),
       tier = Value(tier);
  static Insertable<Event> custom({
    Expression<String>? id,
    Expression<int>? timestampMs,
    Expression<String>? category,
    Expression<String>? tier,
    Expression<String>? subtype,
    Expression<String>? sourceLabel,
    Expression<String>? packageName,
    Expression<String>? appName,
    Expression<String>? metadataJson,
    Expression<double>? confidenceWeight,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestampMs != null) 'timestamp_ms': timestampMs,
      if (category != null) 'category': category,
      if (tier != null) 'tier': tier,
      if (subtype != null) 'subtype': subtype,
      if (sourceLabel != null) 'source_label': sourceLabel,
      if (packageName != null) 'package_name': packageName,
      if (appName != null) 'app_name': appName,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (confidenceWeight != null) 'confidence_weight': confidenceWeight,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventsCompanion copyWith({
    Value<String>? id,
    Value<int>? timestampMs,
    Value<String>? category,
    Value<String>? tier,
    Value<String>? subtype,
    Value<String>? sourceLabel,
    Value<String?>? packageName,
    Value<String?>? appName,
    Value<String>? metadataJson,
    Value<double>? confidenceWeight,
    Value<int>? rowid,
  }) {
    return EventsCompanion(
      id: id ?? this.id,
      timestampMs: timestampMs ?? this.timestampMs,
      category: category ?? this.category,
      tier: tier ?? this.tier,
      subtype: subtype ?? this.subtype,
      sourceLabel: sourceLabel ?? this.sourceLabel,
      packageName: packageName ?? this.packageName,
      appName: appName ?? this.appName,
      metadataJson: metadataJson ?? this.metadataJson,
      confidenceWeight: confidenceWeight ?? this.confidenceWeight,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (timestampMs.present) {
      map['timestamp_ms'] = Variable<int>(timestampMs.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (tier.present) {
      map['tier'] = Variable<String>(tier.value);
    }
    if (subtype.present) {
      map['subtype'] = Variable<String>(subtype.value);
    }
    if (sourceLabel.present) {
      map['source_label'] = Variable<String>(sourceLabel.value);
    }
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    if (appName.present) {
      map['app_name'] = Variable<String>(appName.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (confidenceWeight.present) {
      map['confidence_weight'] = Variable<double>(confidenceWeight.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('timestampMs: $timestampMs, ')
          ..write('category: $category, ')
          ..write('tier: $tier, ')
          ..write('subtype: $subtype, ')
          ..write('sourceLabel: $sourceLabel, ')
          ..write('packageName: $packageName, ')
          ..write('appName: $appName, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('confidenceWeight: $confidenceWeight, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EventsTable events = $EventsTable(this);
  late final EventDao eventDao = EventDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [events];
}

typedef $$EventsTableCreateCompanionBuilder =
    EventsCompanion Function({
      required String id,
      required int timestampMs,
      required String category,
      required String tier,
      Value<String> subtype,
      Value<String> sourceLabel,
      Value<String?> packageName,
      Value<String?> appName,
      Value<String> metadataJson,
      Value<double> confidenceWeight,
      Value<int> rowid,
    });
typedef $$EventsTableUpdateCompanionBuilder =
    EventsCompanion Function({
      Value<String> id,
      Value<int> timestampMs,
      Value<String> category,
      Value<String> tier,
      Value<String> subtype,
      Value<String> sourceLabel,
      Value<String?> packageName,
      Value<String?> appName,
      Value<String> metadataJson,
      Value<double> confidenceWeight,
      Value<int> rowid,
    });

class $$EventsTableFilterComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timestampMs => $composableBuilder(
    column: $table.timestampMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subtype => $composableBuilder(
    column: $table.subtype,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceLabel => $composableBuilder(
    column: $table.sourceLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appName => $composableBuilder(
    column: $table.appName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidenceWeight => $composableBuilder(
    column: $table.confidenceWeight,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timestampMs => $composableBuilder(
    column: $table.timestampMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtype => $composableBuilder(
    column: $table.subtype,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceLabel => $composableBuilder(
    column: $table.sourceLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appName => $composableBuilder(
    column: $table.appName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidenceWeight => $composableBuilder(
    column: $table.confidenceWeight,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get timestampMs => $composableBuilder(
    column: $table.timestampMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get tier =>
      $composableBuilder(column: $table.tier, builder: (column) => column);

  GeneratedColumn<String> get subtype =>
      $composableBuilder(column: $table.subtype, builder: (column) => column);

  GeneratedColumn<String> get sourceLabel => $composableBuilder(
    column: $table.sourceLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appName =>
      $composableBuilder(column: $table.appName, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => column,
  );

  GeneratedColumn<double> get confidenceWeight => $composableBuilder(
    column: $table.confidenceWeight,
    builder: (column) => column,
  );
}

class $$EventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventsTable,
          Event,
          $$EventsTableFilterComposer,
          $$EventsTableOrderingComposer,
          $$EventsTableAnnotationComposer,
          $$EventsTableCreateCompanionBuilder,
          $$EventsTableUpdateCompanionBuilder,
          (Event, BaseReferences<_$AppDatabase, $EventsTable, Event>),
          Event,
          PrefetchHooks Function()
        > {
  $$EventsTableTableManager(_$AppDatabase db, $EventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> timestampMs = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> tier = const Value.absent(),
                Value<String> subtype = const Value.absent(),
                Value<String> sourceLabel = const Value.absent(),
                Value<String?> packageName = const Value.absent(),
                Value<String?> appName = const Value.absent(),
                Value<String> metadataJson = const Value.absent(),
                Value<double> confidenceWeight = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion(
                id: id,
                timestampMs: timestampMs,
                category: category,
                tier: tier,
                subtype: subtype,
                sourceLabel: sourceLabel,
                packageName: packageName,
                appName: appName,
                metadataJson: metadataJson,
                confidenceWeight: confidenceWeight,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int timestampMs,
                required String category,
                required String tier,
                Value<String> subtype = const Value.absent(),
                Value<String> sourceLabel = const Value.absent(),
                Value<String?> packageName = const Value.absent(),
                Value<String?> appName = const Value.absent(),
                Value<String> metadataJson = const Value.absent(),
                Value<double> confidenceWeight = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion.insert(
                id: id,
                timestampMs: timestampMs,
                category: category,
                tier: tier,
                subtype: subtype,
                sourceLabel: sourceLabel,
                packageName: packageName,
                appName: appName,
                metadataJson: metadataJson,
                confidenceWeight: confidenceWeight,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventsTable,
      Event,
      $$EventsTableFilterComposer,
      $$EventsTableOrderingComposer,
      $$EventsTableAnnotationComposer,
      $$EventsTableCreateCompanionBuilder,
      $$EventsTableUpdateCompanionBuilder,
      (Event, BaseReferences<_$AppDatabase, $EventsTable, Event>),
      Event,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
}
