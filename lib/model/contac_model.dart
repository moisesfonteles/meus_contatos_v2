import 'dart:io';

class Contact{
  String? name;
  String? phone;
  String? email;
  String? uid;
  String? profileUrl;
  File? photoProfile;
  bool isSelected = false;

  Contact(this.name, this.phone, this.email, this.uid, this.profileUrl, this.photoProfile, this.isSelected);
}
