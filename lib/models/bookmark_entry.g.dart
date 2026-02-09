// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBookmarkEntryCollection on Isar {
  IsarCollection<BookmarkEntry> get bookmarkEntrys => this.collection();
}

const BookmarkEntrySchema = CollectionSchema(
  name: r'BookmarkEntry',
  id: -5285363740700718831,
  properties: {
    r'aya': PropertySchema(
      id: 0,
      name: r'aya',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'sura': PropertySchema(
      id: 2,
      name: r'sura',
      type: IsarType.long,
    )
  },
  estimateSize: _bookmarkEntryEstimateSize,
  serialize: _bookmarkEntrySerialize,
  deserialize: _bookmarkEntryDeserialize,
  deserializeProp: _bookmarkEntryDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _bookmarkEntryGetId,
  getLinks: _bookmarkEntryGetLinks,
  attach: _bookmarkEntryAttach,
  version: '3.1.0+1',
);

int _bookmarkEntryEstimateSize(
  BookmarkEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _bookmarkEntrySerialize(
  BookmarkEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.aya);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.sura);
}

BookmarkEntry _bookmarkEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BookmarkEntry();
  object.aya = reader.readLong(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.id = id;
  object.sura = reader.readLong(offsets[2]);
  return object;
}

P _bookmarkEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _bookmarkEntryGetId(BookmarkEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _bookmarkEntryGetLinks(BookmarkEntry object) {
  return [];
}

void _bookmarkEntryAttach(
    IsarCollection<dynamic> col, Id id, BookmarkEntry object) {
  object.id = id;
}

extension BookmarkEntryQueryWhereSort
    on QueryBuilder<BookmarkEntry, BookmarkEntry, QWhere> {
  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BookmarkEntryQueryWhere
    on QueryBuilder<BookmarkEntry, BookmarkEntry, QWhereClause> {
  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterWhereClause> idBetween(
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

extension BookmarkEntryQueryFilter
    on QueryBuilder<BookmarkEntry, BookmarkEntry, QFilterCondition> {
  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterFilterCondition> ayaEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aya',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterFilterCondition>
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

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterFilterCondition> ayaLessThan(
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

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterFilterCondition> ayaBetween(
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

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterFilterCondition>
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

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterFilterCondition> idBetween(
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

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterFilterCondition> suraEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sura',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterFilterCondition>
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

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterFilterCondition>
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

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterFilterCondition> suraBetween(
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
}

extension BookmarkEntryQueryObject
    on QueryBuilder<BookmarkEntry, BookmarkEntry, QFilterCondition> {}

extension BookmarkEntryQueryLinks
    on QueryBuilder<BookmarkEntry, BookmarkEntry, QFilterCondition> {}

extension BookmarkEntryQuerySortBy
    on QueryBuilder<BookmarkEntry, BookmarkEntry, QSortBy> {
  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterSortBy> sortByAya() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aya', Sort.asc);
    });
  }

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterSortBy> sortByAyaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aya', Sort.desc);
    });
  }

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterSortBy> sortBySura() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sura', Sort.asc);
    });
  }

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterSortBy> sortBySuraDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sura', Sort.desc);
    });
  }
}

extension BookmarkEntryQuerySortThenBy
    on QueryBuilder<BookmarkEntry, BookmarkEntry, QSortThenBy> {
  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterSortBy> thenByAya() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aya', Sort.asc);
    });
  }

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterSortBy> thenByAyaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aya', Sort.desc);
    });
  }

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterSortBy> thenBySura() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sura', Sort.asc);
    });
  }

  QueryBuilder<BookmarkEntry, BookmarkEntry, QAfterSortBy> thenBySuraDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sura', Sort.desc);
    });
  }
}

extension BookmarkEntryQueryWhereDistinct
    on QueryBuilder<BookmarkEntry, BookmarkEntry, QDistinct> {
  QueryBuilder<BookmarkEntry, BookmarkEntry, QDistinct> distinctByAya() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aya');
    });
  }

  QueryBuilder<BookmarkEntry, BookmarkEntry, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<BookmarkEntry, BookmarkEntry, QDistinct> distinctBySura() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sura');
    });
  }
}

extension BookmarkEntryQueryProperty
    on QueryBuilder<BookmarkEntry, BookmarkEntry, QQueryProperty> {
  QueryBuilder<BookmarkEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BookmarkEntry, int, QQueryOperations> ayaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aya');
    });
  }

  QueryBuilder<BookmarkEntry, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<BookmarkEntry, int, QQueryOperations> suraProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sura');
    });
  }
}
