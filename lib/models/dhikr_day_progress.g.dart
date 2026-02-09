// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dhikr_day_progress.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDhikrDayProgressCollection on Isar {
  IsarCollection<DhikrDayProgress> get dhikrDayProgress => this.collection();
}

const DhikrDayProgressSchema = CollectionSchema(
  name: r'DhikrDayProgress',
  id: -6597114187898582868,
  properties: {
    r'categoryId': PropertySchema(
      id: 0,
      name: r'categoryId',
      type: IsarType.string,
    ),
    r'countsJson': PropertySchema(
      id: 1,
      name: r'countsJson',
      type: IsarType.string,
    ),
    r'dateKey': PropertySchema(
      id: 2,
      name: r'dateKey',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 3,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _dhikrDayProgressEstimateSize,
  serialize: _dhikrDayProgressSerialize,
  deserialize: _dhikrDayProgressDeserialize,
  deserializeProp: _dhikrDayProgressDeserializeProp,
  idName: r'id',
  indexes: {
    r'dateKey': IndexSchema(
      id: 7975223786082927131,
      name: r'dateKey',
      unique: false,
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
  getId: _dhikrDayProgressGetId,
  getLinks: _dhikrDayProgressGetLinks,
  attach: _dhikrDayProgressAttach,
  version: '3.1.0+1',
);

int _dhikrDayProgressEstimateSize(
  DhikrDayProgress object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.categoryId.length * 3;
  bytesCount += 3 + object.countsJson.length * 3;
  return bytesCount;
}

void _dhikrDayProgressSerialize(
  DhikrDayProgress object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.categoryId);
  writer.writeString(offsets[1], object.countsJson);
  writer.writeLong(offsets[2], object.dateKey);
  writer.writeDateTime(offsets[3], object.updatedAt);
}

DhikrDayProgress _dhikrDayProgressDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DhikrDayProgress();
  object.categoryId = reader.readString(offsets[0]);
  object.countsJson = reader.readString(offsets[1]);
  object.dateKey = reader.readLong(offsets[2]);
  object.id = id;
  object.updatedAt = reader.readDateTime(offsets[3]);
  return object;
}

P _dhikrDayProgressDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dhikrDayProgressGetId(DhikrDayProgress object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dhikrDayProgressGetLinks(DhikrDayProgress object) {
  return [];
}

void _dhikrDayProgressAttach(
    IsarCollection<dynamic> col, Id id, DhikrDayProgress object) {
  object.id = id;
}

extension DhikrDayProgressQueryWhereSort
    on QueryBuilder<DhikrDayProgress, DhikrDayProgress, QWhere> {
  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterWhere> anyDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateKey'),
      );
    });
  }
}

extension DhikrDayProgressQueryWhere
    on QueryBuilder<DhikrDayProgress, DhikrDayProgress, QWhereClause> {
  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterWhereClause>
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

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterWhereClause> idBetween(
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

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterWhereClause>
      dateKeyEqualTo(int dateKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dateKey',
        value: [dateKey],
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterWhereClause>
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

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterWhereClause>
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

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterWhereClause>
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

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterWhereClause>
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

extension DhikrDayProgressQueryFilter
    on QueryBuilder<DhikrDayProgress, DhikrDayProgress, QFilterCondition> {
  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      categoryIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      categoryIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      categoryIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      categoryIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      categoryIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'categoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      categoryIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'categoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      categoryIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'categoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      categoryIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'categoryId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      categoryIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryId',
        value: '',
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      categoryIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'categoryId',
        value: '',
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      countsJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'countsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      countsJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'countsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      countsJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'countsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      countsJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'countsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      countsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'countsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      countsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'countsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      countsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'countsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      countsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'countsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      countsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'countsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      countsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'countsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      dateKeyEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateKey',
        value: value,
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
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

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
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

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
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

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
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

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
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

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
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

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DhikrDayProgressQueryObject
    on QueryBuilder<DhikrDayProgress, DhikrDayProgress, QFilterCondition> {}

extension DhikrDayProgressQueryLinks
    on QueryBuilder<DhikrDayProgress, DhikrDayProgress, QFilterCondition> {}

extension DhikrDayProgressQuerySortBy
    on QueryBuilder<DhikrDayProgress, DhikrDayProgress, QSortBy> {
  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterSortBy>
      sortByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterSortBy>
      sortByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterSortBy>
      sortByCountsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countsJson', Sort.asc);
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterSortBy>
      sortByCountsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countsJson', Sort.desc);
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterSortBy>
      sortByDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.asc);
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterSortBy>
      sortByDateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.desc);
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DhikrDayProgressQuerySortThenBy
    on QueryBuilder<DhikrDayProgress, DhikrDayProgress, QSortThenBy> {
  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterSortBy>
      thenByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterSortBy>
      thenByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterSortBy>
      thenByCountsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countsJson', Sort.asc);
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterSortBy>
      thenByCountsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countsJson', Sort.desc);
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterSortBy>
      thenByDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.asc);
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterSortBy>
      thenByDateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.desc);
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DhikrDayProgressQueryWhereDistinct
    on QueryBuilder<DhikrDayProgress, DhikrDayProgress, QDistinct> {
  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QDistinct>
      distinctByCategoryId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QDistinct>
      distinctByCountsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'countsJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QDistinct>
      distinctByDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateKey');
    });
  }

  QueryBuilder<DhikrDayProgress, DhikrDayProgress, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension DhikrDayProgressQueryProperty
    on QueryBuilder<DhikrDayProgress, DhikrDayProgress, QQueryProperty> {
  QueryBuilder<DhikrDayProgress, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DhikrDayProgress, String, QQueryOperations>
      categoryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryId');
    });
  }

  QueryBuilder<DhikrDayProgress, String, QQueryOperations>
      countsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'countsJson');
    });
  }

  QueryBuilder<DhikrDayProgress, int, QQueryOperations> dateKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateKey');
    });
  }

  QueryBuilder<DhikrDayProgress, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
