// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_month_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPrayerMonthCacheCollection on Isar {
  IsarCollection<PrayerMonthCache> get prayerMonthCaches => this.collection();
}

const PrayerMonthCacheSchema = CollectionSchema(
  name: r'PrayerMonthCache',
  id: -6174273408789173518,
  properties: {
    r'dataJson': PropertySchema(
      id: 0,
      name: r'dataJson',
      type: IsarType.string,
    ),
    r'month': PropertySchema(
      id: 1,
      name: r'month',
      type: IsarType.long,
    ),
    r'year': PropertySchema(
      id: 2,
      name: r'year',
      type: IsarType.long,
    ),
    r'yearMonthKey': PropertySchema(
      id: 3,
      name: r'yearMonthKey',
      type: IsarType.long,
    )
  },
  estimateSize: _prayerMonthCacheEstimateSize,
  serialize: _prayerMonthCacheSerialize,
  deserialize: _prayerMonthCacheDeserialize,
  deserializeProp: _prayerMonthCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'yearMonthKey': IndexSchema(
      id: -7336763800647463484,
      name: r'yearMonthKey',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'yearMonthKey',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _prayerMonthCacheGetId,
  getLinks: _prayerMonthCacheGetLinks,
  attach: _prayerMonthCacheAttach,
  version: '3.1.0+1',
);

int _prayerMonthCacheEstimateSize(
  PrayerMonthCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.dataJson.length * 3;
  return bytesCount;
}

void _prayerMonthCacheSerialize(
  PrayerMonthCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.dataJson);
  writer.writeLong(offsets[1], object.month);
  writer.writeLong(offsets[2], object.year);
  writer.writeLong(offsets[3], object.yearMonthKey);
}

PrayerMonthCache _prayerMonthCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PrayerMonthCache();
  object.dataJson = reader.readString(offsets[0]);
  object.id = id;
  object.month = reader.readLong(offsets[1]);
  object.year = reader.readLong(offsets[2]);
  object.yearMonthKey = reader.readLong(offsets[3]);
  return object;
}

P _prayerMonthCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _prayerMonthCacheGetId(PrayerMonthCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _prayerMonthCacheGetLinks(PrayerMonthCache object) {
  return [];
}

void _prayerMonthCacheAttach(
    IsarCollection<dynamic> col, Id id, PrayerMonthCache object) {
  object.id = id;
}

extension PrayerMonthCacheQueryWhereSort
    on QueryBuilder<PrayerMonthCache, PrayerMonthCache, QWhere> {
  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterWhere>
      anyYearMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'yearMonthKey'),
      );
    });
  }
}

extension PrayerMonthCacheQueryWhere
    on QueryBuilder<PrayerMonthCache, PrayerMonthCache, QWhereClause> {
  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterWhereClause>
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

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterWhereClause> idBetween(
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

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterWhereClause>
      yearMonthKeyEqualTo(int yearMonthKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'yearMonthKey',
        value: [yearMonthKey],
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterWhereClause>
      yearMonthKeyNotEqualTo(int yearMonthKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'yearMonthKey',
              lower: [],
              upper: [yearMonthKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'yearMonthKey',
              lower: [yearMonthKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'yearMonthKey',
              lower: [yearMonthKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'yearMonthKey',
              lower: [],
              upper: [yearMonthKey],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterWhereClause>
      yearMonthKeyGreaterThan(
    int yearMonthKey, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'yearMonthKey',
        lower: [yearMonthKey],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterWhereClause>
      yearMonthKeyLessThan(
    int yearMonthKey, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'yearMonthKey',
        lower: [],
        upper: [yearMonthKey],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterWhereClause>
      yearMonthKeyBetween(
    int lowerYearMonthKey,
    int upperYearMonthKey, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'yearMonthKey',
        lower: [lowerYearMonthKey],
        includeLower: includeLower,
        upper: [upperYearMonthKey],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PrayerMonthCacheQueryFilter
    on QueryBuilder<PrayerMonthCache, PrayerMonthCache, QFilterCondition> {
  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
      dataJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
      dataJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
      dataJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
      dataJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dataJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
      dataJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
      dataJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
      dataJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
      dataJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dataJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
      dataJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataJson',
        value: '',
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
      dataJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dataJson',
        value: '',
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
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

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
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

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
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

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
      monthEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'month',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
      monthGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'month',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
      monthLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'month',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
      monthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'month',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
      yearEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
      yearGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
      yearLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
      yearBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'year',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
      yearMonthKeyEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'yearMonthKey',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
      yearMonthKeyGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'yearMonthKey',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
      yearMonthKeyLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'yearMonthKey',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterFilterCondition>
      yearMonthKeyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'yearMonthKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PrayerMonthCacheQueryObject
    on QueryBuilder<PrayerMonthCache, PrayerMonthCache, QFilterCondition> {}

extension PrayerMonthCacheQueryLinks
    on QueryBuilder<PrayerMonthCache, PrayerMonthCache, QFilterCondition> {}

extension PrayerMonthCacheQuerySortBy
    on QueryBuilder<PrayerMonthCache, PrayerMonthCache, QSortBy> {
  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterSortBy>
      sortByDataJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataJson', Sort.asc);
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterSortBy>
      sortByDataJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataJson', Sort.desc);
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterSortBy> sortByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.asc);
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterSortBy>
      sortByMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.desc);
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterSortBy> sortByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterSortBy>
      sortByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterSortBy>
      sortByYearMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearMonthKey', Sort.asc);
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterSortBy>
      sortByYearMonthKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearMonthKey', Sort.desc);
    });
  }
}

extension PrayerMonthCacheQuerySortThenBy
    on QueryBuilder<PrayerMonthCache, PrayerMonthCache, QSortThenBy> {
  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterSortBy>
      thenByDataJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataJson', Sort.asc);
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterSortBy>
      thenByDataJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataJson', Sort.desc);
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterSortBy> thenByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.asc);
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterSortBy>
      thenByMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.desc);
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterSortBy> thenByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterSortBy>
      thenByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterSortBy>
      thenByYearMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearMonthKey', Sort.asc);
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QAfterSortBy>
      thenByYearMonthKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearMonthKey', Sort.desc);
    });
  }
}

extension PrayerMonthCacheQueryWhereDistinct
    on QueryBuilder<PrayerMonthCache, PrayerMonthCache, QDistinct> {
  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QDistinct>
      distinctByDataJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QDistinct>
      distinctByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'month');
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QDistinct> distinctByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'year');
    });
  }

  QueryBuilder<PrayerMonthCache, PrayerMonthCache, QDistinct>
      distinctByYearMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'yearMonthKey');
    });
  }
}

extension PrayerMonthCacheQueryProperty
    on QueryBuilder<PrayerMonthCache, PrayerMonthCache, QQueryProperty> {
  QueryBuilder<PrayerMonthCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PrayerMonthCache, String, QQueryOperations> dataJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataJson');
    });
  }

  QueryBuilder<PrayerMonthCache, int, QQueryOperations> monthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'month');
    });
  }

  QueryBuilder<PrayerMonthCache, int, QQueryOperations> yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'year');
    });
  }

  QueryBuilder<PrayerMonthCache, int, QQueryOperations> yearMonthKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'yearMonthKey');
    });
  }
}
