import 'dart:developer';
import 'package:meus_contatos/main.dart';
import 'package:meus_contatos/model/other_contacts_model.dart';
import 'package:objectbox/objectbox.dart';


final Box<OtherContact> contactsBox = objectbox.store.box<OtherContact>();
late Box<Address> addressBox;
late Box<Geo> geoBox;

class OtherContactRepository {

  void putOtherContact(OtherContact otherContact) {
    contactsBox.put(otherContact);
  }  

  void putManyOtherContact(List<OtherContact> listOtherContact) {
    final contacts = contactsBox.putMany(listOtherContact);
    log("$contacts");
  }

  List<OtherContact> getManyOtherContact() {
    List<OtherContact> listOtherContact = [];
    listOtherContact = contactsBox.getAll();
    log("$listOtherContact");
    return listOtherContact;
  }

  void removeOtherContact(OtherContact otherContact) {
    contactsBox.remove(otherContact.id);
  }

  void removeAllOtherContact() {
    contactsBox.removeAll();
  }
}






