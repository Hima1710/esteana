// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mushaf_surah.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMushafSurahCollection on Isar {
  IsarCollection<MushafSurah> get mushafSurahs => this.collection();
}

const MushafSurahSchema = CollectionSchema(
  name: r'MushafSurah',
  id: 7757873272693317749,
  properties: {
    r'endPage': PropertySchema(
      id: 0,
      name: r'endPage',
      type: IsarType.long,
    ),
    r'nameAr': PropertySchema(
      id: 1,
      name: r'nameAr',
      type: IsarType.string,
    ),
    r'nameEn': PropertySchema(
      id: 2,
      name: r'nameEn',
      type: IsarType.string,
    ),
    r'revelationPlace': PropertySchema(
      id: 3,
      name: r'revelationPlace',
      type: IsarType.string,
    ),
    r'startPage': PropertySchema(
      id: 4,
      name: r'startPage',
      type: IsarType.long,
    ),
    r'surahNumber': PropertySchema(
      id: 5,
      name: r'surahNumber',
      type: IsarType.long,
    ),
    r'versesCount': PropertySchema(
      id: 6,
      name: r'versesCount',
      type: IsarType.long,
    )
  },
  estimateSize: _mushafSurahEstimateSize,
  serialize: _mushafSurahSerialize,
  deserialize: _mushafSurahDeserialize,
  deserializeProp: _mushafSurahDeserializeProp,
  idName: r'id',
  indexes: {
    r'surahNumber': IndexSchema(
      id: 9024003441292455669,
      name: r'surahNumber',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'surahNumber',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _mushafSurahGetId,
  getLinks: _mushafSurahGetLinks,
  attach: _mushafSurahAttach,
  version: '3.1.0+1',
);

int _mushafSurahEstimateSize(
  MushafSurah object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.nameAr.length * 3;
  bytesCount += 3 + object.nameEn.length * 3;
  bytesCount += 3 + object.revelationPlace.length * 3;
  return bytesCount;
}

void _mushafSurahSerialize(
  MushafSurah object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.endPage);
  writer.writeString(offsets[1], object.nameAr);
  writer.writeString(offsets[2], object.nameEn);
  writer.writeString(offsets[3], object.revelationPlace);
  writer.writeLong(offsets[4], object.startPage);
  writer.writeLong(offsets[5], object.surahNumber);
  writer.writeLong(offsets[6], object.versesCount);
}

MushafSurah _mushafSurahDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MushafSurah();
  object.endPage = reader.readLong(offsets[0]);
  object.id = id;
  object.nameAr = reader.readString(offsets[1]);
  object.nameEn = reader.readString(offsets[2]);
  object.revelationPlace = reader.readString(offsets[3]);
  object.startPage = reader.readLong(offsets[4]);
  object.surahNumber = reader.readLong(offsets[5]);
  object.versesCount = reader.readLong(offsets[6]);
  return object;
}

P _mushafSurahDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _mushafSurahGetId(MushafSurah object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _mushafSurahGetLinks(MushafSurah object) {
  return [];
}

void _mushafSurahAttach(
    IsarCollection<dynamic> col, Id id, MushafSurah object) {
  object.id = id;
}

extension MushafSurahQueryWhereSort
    on QueryBuilder<MushafSurah, MushafSurah, QWhere> {
  QueryBuilder<MushafSurah, MushafSurah, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterWhere> anySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'surahNumber'),
      );
    });
  }
}

extension MushafSurahQueryWhere
    on QueryBuilder<MushafSurah, MushafSurah, QWhereClause> {
  QueryBuilder<MushafSurah, MushafSurah, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<MushafSurah, MushafSurah, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterWhereClause> idBetween(
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

  QueryBuilder<MushafSurah, MushafSurah, QAfterWhereClause> surahNumberEqualTo(
      int surahNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'surahNumber',
        value: [surahNumber],
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterWhereClause>
      surahNumberNotEqualTo(int surahNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahNumber',
              lower: [],
              upper: [surahNumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahNumber',
              lower: [surahNumber],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahNumber',
              lower: [surahNumber],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahNumber',
              lower: [],
              upper: [surahNumber],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterWhereClause>
      surahNumberGreaterThan(
    int surahNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'surahNumber',
        lower: [surahNumber],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterWhereClause> surahNumberLessThan(
    int surahNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'surahNumber',
        lower: [],
        upper: [surahNumber],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterWhereClause> surahNumberBetween(
    int lowerSurahNumber,
    int upperSurahNumber, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'surahNumber',
        lower: [lowerSurahNumber],
        includeLower: includeLower,
        upper: [upperSurahNumber],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MushafSurahQueryFilter
    on QueryBuilder<MushafSurah, MushafSurah, QFilterCondition> {
  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition> endPageEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endPage',
        value: value,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      endPageGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endPage',
        value: value,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition> endPageLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endPage',
        value: value,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition> endPageBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endPage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition> idBetween(
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

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition> nameArEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      nameArGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition> nameArLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition> nameArBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nameAr',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      nameArStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition> nameArEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition> nameArContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition> nameArMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nameAr',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      nameArIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameAr',
        value: '',
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      nameArIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nameAr',
        value: '',
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition> nameEnEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      nameEnGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nameEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition> nameEnLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nameEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition> nameEnBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nameEn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      nameEnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nameEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition> nameEnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nameEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition> nameEnContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nameEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition> nameEnMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nameEn',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      nameEnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameEn',
        value: '',
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      nameEnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nameEn',
        value: '',
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      revelationPlaceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'revelationPlace',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      revelationPlaceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'revelationPlace',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      revelationPlaceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'revelationPlace',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      revelationPlaceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'revelationPlace',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      revelationPlaceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'revelationPlace',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      revelationPlaceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'revelationPlace',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      revelationPlaceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'revelationPlace',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      revelationPlaceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'revelationPlace',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      revelationPlaceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'revelationPlace',
        value: '',
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      revelationPlaceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'revelationPlace',
        value: '',
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      startPageEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startPage',
        value: value,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      startPageGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startPage',
        value: value,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      startPageLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startPage',
        value: value,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      startPageBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startPage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      surahNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      surahNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      surahNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      surahNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'surahNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      versesCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'versesCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      versesCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'versesCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      versesCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'versesCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterFilterCondition>
      versesCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'versesCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MushafSurahQueryObject
    on QueryBuilder<MushafSurah, MushafSurah, QFilterCondition> {}

extension MushafSurahQueryLinks
    on QueryBuilder<MushafSurah, MushafSurah, QFilterCondition> {}

extension MushafSurahQuerySortBy
    on QueryBuilder<MushafSurah, MushafSurah, QSortBy> {
  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> sortByEndPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endPage', Sort.asc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> sortByEndPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endPage', Sort.desc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> sortByNameAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.asc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> sortByNameArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.desc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> sortByNameEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameEn', Sort.asc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> sortByNameEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameEn', Sort.desc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> sortByRevelationPlace() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revelationPlace', Sort.asc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy>
      sortByRevelationPlaceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revelationPlace', Sort.desc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> sortByStartPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startPage', Sort.asc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> sortByStartPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startPage', Sort.desc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> sortBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.asc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> sortBySurahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.desc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> sortByVersesCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'versesCount', Sort.asc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> sortByVersesCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'versesCount', Sort.desc);
    });
  }
}

extension MushafSurahQuerySortThenBy
    on QueryBuilder<MushafSurah, MushafSurah, QSortThenBy> {
  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> thenByEndPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endPage', Sort.asc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> thenByEndPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endPage', Sort.desc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> thenByNameAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.asc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> thenByNameArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.desc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> thenByNameEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameEn', Sort.asc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> thenByNameEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameEn', Sort.desc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> thenByRevelationPlace() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revelationPlace', Sort.asc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy>
      thenByRevelationPlaceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revelationPlace', Sort.desc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> thenByStartPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startPage', Sort.asc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> thenByStartPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startPage', Sort.desc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> thenBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.asc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> thenBySurahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.desc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> thenByVersesCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'versesCount', Sort.asc);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QAfterSortBy> thenByVersesCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'versesCount', Sort.desc);
    });
  }
}

extension MushafSurahQueryWhereDistinct
    on QueryBuilder<MushafSurah, MushafSurah, QDistinct> {
  QueryBuilder<MushafSurah, MushafSurah, QDistinct> distinctByEndPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endPage');
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QDistinct> distinctByNameAr(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameAr', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QDistinct> distinctByNameEn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameEn', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QDistinct> distinctByRevelationPlace(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'revelationPlace',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QDistinct> distinctByStartPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startPage');
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QDistinct> distinctBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surahNumber');
    });
  }

  QueryBuilder<MushafSurah, MushafSurah, QDistinct> distinctByVersesCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'versesCount');
    });
  }
}

extension MushafSurahQueryProperty
    on QueryBuilder<MushafSurah, MushafSurah, QQueryProperty> {
  QueryBuilder<MushafSurah, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MushafSurah, int, QQueryOperations> endPageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endPage');
    });
  }

  QueryBuilder<MushafSurah, String, QQueryOperations> nameArProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameAr');
    });
  }

  QueryBuilder<MushafSurah, String, QQueryOperations> nameEnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameEn');
    });
  }

  QueryBuilder<MushafSurah, String, QQueryOperations>
      revelationPlaceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'revelationPlace');
    });
  }

  QueryBuilder<MushafSurah, int, QQueryOperations> startPageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startPage');
    });
  }

  QueryBuilder<MushafSurah, int, QQueryOperations> surahNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surahNumber');
    });
  }

  QueryBuilder<MushafSurah, int, QQueryOperations> versesCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'versesCount');
    });
  }
}
