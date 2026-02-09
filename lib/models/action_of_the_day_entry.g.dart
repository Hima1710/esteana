// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_of_the_day_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetActionOfTheDayEntryCollection on Isar {
  IsarCollection<ActionOfTheDayEntry> get actionOfTheDayEntrys =>
      this.collection();
}

const ActionOfTheDayEntrySchema = CollectionSchema(
  name: r'ActionOfTheDayEntry',
  id: 2215419532355133077,
  properties: {
    r'completed': PropertySchema(
      id: 0,
      name: r'completed',
      type: IsarType.bool,
    ),
    r'completedAt': PropertySchema(
      id: 1,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'dateKey': PropertySchema(
      id: 2,
      name: r'dateKey',
      type: IsarType.long,
    ),
    r'taskKey': PropertySchema(
      id: 3,
      name: r'taskKey',
      type: IsarType.string,
    ),
    r'titleAr': PropertySchema(
      id: 4,
      name: r'titleAr',
      type: IsarType.string,
    ),
    r'titleEn': PropertySchema(
      id: 5,
      name: r'titleEn',
      type: IsarType.string,
    )
  },
  estimateSize: _actionOfTheDayEntryEstimateSize,
  serialize: _actionOfTheDayEntrySerialize,
  deserialize: _actionOfTheDayEntryDeserialize,
  deserializeProp: _actionOfTheDayEntryDeserializeProp,
  idName: r'id',
  indexes: {
    r'dateKey': IndexSchema(
      id: 7975223786082927131,
      name: r'dateKey',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dateKey',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _actionOfTheDayEntryGetId,
  getLinks: _actionOfTheDayEntryGetLinks,
  attach: _actionOfTheDayEntryAttach,
  version: '3.1.0+1',
);

int _actionOfTheDayEntryEstimateSize(
  ActionOfTheDayEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.taskKey.length * 3;
  bytesCount += 3 + object.titleAr.length * 3;
  bytesCount += 3 + object.titleEn.length * 3;
  return bytesCount;
}

void _actionOfTheDayEntrySerialize(
  ActionOfTheDayEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.completed);
  writer.writeDateTime(offsets[1], object.completedAt);
  writer.writeLong(offsets[2], object.dateKey);
  writer.writeString(offsets[3], object.taskKey);
  writer.writeString(offsets[4], object.titleAr);
  writer.writeString(offsets[5], object.titleEn);
}

ActionOfTheDayEntry _actionOfTheDayEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ActionOfTheDayEntry();
  object.completed = reader.readBool(offsets[0]);
  object.completedAt = reader.readDateTimeOrNull(offsets[1]);
  object.dateKey = reader.readLong(offsets[2]);
  object.id = id;
  object.taskKey = reader.readString(offsets[3]);
  object.titleAr = reader.readString(offsets[4]);
  object.titleEn = reader.readString(offsets[5]);
  return object;
}

P _actionOfTheDayEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _actionOfTheDayEntryGetId(ActionOfTheDayEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _actionOfTheDayEntryGetLinks(
    ActionOfTheDayEntry object) {
  return [];
}

void _actionOfTheDayEntryAttach(
    IsarCollection<dynamic> col, Id id, ActionOfTheDayEntry object) {
  object.id = id;
}

extension ActionOfTheDayEntryByIndex on IsarCollection<ActionOfTheDayEntry> {
  Future<ActionOfTheDayEntry?> getByDateKey(int dateKey) {
    return getByIndex(r'dateKey', [dateKey]);
  }

  ActionOfTheDayEntry? getByDateKeySync(int dateKey) {
    return getByIndexSync(r'dateKey', [dateKey]);
  }

  Future<bool> deleteByDateKey(int dateKey) {
    return deleteByIndex(r'dateKey', [dateKey]);
  }

  bool deleteByDateKeySync(int dateKey) {
    return deleteByIndexSync(r'dateKey', [dateKey]);
  }

  Future<List<ActionOfTheDayEntry?>> getAllByDateKey(List<int> dateKeyValues) {
    final values = dateKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'dateKey', values);
  }

  List<ActionOfTheDayEntry?> getAllByDateKeySync(List<int> dateKeyValues) {
    final values = dateKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'dateKey', values);
  }

  Future<int> deleteAllByDateKey(List<int> dateKeyValues) {
    final values = dateKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'dateKey', values);
  }

  int deleteAllByDateKeySync(List<int> dateKeyValues) {
    final values = dateKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'dateKey', values);
  }

  Future<Id> putByDateKey(ActionOfTheDayEntry object) {
    return putByIndex(r'dateKey', object);
  }

  Id putByDateKeySync(ActionOfTheDayEntry object, {bool saveLinks = true}) {
    return putByIndexSync(r'dateKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDateKey(List<ActionOfTheDayEntry> objects) {
    return putAllByIndex(r'dateKey', objects);
  }

  List<Id> putAllByDateKeySync(List<ActionOfTheDayEntry> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'dateKey', objects, saveLinks: saveLinks);
  }
}

extension ActionOfTheDayEntryQueryWhereSort
    on QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QWhere> {
  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterWhere>
      anyDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateKey'),
      );
    });
  }
}

extension ActionOfTheDayEntryQueryWhere
    on QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QWhereClause> {
  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterWhereClause>
      dateKeyEqualTo(int dateKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dateKey',
        value: [dateKey],
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterWhereClause>
      dateKeyNotEqualTo(int dateKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateKey',
              lower: [],
              upper: [dateKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateKey',
              lower: [dateKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateKey',
              lower: [dateKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateKey',
              lower: [],
              upper: [dateKey],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterWhereClause>
      dateKeyGreaterThan(
    int dateKey, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateKey',
        lower: [dateKey],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterWhereClause>
      dateKeyLessThan(
    int dateKey, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateKey',
        lower: [],
        upper: [dateKey],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterWhereClause>
      dateKeyBetween(
    int lowerDateKey,
    int upperDateKey, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateKey',
        lower: [lowerDateKey],
        includeLower: includeLower,
        upper: [upperDateKey],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ActionOfTheDayEntryQueryFilter on QueryBuilder<ActionOfTheDayEntry,
    ActionOfTheDayEntry, QFilterCondition> {
  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      completedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completed',
        value: value,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      completedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      completedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      completedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      dateKeyEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateKey',
        value: value,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      dateKeyGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateKey',
        value: value,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      dateKeyLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateKey',
        value: value,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      dateKeyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      taskKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      taskKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      taskKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      taskKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      taskKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taskKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      taskKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taskKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      taskKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taskKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      taskKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taskKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      taskKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskKey',
        value: '',
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      taskKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taskKey',
        value: '',
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      titleArEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titleAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      titleArGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'titleAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      titleArLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'titleAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      titleArBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'titleAr',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      titleArStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'titleAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      titleArEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'titleAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      titleArContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'titleAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      titleArMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'titleAr',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      titleArIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titleAr',
        value: '',
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      titleArIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'titleAr',
        value: '',
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      titleEnEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titleEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      titleEnGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'titleEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      titleEnLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'titleEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      titleEnBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'titleEn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      titleEnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'titleEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      titleEnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'titleEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      titleEnContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'titleEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      titleEnMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'titleEn',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      titleEnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titleEn',
        value: '',
      ));
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterFilterCondition>
      titleEnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'titleEn',
        value: '',
      ));
    });
  }
}

extension ActionOfTheDayEntryQueryObject on QueryBuilder<ActionOfTheDayEntry,
    ActionOfTheDayEntry, QFilterCondition> {}

extension ActionOfTheDayEntryQueryLinks on QueryBuilder<ActionOfTheDayEntry,
    ActionOfTheDayEntry, QFilterCondition> {}

extension ActionOfTheDayEntryQuerySortBy
    on QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QSortBy> {
  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      sortByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      sortByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      sortByDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.asc);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      sortByDateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.desc);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      sortByTaskKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskKey', Sort.asc);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      sortByTaskKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskKey', Sort.desc);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      sortByTitleAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleAr', Sort.asc);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      sortByTitleArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleAr', Sort.desc);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      sortByTitleEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleEn', Sort.asc);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      sortByTitleEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleEn', Sort.desc);
    });
  }
}

extension ActionOfTheDayEntryQuerySortThenBy
    on QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QSortThenBy> {
  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      thenByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      thenByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      thenByDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.asc);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      thenByDateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.desc);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      thenByTaskKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskKey', Sort.asc);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      thenByTaskKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskKey', Sort.desc);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      thenByTitleAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleAr', Sort.asc);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      thenByTitleArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleAr', Sort.desc);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      thenByTitleEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleEn', Sort.asc);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QAfterSortBy>
      thenByTitleEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleEn', Sort.desc);
    });
  }
}

extension ActionOfTheDayEntryQueryWhereDistinct
    on QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QDistinct> {
  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QDistinct>
      distinctByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completed');
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QDistinct>
      distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QDistinct>
      distinctByDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateKey');
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QDistinct>
      distinctByTaskKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QDistinct>
      distinctByTitleAr({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'titleAr', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QDistinct>
      distinctByTitleEn({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'titleEn', caseSensitive: caseSensitive);
    });
  }
}

extension ActionOfTheDayEntryQueryProperty
    on QueryBuilder<ActionOfTheDayEntry, ActionOfTheDayEntry, QQueryProperty> {
  QueryBuilder<ActionOfTheDayEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ActionOfTheDayEntry, bool, QQueryOperations>
      completedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completed');
    });
  }

  QueryBuilder<ActionOfTheDayEntry, DateTime?, QQueryOperations>
      completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<ActionOfTheDayEntry, int, QQueryOperations> dateKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateKey');
    });
  }

  QueryBuilder<ActionOfTheDayEntry, String, QQueryOperations>
      taskKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskKey');
    });
  }

  QueryBuilder<ActionOfTheDayEntry, String, QQueryOperations>
      titleArProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'titleAr');
    });
  }

  QueryBuilder<ActionOfTheDayEntry, String, QQueryOperations>
      titleEnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'titleEn');
    });
  }
}
