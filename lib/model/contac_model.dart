import 'dart:io';

class Contact{
  String? name;
  String? phone;
  String? email;
  String? uid;
  String? profileUrl;
  File? photoProfile;
  bool isSelected = false;
  Address? address;
  Geo? geo;

  Contact(this.name, this.phone, this.email, this.uid, this.profileUrl, this.photoProfile, this.isSelected, {this.address, this.geo});
}

class Address{

}

class Geo{

}