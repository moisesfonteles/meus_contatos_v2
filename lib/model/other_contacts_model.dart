

class OtherContact {
  String? name;
  String? phone;
  String? email;
  Address? address;

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

class Address{
  String? street;
  String? suite;
  String? city;
  Geo? geo;

  Address({this.street, this.suite, this.city, this.geo});

  factory Address.fromJson(Map address) {
    return Address(
      street: address["street"],
      suite: address["suite"],
      city: address["city"],
      geo: Geo.fromJson(address["geo"])
    );
  }
}

class Geo {
  String? lat;
  String? lng;

  Geo({this.lat, this.lng});

  factory Geo.fromJson(Map geo) {
    return Geo(
      lat: geo["lat"],
      lng: geo["lng"]
    );
  }
}
