import 'package:objectbox/objectbox.dart';

@Entity()
class OtherContact {
  @Id()
  int id = 0;

  String? name;
  String? phone;
  String? email;
  Address? address;
  
  @Property(type: PropertyType.date)
  DateTime? date;

  @Transient()
  int? computedProperty;

  OtherContact({this.name, this.phone, this.email, this.address});

  factory OtherContact.fromJson(Map contact) {
    return OtherContact(
      name: contact["name"],
      phone: contact["phone"],
      email: contact["email"],
      address: Address.fromJson(contact["address"])
    );
  }
}

@Entity()
class Address{
  @Id()
  int? id;
  
  String? street;
  String? suite;
  String? city;
  Geo? geo;

  @Property(type: PropertyType.date)
  DateTime? date;

  @Transient()
  int? computedProperty;

  Address({this.id,this.street, this.suite, this.city, this.geo});

  factory Address.fromJson(Map address) {
    return Address(
      street: address["street"],
      suite: address["suite"],
      city: address["city"],
      geo: Geo.fromJson(address["geo"])
    );
  }
}

@Entity()
class Geo {
  @Id()
  int? id;

  String? lat;
  String? lng;

  @Property(type: PropertyType.date)
  DateTime? date;

  @Transient()
  int? computedProperty;

  Geo({this.id, this.lat, this.lng});

  factory Geo.fromJson(Map geo) {
    return Geo(
      lat: geo["lat"],
      lng: geo["lng"]
    );
  }
}

