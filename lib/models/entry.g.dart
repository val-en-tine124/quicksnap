// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetEntryCollection on Isar {
  IsarCollection<int, Entry> get entrys => this.collection();
}

final EntrySchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'Entry',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'createdAt', type: IsarType.dateTime),
      IsarPropertySchema(name: 'text', type: IsarType.string),
      IsarPropertySchema(name: 'photoPath', type: IsarType.string),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'createdAt',
        properties: ["createdAt"],
        unique: false,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, Entry>(
    serialize: serializeEntry,
    deserialize: deserializeEntry,
    deserializeProperty: deserializeEntryProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeEntry(IsarWriter writer, Entry object) {
  IsarCore.writeLong(
    writer,
    1,
    object.createdAt.toUtc().microsecondsSinceEpoch,
  );
  {
    final value = object.text;
    if (value == null) {
      IsarCore.writeNull(writer, 2);
    } else {
      IsarCore.writeString(writer, 2, value);
    }
  }
  {
    final value = object.photoPath;
    if (value == null) {
      IsarCore.writeNull(writer, 3);
    } else {
      IsarCore.writeString(writer, 3, value);
    }
  }
  return object.id;
}

@isarProtected
Entry deserializeEntry(IsarReader reader) {
  final int _id;
  _id = IsarCore.readId(reader);
  final object = Entry(_id);
  {
    final value = IsarCore.readLong(reader, 1);
    if (value == -9223372036854775808) {
      object.createdAt = DateTime.fromMillisecondsSinceEpoch(
        0,
        isUtc: true,
      ).toLocal();
    } else {
      object.createdAt = DateTime.fromMicrosecondsSinceEpoch(
        value,
        isUtc: true,
      ).toLocal();
    }
  }
  object.text = IsarCore.readString(reader, 2);
  object.photoPath = IsarCore.readString(reader, 3);
  return object;
}

@isarProtected
dynamic deserializeEntryProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      {
        final value = IsarCore.readLong(reader, 1);
        if (value == -9223372036854775808) {
          return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(
            value,
            isUtc: true,
          ).toLocal();
        }
      }
    case 2:
      return IsarCore.readString(reader, 2);
    case 3:
      return IsarCore.readString(reader, 3);
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _EntryUpdate {
  bool call({
    required int id,
    DateTime? createdAt,
    String? text,
    String? photoPath,
  });
}

class _EntryUpdateImpl implements _EntryUpdate {
  const _EntryUpdateImpl(this.collection);

  final IsarCollection<int, Entry> collection;

  @override
  bool call({
    required int id,
    Object? createdAt = ignore,
    Object? text = ignore,
    Object? photoPath = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (createdAt != ignore) 1: createdAt as DateTime?,
            if (text != ignore) 2: text as String?,
            if (photoPath != ignore) 3: photoPath as String?,
          },
        ) >
        0;
  }
}

sealed class _EntryUpdateAll {
  int call({
    required List<int> id,
    DateTime? createdAt,
    String? text,
    String? photoPath,
  });
}

class _EntryUpdateAllImpl implements _EntryUpdateAll {
  const _EntryUpdateAllImpl(this.collection);

  final IsarCollection<int, Entry> collection;

  @override
  int call({
    required List<int> id,
    Object? createdAt = ignore,
    Object? text = ignore,
    Object? photoPath = ignore,
  }) {
    return collection.updateProperties(id, {
      if (createdAt != ignore) 1: createdAt as DateTime?,
      if (text != ignore) 2: text as String?,
      if (photoPath != ignore) 3: photoPath as String?,
    });
  }
}

extension EntryUpdate on IsarCollection<int, Entry> {
  _EntryUpdate get update => _EntryUpdateImpl(this);

  _EntryUpdateAll get updateAll => _EntryUpdateAllImpl(this);
}

sealed class _EntryQueryUpdate {
  int call({DateTime? createdAt, String? text, String? photoPath});
}

class _EntryQueryUpdateImpl implements _EntryQueryUpdate {
  const _EntryQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<Entry> query;
  final int? limit;

  @override
  int call({
    Object? createdAt = ignore,
    Object? text = ignore,
    Object? photoPath = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (createdAt != ignore) 1: createdAt as DateTime?,
      if (text != ignore) 2: text as String?,
      if (photoPath != ignore) 3: photoPath as String?,
    });
  }
}

extension EntryQueryUpdate on IsarQuery<Entry> {
  _EntryQueryUpdate get updateFirst => _EntryQueryUpdateImpl(this, limit: 1);

  _EntryQueryUpdate get updateAll => _EntryQueryUpdateImpl(this);
}

class _EntryQueryBuilderUpdateImpl implements _EntryQueryUpdate {
  const _EntryQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<Entry, Entry, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? createdAt = ignore,
    Object? text = ignore,
    Object? photoPath = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (createdAt != ignore) 1: createdAt as DateTime?,
        if (text != ignore) 2: text as String?,
        if (photoPath != ignore) 3: photoPath as String?,
      });
    } finally {
      q.close();
    }
  }
}

extension EntryQueryBuilderUpdate on QueryBuilder<Entry, Entry, QOperations> {
  _EntryQueryUpdate get updateFirst =>
      _EntryQueryBuilderUpdateImpl(this, limit: 1);

  _EntryQueryUpdate get updateAll => _EntryQueryBuilderUpdateImpl(this);
}

extension EntryQueryFilter on QueryBuilder<Entry, Entry, QFilterCondition> {
  QueryBuilder<Entry, Entry, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> idGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> idGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> idLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> idLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> idBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 0, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> createdAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 1, value: value),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition>
  createdAtGreaterThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 1, value: value),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> createdAtLessThan(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 1, value: value));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> createdAtLessThanOrEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 1, value: value),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 1, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> textIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 2));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> textIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 2));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> textEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> textGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> textGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> textLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> textLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> textBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 2,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> textContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> textMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 2,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> photoPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 3));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> photoPathIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 3));
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> photoPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> photoPathGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition>
  photoPathGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> photoPathLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 3, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> photoPathLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> photoPathBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 3,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> photoPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> photoPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> photoPathContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> photoPathMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 3,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> photoPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 3, value: ''),
      );
    });
  }

  QueryBuilder<Entry, Entry, QAfterFilterCondition> photoPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 3, value: ''),
      );
    });
  }
}

extension EntryQueryObject on QueryBuilder<Entry, Entry, QFilterCondition> {}

extension EntryQuerySortBy on QueryBuilder<Entry, Entry, QSortBy> {
  QueryBuilder<Entry, Entry, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByText({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByTextDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByPhotoPath({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> sortByPhotoPathDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension EntryQuerySortThenBy on QueryBuilder<Entry, Entry, QSortThenBy> {
  QueryBuilder<Entry, Entry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByText({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByTextDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByPhotoPath({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QAfterSortBy> thenByPhotoPathDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension EntryQueryWhereDistinct on QueryBuilder<Entry, Entry, QDistinct> {
  QueryBuilder<Entry, Entry, QAfterDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1);
    });
  }

  QueryBuilder<Entry, Entry, QAfterDistinct> distinctByText({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Entry, Entry, QAfterDistinct> distinctByPhotoPath({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3, caseSensitive: caseSensitive);
    });
  }
}

extension EntryQueryProperty1 on QueryBuilder<Entry, Entry, QProperty> {
  QueryBuilder<Entry, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<Entry, DateTime, QAfterProperty> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<Entry, String?, QAfterProperty> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<Entry, String?, QAfterProperty> photoPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }
}

extension EntryQueryProperty2<R> on QueryBuilder<Entry, R, QAfterProperty> {
  QueryBuilder<Entry, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<Entry, (R, DateTime), QAfterProperty> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<Entry, (R, String?), QAfterProperty> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<Entry, (R, String?), QAfterProperty> photoPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }
}

extension EntryQueryProperty3<R1, R2>
    on QueryBuilder<Entry, (R1, R2), QAfterProperty> {
  QueryBuilder<Entry, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<Entry, (R1, R2, DateTime), QOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<Entry, (R1, R2, String?), QOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<Entry, (R1, R2, String?), QOperations> photoPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }
}
