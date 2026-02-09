// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'luminous_wallet.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLuminousWalletCollection on Isar {
  IsarCollection<LuminousWallet> get luminousWallets => this.collection();
}

const LuminousWalletSchema = CollectionSchema(
  name: r'LuminousWallet',
  id: 7285076910863299881,
  properties: {
    r'totalPieces': PropertySchema(
      id: 0,
      name: r'totalPieces',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 1,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _luminousWalletEstimateSize,
  serialize: _luminousWalletSerialize,
  deserialize: _luminousWalletDeserialize,
  deserializeProp: _luminousWalletDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _luminousWalletGetId,
  getLinks: _luminousWalletGetLinks,
  attach: _luminousWalletAttach,
  version: '3.1.0+1',
);

int _luminousWalletEstimateSize(
  LuminousWallet object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _luminousWalletSerialize(
  LuminousWallet object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.totalPieces);
  writer.writeDateTime(offsets[1], object.updatedAt);
}

LuminousWallet _luminousWalletDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LuminousWallet();
  object.id = id;
  object.totalPieces = reader.readLong(offsets[0]);
  object.updatedAt = reader.readDateTime(offsets[1]);
  return object;
}

P _luminousWalletDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _luminousWalletGetId(LuminousWallet object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _luminousWalletGetLinks(LuminousWallet object) {
  return [];
}

void _luminousWalletAttach(
    IsarCollection<dynamic> col, Id id, LuminousWallet object) {
  object.id = id;
}

extension LuminousWalletQueryWhereSort
    on QueryBuilder<LuminousWallet, LuminousWallet, QWhere> {
  QueryBuilder<LuminousWallet, LuminousWallet, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LuminousWalletQueryWhere
    on QueryBuilder<LuminousWallet, LuminousWallet, QWhereClause> {
  QueryBuilder<LuminousWallet, LuminousWallet, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LuminousWallet, LuminousWallet, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<LuminousWallet, LuminousWallet, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LuminousWallet, LuminousWallet, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LuminousWallet, LuminousWallet, QAfterWhereClause> idBetween(
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

extension LuminousWalletQueryFilter
    on QueryBuilder<LuminousWallet, LuminousWallet, QFilterCondition> {
  QueryBuilder<LuminousWallet, LuminousWallet, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LuminousWallet, LuminousWallet, QAfterFilterCondition>
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

  QueryBuilder<LuminousWallet, LuminousWallet, QAfterFilterCondition>
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

  QueryBuilder<LuminousWallet, LuminousWallet, QAfterFilterCondition> idBetween(
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

  QueryBuilder<LuminousWallet, LuminousWallet, QAfterFilterCondition>
      totalPiecesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalPieces',
        value: value,
      ));
    });
  }

  QueryBuilder<LuminousWallet, LuminousWallet, QAfterFilterCondition>
      totalPiecesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalPieces',
        value: value,
      ));
    });
  }

  QueryBuilder<LuminousWallet, LuminousWallet, QAfterFilterCondition>
      totalPiecesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalPieces',
        value: value,
      ));
    });
  }

  QueryBuilder<LuminousWallet, LuminousWallet, QAfterFilterCondition>
      totalPiecesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalPieces',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LuminousWallet, LuminousWallet, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LuminousWallet, LuminousWallet, QAfterFilterCondition>
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

  QueryBuilder<LuminousWallet, LuminousWallet, QAfterFilterCondition>
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

  QueryBuilder<LuminousWallet, LuminousWallet, QAfterFilterCondition>
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

extension LuminousWalletQueryObject
    on QueryBuilder<LuminousWallet, LuminousWallet, QFilterCondition> {}

extension LuminousWalletQueryLinks
    on QueryBuilder<LuminousWallet, LuminousWallet, QFilterCondition> {}

extension LuminousWalletQuerySortBy
    on QueryBuilder<LuminousWallet, LuminousWallet, QSortBy> {
  QueryBuilder<LuminousWallet, LuminousWallet, QAfterSortBy>
      sortByTotalPieces() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPieces', Sort.asc);
    });
  }

  QueryBuilder<LuminousWallet, LuminousWallet, QAfterSortBy>
      sortByTotalPiecesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPieces', Sort.desc);
    });
  }

  QueryBuilder<LuminousWallet, LuminousWallet, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LuminousWallet, LuminousWallet, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LuminousWalletQuerySortThenBy
    on QueryBuilder<LuminousWallet, LuminousWallet, QSortThenBy> {
  QueryBuilder<LuminousWallet, LuminousWallet, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LuminousWallet, LuminousWallet, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LuminousWallet, LuminousWallet, QAfterSortBy>
      thenByTotalPieces() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPieces', Sort.asc);
    });
  }

  QueryBuilder<LuminousWallet, LuminousWallet, QAfterSortBy>
      thenByTotalPiecesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPieces', Sort.desc);
    });
  }

  QueryBuilder<LuminousWallet, LuminousWallet, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LuminousWallet, LuminousWallet, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LuminousWalletQueryWhereDistinct
    on QueryBuilder<LuminousWallet, LuminousWallet, QDistinct> {
  QueryBuilder<LuminousWallet, LuminousWallet, QDistinct>
      distinctByTotalPieces() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalPieces');
    });
  }

  QueryBuilder<LuminousWallet, LuminousWallet, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension LuminousWalletQueryProperty
    on QueryBuilder<LuminousWallet, LuminousWallet, QQueryProperty> {
  QueryBuilder<LuminousWallet, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LuminousWallet, int, QQueryOperations> totalPiecesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalPieces');
    });
  }

  QueryBuilder<LuminousWallet, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
