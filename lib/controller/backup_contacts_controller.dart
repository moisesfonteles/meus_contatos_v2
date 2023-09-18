
import 'dart:async';
import 'dart:developer';
import 'package:http/http.dart' as http;
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

  Future<List<dynamic>> consumeDataJson() async {
    final future = await http.get(uri);
    listJson = (jsonDecode(future.body)as List).map((e) {
      return OtherContact.fromJson(e);
    }).toList();
    log(future.body);
    behaviorListOtherContacts.sink.add(listJson);
    streamDownloadFinished.sink.add(true);
    return jsonDecode(future.body);
  }
}
//https://jsonplaceholder.typicode.com/users