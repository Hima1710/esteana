// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mushaf_page_progress.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMushafPageProgressCollection on Isar {
  IsarCollection<MushafPageProgress> get mushafPageProgress =>
      this.collection();
}

const MushafPageProgressSchema = CollectionSchema(
  name: r'MushafPageProgress',
  id: -3953296158322537885,
  properties: {
    r'completedAt': PropertySchema(
      id: 0,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'pageNumber': PropertySchema(
      id: 1,
      name: r'pageNumber',
      type: IsarType.long,
    )
  },
  estimateSize: _mushafPageProgressEstimateSize,
  serialize: _mushafPageProgressSerialize,
  deserialize: _mushafPageProgressDeserialize,
  deserializeProp: _mushafPageProgressDeserializeProp,
  idName: r'id',
  indexes: {
    r'pageNumber': IndexSchema(
      id: -702571354938573130,
      name: r'pageNumber',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'pageNumber',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'completedAt': IndexSchema(
      id: -3156591011457686752,
      name: r'completedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'completedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _mushafPageProgressGetId,
  getLinks: _mushafPageProgressGetLinks,
  attach: _mushafPageProgressAttach,
  version: '3.1.0+1',
);

int _mushafPageProgressEstimateSize(
  MushafPageProgress object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _mushafPageProgressSerialize(
  MushafPageProgress object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.completedAt);
  writer.writeLong(offsets[1], object.pageNumber);
}

MushafPageProgress _mushafPageProgressDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MushafPageProgress();
  object.completedAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.pageNumber = reader.readLong(offsets[1]);
  return object;
}

P _mushafPageProgressDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _mushafPageProgressGetId(MushafPageProgress object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _mushafPageProgressGetLinks(
    MushafPageProgress object) {
  return [];
}

void _mushafPageProgressAttach(
    IsarCollection<dynamic> col, Id id, MushafPageProgress object) {
  object.id = id;
}

extension MushafPageProgressByIndex on IsarCollection<MushafPageProgress> {
  Future<MushafPageProgress?> getByPageNumber(int pageNumber) {
    return getByIndex(r'pageNumber', [pageNumber]);
  }

  MushafPageProgress? getByPageNumberSync(int pageNumber) {
    return getByIndexSync(r'pageNumber', [pageNumber]);
  }

  Future<bool> deleteByPageNumber(int pageNumber) {
    return deleteByIndex(r'pageNumber', [pageNumber]);
  }

  bool deleteByPageNumberSync(int pageNumber) {
    return deleteByIndexSync(r'pageNumber', [pageNumber]);
  }

  Future<List<MushafPageProgress?>> getAllByPageNumber(
      List<int> pageNumberValues) {
    final values = pageNumberValues.map((e) => [e]).toList();
    return getAllByIndex(r'pageNumber', values);
  }

  List<MushafPageProgress?> getAllByPageNumberSync(List<int> pageNumberValues) {
    final values = pageNumberValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'pageNumber', values);
  }

  Future<int> deleteAllByPageNumber(List<int> pageNumberValues) {
    final values = pageNumberValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'pageNumber', values);
  }

  int deleteAllByPageNumberSync(List<int> pageNumberValues) {
    final values = pageNumberValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'pageNumber', values);
  }

  Future<Id> putByPageNumber(MushafPageProgress object) {
    return putByIndex(r'pageNumber', object);
  }

  Id putByPageNumberSync(MushafPageProgress object, {bool saveLinks = true}) {
    return putByIndexSync(r'pageNumber', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPageNumber(List<MushafPageProgress> objects) {
    return putAllByIndex(r'pageNumber', objects);
  }

  List<Id> putAllByPageNumberSync(List<MushafPageProgress> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'pageNumber', objects, saveLinks: saveLinks);
  }
}

extension MushafPageProgressQueryWhereSort
    on QueryBuilder<MushafPageProgress, MushafPageProgress, QWhere> {
  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterWhere>
      anyPageNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'pageNumber'),
      );
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterWhere>
      anyCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'completedAt'),
      );
    });
  }
}

extension MushafPageProgressQueryWhere
    on QueryBuilder<MushafPageProgress, MushafPageProgress, QWhereClause> {
  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterWhereClause>
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

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterWhereClause>
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

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterWhereClause>
      pageNumberEqualTo(int pageNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'pageNumber',
        value: [pageNumber],
      ));
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterWhereClause>
      pageNumberNotEqualTo(int pageNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pageNumber',
              lower: [],
              upper: [pageNumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pageNumber',
              lower: [pageNumber],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pageNumber',
              lower: [pageNumber],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pageNumber',
              lower: [],
              upper: [pageNumber],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterWhereClause>
      pageNumberGreaterThan(
    int pageNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'pageNumber',
        lower: [pageNumber],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterWhereClause>
      pageNumberLessThan(
    int pageNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'pageNumber',
        lower: [],
        upper: [pageNumber],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterWhereClause>
      pageNumberBetween(
    int lowerPageNumber,
    int upperPageNumber, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'pageNumber',
        lower: [lowerPageNumber],
        includeLower: includeLower,
        upper: [upperPageNumber],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterWhereClause>
      completedAtEqualTo(DateTime completedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'completedAt',
        value: [completedAt],
      ));
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterWhereClause>
      completedAtNotEqualTo(DateTime completedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completedAt',
              lower: [],
              upper: [completedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completedAt',
              lower: [completedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completedAt',
              lower: [completedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completedAt',
              lower: [],
              upper: [completedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterWhereClause>
      completedAtGreaterThan(
    DateTime completedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'completedAt',
        lower: [completedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterWhereClause>
      completedAtLessThan(
    DateTime completedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'completedAt',
        lower: [],
        upper: [completedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterWhereClause>
      completedAtBetween(
    DateTime lowerCompletedAt,
    DateTime upperCompletedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'completedAt',
        lower: [lowerCompletedAt],
        includeLower: includeLower,
        upper: [upperCompletedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MushafPageProgressQueryFilter
    on QueryBuilder<MushafPageProgress, MushafPageProgress, QFilterCondition> {
  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterFilterCondition>
      completedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterFilterCondition>
      completedAtGreaterThan(
    DateTime value, {
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

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterFilterCondition>
      completedAtLessThan(
    DateTime value, {
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

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterFilterCondition>
      completedAtBetween(
    DateTime lower,
    DateTime upper, {
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

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterFilterCondition>
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

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterFilterCondition>
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

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterFilterCondition>
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

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterFilterCondition>
      pageNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pageNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterFilterCondition>
      pageNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pageNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterFilterCondition>
      pageNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pageNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterFilterCondition>
      pageNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pageNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MushafPageProgressQueryObject
    on QueryBuilder<MushafPageProgress, MushafPageProgress, QFilterCondition> {}

extension MushafPageProgressQueryLinks
    on QueryBuilder<MushafPageProgress, MushafPageProgress, QFilterCondition> {}

extension MushafPageProgressQuerySortBy
    on QueryBuilder<MushafPageProgress, MushafPageProgress, QSortBy> {
  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterSortBy>
      sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterSortBy>
      sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterSortBy>
      sortByPageNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageNumber', Sort.asc);
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterSortBy>
      sortByPageNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageNumber', Sort.desc);
    });
  }
}

extension MushafPageProgressQuerySortThenBy
    on QueryBuilder<MushafPageProgress, MushafPageProgress, QSortThenBy> {
  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterSortBy>
      thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterSortBy>
      thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterSortBy>
      thenByPageNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageNumber', Sort.asc);
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QAfterSortBy>
      thenByPageNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageNumber', Sort.desc);
    });
  }
}

extension MushafPageProgressQueryWhereDistinct
    on QueryBuilder<MushafPageProgress, MushafPageProgress, QDistinct> {
  QueryBuilder<MushafPageProgress, MushafPageProgress, QDistinct>
      distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<MushafPageProgress, MushafPageProgress, QDistinct>
      distinctByPageNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pageNumber');
    });
  }
}

extension MushafPageProgressQueryProperty
    on QueryBuilder<MushafPageProgress, MushafPageProgress, QQueryProperty> {
  QueryBuilder<MushafPageProgress, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MushafPageProgress, DateTime, QQueryOperations>
      completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<MushafPageProgress, int, QQueryOperations> pageNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pageNumber');
    });
  }
}
