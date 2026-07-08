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

class $AnalysisResultsTable extends AnalysisResults
    with TableInfo<$AnalysisResultsTable, AnalysisResultRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnalysisResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _analyzedAtMsMeta = const VerificationMeta(
    'analyzedAtMs',
  );
  @override
  late final GeneratedColumn<int> analyzedAtMs = GeneratedColumn<int>(
    'analyzed_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isUnknownMeta = const VerificationMeta(
    'isUnknown',
  );
  @override
  late final GeneratedColumn<bool> isUnknown = GeneratedColumn<bool>(
    'is_unknown',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_unknown" IN (0, 1))',
    ),
  );
  static const VerificationMeta _sourceLabelMeta = const VerificationMeta(
    'sourceLabel',
  );
  @override
  late final GeneratedColumn<String> sourceLabel = GeneratedColumn<String>(
    'source_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reasonsJsonMeta = const VerificationMeta(
    'reasonsJson',
  );
  @override
  late final GeneratedColumn<String> reasonsJson = GeneratedColumn<String>(
    'reasons_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _ringerModeMeta = const VerificationMeta(
    'ringerMode',
  );
  @override
  late final GeneratedColumn<String> ringerMode = GeneratedColumn<String>(
    'ringer_mode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _screenOnMeta = const VerificationMeta(
    'screenOn',
  );
  @override
  late final GeneratedColumn<bool> screenOn = GeneratedColumn<bool>(
    'screen_on',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("screen_on" IN (0, 1))',
    ),
  );
  static const VerificationMeta _audioStreamLabelMeta = const VerificationMeta(
    'audioStreamLabel',
  );
  @override
  late final GeneratedColumn<String> audioStreamLabel = GeneratedColumn<String>(
    'audio_stream_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    analyzedAtMs,
    isUnknown,
    sourceLabel,
    packageName,
    confidence,
    reasonsJson,
    ringerMode,
    screenOn,
    audioStreamLabel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'analysis_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnalysisResultRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('analyzed_at_ms')) {
      context.handle(
        _analyzedAtMsMeta,
        analyzedAtMs.isAcceptableOrUnknown(
          data['analyzed_at_ms']!,
          _analyzedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_analyzedAtMsMeta);
    }
    if (data.containsKey('is_unknown')) {
      context.handle(
        _isUnknownMeta,
        isUnknown.isAcceptableOrUnknown(data['is_unknown']!, _isUnknownMeta),
      );
    } else if (isInserting) {
      context.missing(_isUnknownMeta);
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
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('reasons_json')) {
      context.handle(
        _reasonsJsonMeta,
        reasonsJson.isAcceptableOrUnknown(
          data['reasons_json']!,
          _reasonsJsonMeta,
        ),
      );
    }
    if (data.containsKey('ringer_mode')) {
      context.handle(
        _ringerModeMeta,
        ringerMode.isAcceptableOrUnknown(data['ringer_mode']!, _ringerModeMeta),
      );
    }
    if (data.containsKey('screen_on')) {
      context.handle(
        _screenOnMeta,
        screenOn.isAcceptableOrUnknown(data['screen_on']!, _screenOnMeta),
      );
    }
    if (data.containsKey('audio_stream_label')) {
      context.handle(
        _audioStreamLabelMeta,
        audioStreamLabel.isAcceptableOrUnknown(
          data['audio_stream_label']!,
          _audioStreamLabelMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnalysisResultRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnalysisResultRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      analyzedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}analyzed_at_ms'],
      )!,
      isUnknown: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_unknown'],
      )!,
      sourceLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_label'],
      ),
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      ),
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      ),
      reasonsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reasons_json'],
      )!,
      ringerMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ringer_mode'],
      ),
      screenOn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}screen_on'],
      ),
      audioStreamLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_stream_label'],
      ),
    );
  }

  @override
  $AnalysisResultsTable createAlias(String alias) {
    return $AnalysisResultsTable(attachedDatabase, alias);
  }
}

class AnalysisResultRow extends DataClass
    implements Insertable<AnalysisResultRow> {
  final int id;
  final int analyzedAtMs;
  final bool isUnknown;
  final String? sourceLabel;
  final String? packageName;
  final double? confidence;

  /// JSON-encoded list of reason strings.
  final String reasonsJson;
  final String? ringerMode;
  final bool? screenOn;
  final String? audioStreamLabel;
  const AnalysisResultRow({
    required this.id,
    required this.analyzedAtMs,
    required this.isUnknown,
    this.sourceLabel,
    this.packageName,
    this.confidence,
    required this.reasonsJson,
    this.ringerMode,
    this.screenOn,
    this.audioStreamLabel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['analyzed_at_ms'] = Variable<int>(analyzedAtMs);
    map['is_unknown'] = Variable<bool>(isUnknown);
    if (!nullToAbsent || sourceLabel != null) {
      map['source_label'] = Variable<String>(sourceLabel);
    }
    if (!nullToAbsent || packageName != null) {
      map['package_name'] = Variable<String>(packageName);
    }
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<double>(confidence);
    }
    map['reasons_json'] = Variable<String>(reasonsJson);
    if (!nullToAbsent || ringerMode != null) {
      map['ringer_mode'] = Variable<String>(ringerMode);
    }
    if (!nullToAbsent || screenOn != null) {
      map['screen_on'] = Variable<bool>(screenOn);
    }
    if (!nullToAbsent || audioStreamLabel != null) {
      map['audio_stream_label'] = Variable<String>(audioStreamLabel);
    }
    return map;
  }

  AnalysisResultsCompanion toCompanion(bool nullToAbsent) {
    return AnalysisResultsCompanion(
      id: Value(id),
      analyzedAtMs: Value(analyzedAtMs),
      isUnknown: Value(isUnknown),
      sourceLabel: sourceLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceLabel),
      packageName: packageName == null && nullToAbsent
          ? const Value.absent()
          : Value(packageName),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      reasonsJson: Value(reasonsJson),
      ringerMode: ringerMode == null && nullToAbsent
          ? const Value.absent()
          : Value(ringerMode),
      screenOn: screenOn == null && nullToAbsent
          ? const Value.absent()
          : Value(screenOn),
      audioStreamLabel: audioStreamLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(audioStreamLabel),
    );
  }

  factory AnalysisResultRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnalysisResultRow(
      id: serializer.fromJson<int>(json['id']),
      analyzedAtMs: serializer.fromJson<int>(json['analyzedAtMs']),
      isUnknown: serializer.fromJson<bool>(json['isUnknown']),
      sourceLabel: serializer.fromJson<String?>(json['sourceLabel']),
      packageName: serializer.fromJson<String?>(json['packageName']),
      confidence: serializer.fromJson<double?>(json['confidence']),
      reasonsJson: serializer.fromJson<String>(json['reasonsJson']),
      ringerMode: serializer.fromJson<String?>(json['ringerMode']),
      screenOn: serializer.fromJson<bool?>(json['screenOn']),
      audioStreamLabel: serializer.fromJson<String?>(json['audioStreamLabel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'analyzedAtMs': serializer.toJson<int>(analyzedAtMs),
      'isUnknown': serializer.toJson<bool>(isUnknown),
      'sourceLabel': serializer.toJson<String?>(sourceLabel),
      'packageName': serializer.toJson<String?>(packageName),
      'confidence': serializer.toJson<double?>(confidence),
      'reasonsJson': serializer.toJson<String>(reasonsJson),
      'ringerMode': serializer.toJson<String?>(ringerMode),
      'screenOn': serializer.toJson<bool?>(screenOn),
      'audioStreamLabel': serializer.toJson<String?>(audioStreamLabel),
    };
  }

  AnalysisResultRow copyWith({
    int? id,
    int? analyzedAtMs,
    bool? isUnknown,
    Value<String?> sourceLabel = const Value.absent(),
    Value<String?> packageName = const Value.absent(),
    Value<double?> confidence = const Value.absent(),
    String? reasonsJson,
    Value<String?> ringerMode = const Value.absent(),
    Value<bool?> screenOn = const Value.absent(),
    Value<String?> audioStreamLabel = const Value.absent(),
  }) => AnalysisResultRow(
    id: id ?? this.id,
    analyzedAtMs: analyzedAtMs ?? this.analyzedAtMs,
    isUnknown: isUnknown ?? this.isUnknown,
    sourceLabel: sourceLabel.present ? sourceLabel.value : this.sourceLabel,
    packageName: packageName.present ? packageName.value : this.packageName,
    confidence: confidence.present ? confidence.value : this.confidence,
    reasonsJson: reasonsJson ?? this.reasonsJson,
    ringerMode: ringerMode.present ? ringerMode.value : this.ringerMode,
    screenOn: screenOn.present ? screenOn.value : this.screenOn,
    audioStreamLabel: audioStreamLabel.present
        ? audioStreamLabel.value
        : this.audioStreamLabel,
  );
  AnalysisResultRow copyWithCompanion(AnalysisResultsCompanion data) {
    return AnalysisResultRow(
      id: data.id.present ? data.id.value : this.id,
      analyzedAtMs: data.analyzedAtMs.present
          ? data.analyzedAtMs.value
          : this.analyzedAtMs,
      isUnknown: data.isUnknown.present ? data.isUnknown.value : this.isUnknown,
      sourceLabel: data.sourceLabel.present
          ? data.sourceLabel.value
          : this.sourceLabel,
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      reasonsJson: data.reasonsJson.present
          ? data.reasonsJson.value
          : this.reasonsJson,
      ringerMode: data.ringerMode.present
          ? data.ringerMode.value
          : this.ringerMode,
      screenOn: data.screenOn.present ? data.screenOn.value : this.screenOn,
      audioStreamLabel: data.audioStreamLabel.present
          ? data.audioStreamLabel.value
          : this.audioStreamLabel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisResultRow(')
          ..write('id: $id, ')
          ..write('analyzedAtMs: $analyzedAtMs, ')
          ..write('isUnknown: $isUnknown, ')
          ..write('sourceLabel: $sourceLabel, ')
          ..write('packageName: $packageName, ')
          ..write('confidence: $confidence, ')
          ..write('reasonsJson: $reasonsJson, ')
          ..write('ringerMode: $ringerMode, ')
          ..write('screenOn: $screenOn, ')
          ..write('audioStreamLabel: $audioStreamLabel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    analyzedAtMs,
    isUnknown,
    sourceLabel,
    packageName,
    confidence,
    reasonsJson,
    ringerMode,
    screenOn,
    audioStreamLabel,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnalysisResultRow &&
          other.id == this.id &&
          other.analyzedAtMs == this.analyzedAtMs &&
          other.isUnknown == this.isUnknown &&
          other.sourceLabel == this.sourceLabel &&
          other.packageName == this.packageName &&
          other.confidence == this.confidence &&
          other.reasonsJson == this.reasonsJson &&
          other.ringerMode == this.ringerMode &&
          other.screenOn == this.screenOn &&
          other.audioStreamLabel == this.audioStreamLabel);
}

class AnalysisResultsCompanion extends UpdateCompanion<AnalysisResultRow> {
  final Value<int> id;
  final Value<int> analyzedAtMs;
  final Value<bool> isUnknown;
  final Value<String?> sourceLabel;
  final Value<String?> packageName;
  final Value<double?> confidence;
  final Value<String> reasonsJson;
  final Value<String?> ringerMode;
  final Value<bool?> screenOn;
  final Value<String?> audioStreamLabel;
  const AnalysisResultsCompanion({
    this.id = const Value.absent(),
    this.analyzedAtMs = const Value.absent(),
    this.isUnknown = const Value.absent(),
    this.sourceLabel = const Value.absent(),
    this.packageName = const Value.absent(),
    this.confidence = const Value.absent(),
    this.reasonsJson = const Value.absent(),
    this.ringerMode = const Value.absent(),
    this.screenOn = const Value.absent(),
    this.audioStreamLabel = const Value.absent(),
  });
  AnalysisResultsCompanion.insert({
    this.id = const Value.absent(),
    required int analyzedAtMs,
    required bool isUnknown,
    this.sourceLabel = const Value.absent(),
    this.packageName = const Value.absent(),
    this.confidence = const Value.absent(),
    this.reasonsJson = const Value.absent(),
    this.ringerMode = const Value.absent(),
    this.screenOn = const Value.absent(),
    this.audioStreamLabel = const Value.absent(),
  }) : analyzedAtMs = Value(analyzedAtMs),
       isUnknown = Value(isUnknown);
  static Insertable<AnalysisResultRow> custom({
    Expression<int>? id,
    Expression<int>? analyzedAtMs,
    Expression<bool>? isUnknown,
    Expression<String>? sourceLabel,
    Expression<String>? packageName,
    Expression<double>? confidence,
    Expression<String>? reasonsJson,
    Expression<String>? ringerMode,
    Expression<bool>? screenOn,
    Expression<String>? audioStreamLabel,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (analyzedAtMs != null) 'analyzed_at_ms': analyzedAtMs,
      if (isUnknown != null) 'is_unknown': isUnknown,
      if (sourceLabel != null) 'source_label': sourceLabel,
      if (packageName != null) 'package_name': packageName,
      if (confidence != null) 'confidence': confidence,
      if (reasonsJson != null) 'reasons_json': reasonsJson,
      if (ringerMode != null) 'ringer_mode': ringerMode,
      if (screenOn != null) 'screen_on': screenOn,
      if (audioStreamLabel != null) 'audio_stream_label': audioStreamLabel,
    });
  }

  AnalysisResultsCompanion copyWith({
    Value<int>? id,
    Value<int>? analyzedAtMs,
    Value<bool>? isUnknown,
    Value<String?>? sourceLabel,
    Value<String?>? packageName,
    Value<double?>? confidence,
    Value<String>? reasonsJson,
    Value<String?>? ringerMode,
    Value<bool?>? screenOn,
    Value<String?>? audioStreamLabel,
  }) {
    return AnalysisResultsCompanion(
      id: id ?? this.id,
      analyzedAtMs: analyzedAtMs ?? this.analyzedAtMs,
      isUnknown: isUnknown ?? this.isUnknown,
      sourceLabel: sourceLabel ?? this.sourceLabel,
      packageName: packageName ?? this.packageName,
      confidence: confidence ?? this.confidence,
      reasonsJson: reasonsJson ?? this.reasonsJson,
      ringerMode: ringerMode ?? this.ringerMode,
      screenOn: screenOn ?? this.screenOn,
      audioStreamLabel: audioStreamLabel ?? this.audioStreamLabel,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (analyzedAtMs.present) {
      map['analyzed_at_ms'] = Variable<int>(analyzedAtMs.value);
    }
    if (isUnknown.present) {
      map['is_unknown'] = Variable<bool>(isUnknown.value);
    }
    if (sourceLabel.present) {
      map['source_label'] = Variable<String>(sourceLabel.value);
    }
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (reasonsJson.present) {
      map['reasons_json'] = Variable<String>(reasonsJson.value);
    }
    if (ringerMode.present) {
      map['ringer_mode'] = Variable<String>(ringerMode.value);
    }
    if (screenOn.present) {
      map['screen_on'] = Variable<bool>(screenOn.value);
    }
    if (audioStreamLabel.present) {
      map['audio_stream_label'] = Variable<String>(audioStreamLabel.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisResultsCompanion(')
          ..write('id: $id, ')
          ..write('analyzedAtMs: $analyzedAtMs, ')
          ..write('isUnknown: $isUnknown, ')
          ..write('sourceLabel: $sourceLabel, ')
          ..write('packageName: $packageName, ')
          ..write('confidence: $confidence, ')
          ..write('reasonsJson: $reasonsJson, ')
          ..write('ringerMode: $ringerMode, ')
          ..write('screenOn: $screenOn, ')
          ..write('audioStreamLabel: $audioStreamLabel')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EventsTable events = $EventsTable(this);
  late final $AnalysisResultsTable analysisResults = $AnalysisResultsTable(
    this,
  );
  late final EventDao eventDao = EventDao(this as AppDatabase);
  late final AnalysisResultDao analysisResultDao = AnalysisResultDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [events, analysisResults];
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
typedef $$AnalysisResultsTableCreateCompanionBuilder =
    AnalysisResultsCompanion Function({
      Value<int> id,
      required int analyzedAtMs,
      required bool isUnknown,
      Value<String?> sourceLabel,
      Value<String?> packageName,
      Value<double?> confidence,
      Value<String> reasonsJson,
      Value<String?> ringerMode,
      Value<bool?> screenOn,
      Value<String?> audioStreamLabel,
    });
typedef $$AnalysisResultsTableUpdateCompanionBuilder =
    AnalysisResultsCompanion Function({
      Value<int> id,
      Value<int> analyzedAtMs,
      Value<bool> isUnknown,
      Value<String?> sourceLabel,
      Value<String?> packageName,
      Value<double?> confidence,
      Value<String> reasonsJson,
      Value<String?> ringerMode,
      Value<bool?> screenOn,
      Value<String?> audioStreamLabel,
    });

class $$AnalysisResultsTableFilterComposer
    extends Composer<_$AppDatabase, $AnalysisResultsTable> {
  $$AnalysisResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get analyzedAtMs => $composableBuilder(
    column: $table.analyzedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isUnknown => $composableBuilder(
    column: $table.isUnknown,
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

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasonsJson => $composableBuilder(
    column: $table.reasonsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ringerMode => $composableBuilder(
    column: $table.ringerMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get screenOn => $composableBuilder(
    column: $table.screenOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioStreamLabel => $composableBuilder(
    column: $table.audioStreamLabel,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AnalysisResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $AnalysisResultsTable> {
  $$AnalysisResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get analyzedAtMs => $composableBuilder(
    column: $table.analyzedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isUnknown => $composableBuilder(
    column: $table.isUnknown,
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

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasonsJson => $composableBuilder(
    column: $table.reasonsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ringerMode => $composableBuilder(
    column: $table.ringerMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get screenOn => $composableBuilder(
    column: $table.screenOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioStreamLabel => $composableBuilder(
    column: $table.audioStreamLabel,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AnalysisResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnalysisResultsTable> {
  $$AnalysisResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get analyzedAtMs => $composableBuilder(
    column: $table.analyzedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isUnknown =>
      $composableBuilder(column: $table.isUnknown, builder: (column) => column);

  GeneratedColumn<String> get sourceLabel => $composableBuilder(
    column: $table.sourceLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reasonsJson => $composableBuilder(
    column: $table.reasonsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ringerMode => $composableBuilder(
    column: $table.ringerMode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get screenOn =>
      $composableBuilder(column: $table.screenOn, builder: (column) => column);

  GeneratedColumn<String> get audioStreamLabel => $composableBuilder(
    column: $table.audioStreamLabel,
    builder: (column) => column,
  );
}

class $$AnalysisResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnalysisResultsTable,
          AnalysisResultRow,
          $$AnalysisResultsTableFilterComposer,
          $$AnalysisResultsTableOrderingComposer,
          $$AnalysisResultsTableAnnotationComposer,
          $$AnalysisResultsTableCreateCompanionBuilder,
          $$AnalysisResultsTableUpdateCompanionBuilder,
          (
            AnalysisResultRow,
            BaseReferences<
              _$AppDatabase,
              $AnalysisResultsTable,
              AnalysisResultRow
            >,
          ),
          AnalysisResultRow,
          PrefetchHooks Function()
        > {
  $$AnalysisResultsTableTableManager(
    _$AppDatabase db,
    $AnalysisResultsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnalysisResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnalysisResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnalysisResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> analyzedAtMs = const Value.absent(),
                Value<bool> isUnknown = const Value.absent(),
                Value<String?> sourceLabel = const Value.absent(),
                Value<String?> packageName = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<String> reasonsJson = const Value.absent(),
                Value<String?> ringerMode = const Value.absent(),
                Value<bool?> screenOn = const Value.absent(),
                Value<String?> audioStreamLabel = const Value.absent(),
              }) => AnalysisResultsCompanion(
                id: id,
                analyzedAtMs: analyzedAtMs,
                isUnknown: isUnknown,
                sourceLabel: sourceLabel,
                packageName: packageName,
                confidence: confidence,
                reasonsJson: reasonsJson,
                ringerMode: ringerMode,
                screenOn: screenOn,
                audioStreamLabel: audioStreamLabel,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int analyzedAtMs,
                required bool isUnknown,
                Value<String?> sourceLabel = const Value.absent(),
                Value<String?> packageName = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<String> reasonsJson = const Value.absent(),
                Value<String?> ringerMode = const Value.absent(),
                Value<bool?> screenOn = const Value.absent(),
                Value<String?> audioStreamLabel = const Value.absent(),
              }) => AnalysisResultsCompanion.insert(
                id: id,
                analyzedAtMs: analyzedAtMs,
                isUnknown: isUnknown,
                sourceLabel: sourceLabel,
                packageName: packageName,
                confidence: confidence,
                reasonsJson: reasonsJson,
                ringerMode: ringerMode,
                screenOn: screenOn,
                audioStreamLabel: audioStreamLabel,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AnalysisResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnalysisResultsTable,
      AnalysisResultRow,
      $$AnalysisResultsTableFilterComposer,
      $$AnalysisResultsTableOrderingComposer,
      $$AnalysisResultsTableAnnotationComposer,
      $$AnalysisResultsTableCreateCompanionBuilder,
      $$AnalysisResultsTableUpdateCompanionBuilder,
      (
        AnalysisResultRow,
        BaseReferences<_$AppDatabase, $AnalysisResultsTable, AnalysisResultRow>,
      ),
      AnalysisResultRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$AnalysisResultsTableTableManager get analysisResults =>
      $$AnalysisResultsTableTableManager(_db, _db.analysisResults);
}
