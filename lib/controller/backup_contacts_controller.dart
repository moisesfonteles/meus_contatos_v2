
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
  List<OtherContact> listJson = [];
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

  Future<void> loadingDatabase() async{
    List<OtherContact> listDB = (await getTheContacts()).map((e) => OtherContact.fromJson(e)).toList();
    behaviorListOtherContacts.sink.add(listDB);
    if(listDB.isNotEmpty){
      streamDownloadFinished.sink.add(true);
    } else {
      streamDownloadFinished.sink.add(false);
    }
    
  }

  Future<void> consumeDataJson() async {
    final future = await get(uri);
    listJson = (jsonDecode(future.body) as List).map((e) => OtherContact.fromJson(e)).toList();
    objectBox.putManyOtherContact(listJson);
    listJson.sort((a, b) => a.name!.compareTo(b.name!));
    behaviorListOtherContacts.sink.add(listJson);
    streamDownloadFinished.sink.add(true);
  }

  Future<void> insertTheContacts(List<OtherContact> contactJson) async{
    Database db = await DB.instance.database();
    await db.rawQuery(
        "DELETE FROM contact;"
      );
    await db.rawQuery(
        "DELETE FROM address;"
      );
    await db.rawQuery(
        "DELETE FROM geo;"
      );

    for(int i = 0; i < contactJson.length; i++){
      await db.rawInsert(
          "INSERT INTO contact (name, phone, email, contact_id) VALUES ('${contactJson[i].name}', '${contactJson[i].phone}', '${contactJson[i].email}', '${contactJson[i].id}');"
      );
      await db.rawInsert(
          "INSERT INTO address (suite, street, city, contact_id) VALUES ('${contactJson[i].address!.suite}', '${contactJson[i].address!.street}', '${contactJson[i].address!.city}', '${contactJson[i].id}');"
      );
      await db.rawInsert(
          "INSERT INTO geo (lat, lng, contact_id) VALUES ('${contactJson[i].address!.geo!.lat}', '${contactJson[i].address!.geo!.lng}', '${contactJson[i].id}')"
      );
    }
  }
}
//https://jsonplaceholder.typicode.com/users