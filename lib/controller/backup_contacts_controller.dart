
import 'dart:async';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:meus_contatos/database/db.dart';
import 'dart:convert';
import 'package:meus_contatos/model/other_contacts_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';

class BackupContactsController {
  StreamController<bool> streamDownloadFinished = StreamController<bool>.broadcast();
  StreamController<OtherContact> streamOtherContact = StreamController<OtherContact>.broadcast();
  BehaviorSubject<List<OtherContact>> behaviorListOtherContacts = BehaviorSubject<List<OtherContact>>();
  List<OtherContact> listJson = [];
  
  Uri uri = Uri.https("jsonplaceholder.typicode.com" , "/users");

  void disposeStream(){
    streamDownloadFinished.close();
    streamOtherContact.close();
  }

  Future<void> consumeDataJson() async {
    final future = await get(uri);
    listJson = (jsonDecode(future.body) as List).map((e) => OtherContact.fromJson(e)).toList();
    await insertTheContacts(listJson);
    await getTheContacts(listJson);
    behaviorListOtherContacts.sink.add(listJson);
    streamDownloadFinished.sink.add(true);

  }

  Future<List<Map>> getTheContacts(List<OtherContact> contactJsonS) async{ // printa dados do banco
    Database db = await DB.instance.database();
    List<Map> list = await db.rawQuery("SELECT * FROM contact");
    log("$list");
    return list;
  }

  Future<void> insertTheContacts(List<OtherContact> contactJson) async{
    Database db = await DB.instance.database();
    await db.rawQuery(
      "DELETE FROM contact"
    );
    for(int i = 0; i < contactJson.length; i++){
      await db.rawInsert(
        "INSERT INTO contact(name, phone, email, contact_id) VALUES('${contactJson[i].name}', '${contactJson[i].phone}', '${contactJson[i].email}', '${contactJson[i].id}');"
      );
    }
  }
}
//https://jsonplaceholder.typicode.com/users