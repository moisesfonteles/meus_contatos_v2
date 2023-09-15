
import 'dart:async';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:meus_contatos/model/other_contacts_model.dart';

class BackupContactsController {
  StreamController<bool> streamDownloadFinished = StreamController<bool>.broadcast();
  StreamController<List<OtherContact>> streamListOtherContacts = StreamController<List<OtherContact>>.broadcast();
  Uri uri = Uri.https("jsonplaceholder.typicode.com" , "/users");

  void disposeStream(){
    streamDownloadFinished.close();
    streamDownloadFinished.close();
  }

  Future<List<dynamic>> consumeDataJson() async {
    final future = await http.get(uri);
    List<OtherContact> listJson = (jsonDecode(future.body)as List).map((e) {
      return OtherContact.fromJson(e);
    }).toList();    
    log("data inicio ${DateTime.now()}");
    streamListOtherContacts.sink.add(listJson);
    streamDownloadFinished.sink.add(true);
    log("data final ${DateTime.now()}");
    return jsonDecode(future.body);
  }
}
//https://jsonplaceholder.typicode.com/users