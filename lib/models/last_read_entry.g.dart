// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'last_read_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLastReadEntryCollection on Isar {
  IsarCollection<LastReadEntry> get lastReadEntrys => this.collection();
}

const LastReadEntrySchema = CollectionSchema(
  name: r'LastReadEntry',
  id: 4572484787619339464,
  properties: {
    r'aya': PropertySchema(
      id: 0,
      name: r'aya',
      type: IsarType.long,
    ),
    r'sura': PropertySchema(
      id: 1,
      name: r'sura',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 2,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _lastReadEntryEstimateSize,
  serialize: _lastReadEntrySerialize,
  deserialize: _lastReadEntryDeserialize,
  deserializeProp: _lastReadEntryDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _lastReadEntryGetId,
  getLinks: _lastReadEntryGetLinks,
  attach: _lastReadEntryAttach,
  version: '3.1.0+1',
);

int _lastReadEntryEstimateSize(
  LastReadEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _lastReadEntrySerialize(
  LastReadEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.aya);
  writer.writeLong(offsets[1], object.sura);
  writer.writeDateTime(offsets[2], object.updatedAt);
}

LastReadEntry _lastReadEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LastReadEntry();
  object.aya = reader.readLong(offsets[0]);
  object.id = id;
  object.sura = reader.readLong(offsets[1]);
  object.updatedAt = reader.readDateTime(offsets[2]);
  return object;
}

P _lastReadEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _lastReadEntryGetId(LastReadEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _lastReadEntryGetLinks(LastReadEntry object) {
  return [];
}

void _lastReadEntryAttach(
    IsarCollection<dynamic> col, Id id, LastReadEntry object) {
  object.id = id;
}

extension LastReadEntryQueryWhereSort
    on QueryBuilder<LastReadEntry, LastReadEntry, QWhere> {
  QueryBuilder<LastReadEntry, LastReadEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LastReadEntryQueryWhere
    on QueryBuilder<LastReadEntry, LastReadEntry, QWhereClause> {
  QueryBuilder<LastReadEntry, LastReadEntry, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterWhereClause> idBetween(
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
}

extension LastReadEntryQueryFilter
    on QueryBuilder<LastReadEntry, LastReadEntry, QFilterCondition> {
  QueryBuilder<LastReadEntry, LastReadEntry, QAfterFilterCondition> ayaEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aya',
        value: value,
      ));
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterFilterCondition>
      ayaGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'aya',
        value: value,
      ));
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterFilterCondition> ayaLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'aya',
        value: value,
      ));
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterFilterCondition> ayaBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'aya',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterFilterCondition>
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

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterFilterCondition> idBetween(
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

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterFilterCondition> suraEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sura',
        value: value,
      ));
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterFilterCondition>
      suraGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sura',
        value: value,
      ));
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterFilterCondition>
      suraLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sura',
        value: value,
      ));
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterFilterCondition> suraBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sura',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterFilterCondition>
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

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterFilterCondition>
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

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterFilterCondition>
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

extension LastReadEntryQueryObject
    on QueryBuilder<LastReadEntry, LastReadEntry, QFilterCondition> {}

extension LastReadEntryQueryLinks
    on QueryBuilder<LastReadEntry, LastReadEntry, QFilterCondition> {}

extension LastReadEntryQuerySortBy
    on QueryBuilder<LastReadEntry, LastReadEntry, QSortBy> {
  QueryBuilder<LastReadEntry, LastReadEntry, QAfterSortBy> sortByAya() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aya', Sort.asc);
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterSortBy> sortByAyaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aya', Sort.desc);
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterSortBy> sortBySura() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sura', Sort.asc);
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterSortBy> sortBySuraDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sura', Sort.desc);
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LastReadEntryQuerySortThenBy
    on QueryBuilder<LastReadEntry, LastReadEntry, QSortThenBy> {
  QueryBuilder<LastReadEntry, LastReadEntry, QAfterSortBy> thenByAya() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aya', Sort.asc);
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterSortBy> thenByAyaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aya', Sort.desc);
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterSortBy> thenBySura() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sura', Sort.asc);
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterSortBy> thenBySuraDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sura', Sort.desc);
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LastReadEntryQueryWhereDistinct
    on QueryBuilder<LastReadEntry, LastReadEntry, QDistinct> {
  QueryBuilder<LastReadEntry, LastReadEntry, QDistinct> distinctByAya() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aya');
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QDistinct> distinctBySura() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sura');
    });
  }

  QueryBuilder<LastReadEntry, LastReadEntry, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension LastReadEntryQueryProperty
    on QueryBuilder<LastReadEntry, LastReadEntry, QQueryProperty> {
  QueryBuilder<LastReadEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LastReadEntry, int, QQueryOperations> ayaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aya');
    });
  }

  QueryBuilder<LastReadEntry, int, QQueryOperations> suraProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sura');
    });
  }

  QueryBuilder<LastReadEntry, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
