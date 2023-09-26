import 'package:objectbox/objectbox.dart';

@Entity()
class OtherContact {
  @Id()
  int id = 0;

  final ToOne<Address> address = ToOne<Address>();

  String? name;
  String? phone;
  String? email;
  
  @Property(type: PropertyType.date)
  DateTime? date;

  @Transient()
  int? computedProperty;

  OtherContact({this.name, this.phone, this.email});

  factory OtherContact.fromJson(Map contact) {
    return OtherContact(
      name: contact["name"],
      phone: contact["phone"],
      email: contact["email"]
    )..address.target = Address.fromJson(contact["address"]);
  }
}

@Entity()
class Address{
  @Id()
  int id = 0;

  final ToOne<Geo> geo = ToOne<Geo>();
  
  String? street;
  String? suite;
  String? city;

  @Property(type: PropertyType.date)
  DateTime? date;

  @Transient()
  int? computedProperty;

  Address({this.street, this.suite, this.city});

  factory Address.fromJson(Map address) {
    return Address(
      street: address["street"],
      suite: address["suite"],
      city: address["city"]
    )..geo.target = Geo.fromJson(address["geo"]);
  }
}

@Entity()
class Geo {
  @Id()
  int id = 0;

  String? lat;
  String? lng;

  @Property(type: PropertyType.date)
  DateTime? date;

  @Transient()
  int? computedProperty;

  Geo({this.lat, this.lng});

  factory Geo.fromJson(Map geo) {
    return Geo(
      lat: geo["lat"],
      lng: geo["lng"]
    );
  }
}

