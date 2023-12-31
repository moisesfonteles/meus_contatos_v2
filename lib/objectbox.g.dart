// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'model/other_contacts_model.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 3145352345801008460),
      name: 'Address',
      lastPropertyId: const IdUid(7, 8924740731248799412),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 6571009649774535314),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 5945749321450382411),
            name: 'street',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 5140120165379774212),
            name: 'suite',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 4137227745328756356),
            name: 'city',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 933278911113536730),
            name: 'date',
            type: 10,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 8924740731248799412),
            name: 'geoId',
            type: 11,
            flags: 520,
            indexId: const IdUid(3, 1877987824912070109),
            relationTarget: 'Geo')
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(2, 2539061360565244249),
      name: 'Geo',
      lastPropertyId: const IdUid(5, 3402286285426577956),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 2669032772489284683),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 2072396593358217769),
            name: 'lat',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 6808246799189251260),
            name: 'lng',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 5782071693254560446),
            name: 'date',
            type: 10,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(3, 7513325272235705745),
      name: 'OtherContact',
      lastPropertyId: const IdUid(6, 1214416268686140105),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 5731312126480850030),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 7280185488063695026),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 1935672802846154158),
            name: 'phone',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 4677115482012860623),
            name: 'email',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 7172226808607038824),
            name: 'date',
            type: 10,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 1214416268686140105),
            name: 'addressId',
            type: 11,
            flags: 520,
            indexId: const IdUid(4, 5668536433042913766),
            relationTarget: 'Address')
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(3, 7513325272235705745),
      lastIndexId: const IdUid(4, 5668536433042913766),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [4571028938055024345, 7714373750958896774],
      retiredPropertyUids: const [6627392237589385589, 3402286285426577956],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    Address: EntityDefinition<Address>(
        model: _entities[0],
        toOneRelations: (Address object) => [object.geo],
        toManyRelations: (Address object) => {},
        getId: (Address object) => object.id,
        setId: (Address object, int id) {
          object.id = id;
        },
        objectToFB: (Address object, fb.Builder fbb) {
          final streetOffset =
              object.street == null ? null : fbb.writeString(object.street!);
          final suiteOffset =
              object.suite == null ? null : fbb.writeString(object.suite!);
          final cityOffset =
              object.city == null ? null : fbb.writeString(object.city!);
          fbb.startTable(8);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, streetOffset);
          fbb.addOffset(2, suiteOffset);
          fbb.addOffset(3, cityOffset);
          fbb.addInt64(4, object.date?.millisecondsSinceEpoch);
          fbb.addInt64(6, object.geo.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final dateValue =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 12);
          final object = Address(
              street: const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 6),
              suite: const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 8),
              city: const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 10))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..date = dateValue == null
                ? null
                : DateTime.fromMillisecondsSinceEpoch(dateValue);
          object.geo.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 16, 0);
          object.geo.attach(store);
          return object;
        }),
    Geo: EntityDefinition<Geo>(
        model: _entities[1],
        toOneRelations: (Geo object) => [],
        toManyRelations: (Geo object) => {},
        getId: (Geo object) => object.id,
        setId: (Geo object, int id) {
          object.id = id;
        },
        objectToFB: (Geo object, fb.Builder fbb) {
          final latOffset =
              object.lat == null ? null : fbb.writeString(object.lat!);
          final lngOffset =
              object.lng == null ? null : fbb.writeString(object.lng!);
          fbb.startTable(6);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, latOffset);
          fbb.addOffset(2, lngOffset);
          fbb.addInt64(3, object.date?.millisecondsSinceEpoch);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final dateValue =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 10);
          final object = Geo(
              lat: const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 6),
              lng: const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 8))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..date = dateValue == null
                ? null
                : DateTime.fromMillisecondsSinceEpoch(dateValue);

          return object;
        }),
    OtherContact: EntityDefinition<OtherContact>(
        model: _entities[2],
        toOneRelations: (OtherContact object) => [object.address],
        toManyRelations: (OtherContact object) => {},
        getId: (OtherContact object) => object.id,
        setId: (OtherContact object, int id) {
          object.id = id;
        },
        objectToFB: (OtherContact object, fb.Builder fbb) {
          final nameOffset =
              object.name == null ? null : fbb.writeString(object.name!);
          final phoneOffset =
              object.phone == null ? null : fbb.writeString(object.phone!);
          final emailOffset =
              object.email == null ? null : fbb.writeString(object.email!);
          fbb.startTable(7);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addOffset(2, phoneOffset);
          fbb.addOffset(3, emailOffset);
          fbb.addInt64(4, object.date?.millisecondsSinceEpoch);
          fbb.addInt64(5, object.address.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final dateValue =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 12);
          final object = OtherContact(
              name: const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 6),
              phone: const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 8),
              email: const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 10))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..date = dateValue == null
                ? null
                : DateTime.fromMillisecondsSinceEpoch(dateValue);
          object.address.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0);
          object.address.attach(store);
          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [Address] entity fields to define ObjectBox queries.
class Address_ {
  /// see [Address.id]
  static final id = QueryIntegerProperty<Address>(_entities[0].properties[0]);

  /// see [Address.street]
  static final street =
      QueryStringProperty<Address>(_entities[0].properties[1]);

  /// see [Address.suite]
  static final suite = QueryStringProperty<Address>(_entities[0].properties[2]);

  /// see [Address.city]
  static final city = QueryStringProperty<Address>(_entities[0].properties[3]);

  /// see [Address.date]
  static final date = QueryIntegerProperty<Address>(_entities[0].properties[4]);

  /// see [Address.geo]
  static final geo =
      QueryRelationToOne<Address, Geo>(_entities[0].properties[5]);
}

/// [Geo] entity fields to define ObjectBox queries.
class Geo_ {
  /// see [Geo.id]
  static final id = QueryIntegerProperty<Geo>(_entities[1].properties[0]);

  /// see [Geo.lat]
  static final lat = QueryStringProperty<Geo>(_entities[1].properties[1]);

  /// see [Geo.lng]
  static final lng = QueryStringProperty<Geo>(_entities[1].properties[2]);

  /// see [Geo.date]
  static final date = QueryIntegerProperty<Geo>(_entities[1].properties[3]);
}

/// [OtherContact] entity fields to define ObjectBox queries.
class OtherContact_ {
  /// see [OtherContact.id]
  static final id =
      QueryIntegerProperty<OtherContact>(_entities[2].properties[0]);

  /// see [OtherContact.name]
  static final name =
      QueryStringProperty<OtherContact>(_entities[2].properties[1]);

  /// see [OtherContact.phone]
  static final phone =
      QueryStringProperty<OtherContact>(_entities[2].properties[2]);

  /// see [OtherContact.email]
  static final email =
      QueryStringProperty<OtherContact>(_entities[2].properties[3]);

  /// see [OtherContact.date]
  static final date =
      QueryIntegerProperty<OtherContact>(_entities[2].properties[4]);

  /// see [OtherContact.address]
  static final address =
      QueryRelationToOne<OtherContact, Address>(_entities[2].properties[5]);
}
