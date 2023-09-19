
import 'dart:async';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:meus_contatos/model/other_contacts_model.dart';
import 'package:rxdart/rxdart.dart';

class BackupContactsController {
  StreamController<bool> streamDownloadFinished = StreamController<bool>.broadcast();
  BehaviorSubject<List<OtherContact>> behaviorListOtherContacts = BehaviorSubject<List<OtherContact>>();
  List<OtherContact> listJson = [];
  Uri uri = Uri.https("jsonplaceholder.typicode.com" , "/users");

  void disposeStream(){
    streamDownloadFinished.close();
    streamDownloadFinished.close();
  }

  Future<void> consumeDataJson() async {
    final future = await get(uri);
    listJson = (jsonDecode(future.body)as List).map((e) {
      return OtherContact.fromJson(e);
    }).toList();
    behaviorListOtherContacts.sink.add(listJson);
    streamDownloadFinished.sink.add(true);
  }
}
//https://jsonplaceholder.typicode.com/users