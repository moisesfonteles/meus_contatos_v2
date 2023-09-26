
import 'dart:async';
import 'package:http/http.dart';
import 'package:meus_contatos/database/db.dart';
import 'dart:convert';
import 'package:meus_contatos/model/other_contacts_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:meus_contatos/repositories/objectbox_repository.dart';

class BackupContactsController {
  StreamController<bool> streamDownloadFinished = StreamController<bool>.broadcast();
  StreamController<OtherContact> streamOtherContact = StreamController<OtherContact>.broadcast();
  BehaviorSubject<List<OtherContact>> behaviorListOtherContacts = BehaviorSubject<List<OtherContact>>();
  List<OtherContact> listOtherContact = [];
  List<Address> listAddress = [];
  List<Geo> listGeo = [];
  OtherContactRepository objectBox = OtherContactRepository();
  
  Uri uri = Uri.https("jsonplaceholder.typicode.com" , "/users");

  void disposeStream(){
    streamDownloadFinished.close();
    streamOtherContact.close();
  }

  Future<List<Map>> getTheContacts() async{
    Database db = await DB.instance.database();
    List<Map> listDB = await db.rawQuery("SELECT * FROM contact c join address a on c.contact_id = a.contact_id join geo g on c.contact_id = g.contact_id;");
    List<Map> newListDB = [];
    for (var e in listDB) {
      Map<String, dynamic> contact = {
        "id": e["id"],
        "name": e["name"],
        "phone": e["phone"],
        "email": e["email"],
        "contact_id": e["contact_id"],
        "address": {
          "suite": e["suite"],
          "street": e["street"],
          "city": e["city"],
          "geo": {
            "lat": e["lat"],
            "lng": e["lng"]
          }
        }
      };
      newListDB.add(contact);
    }
    newListDB.sort((a, b) => a["name"]!.compareTo(b["name"]!));
    return newListDB;
  }

  void loadingObjectBox() {
    listOtherContact = objectBox.getManyOtherContact();
    listOtherContact.sort((a, b) => a.name!.compareTo(b.name!));
    behaviorListOtherContacts.sink.add(listOtherContact);
  }

  Future<void> consumeDataJson() async {
    objectBox.removeAllOtherContact();
    final future = await get(uri);
    listOtherContact = (jsonDecode(future.body) as List).map((e) => OtherContact.fromJson(e)).toList();
    objectBox.putManyOtherContact(listOtherContact);
    listOtherContact.sort((a, b) => a.name!.compareTo(b.name!));
    behaviorListOtherContacts.sink.add(listOtherContact);
    streamDownloadFinished.sink.add(true);
  }
}
//https://jsonplaceholder.typicode.com/users