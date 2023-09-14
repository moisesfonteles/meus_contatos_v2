import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';

import 'package:meus_contatos/model/other_contacts_model.dart';

class BackupContactsController {
  Uri uri = Uri.https("jsonplaceholder.typicode.com" , "/users");

  Future<List<dynamic>> consumeDataJson() async {
    final future = await http.get(uri);
    List listJson = (jsonDecode(future.body)as List).map((e) => OtherContact.fromJson(e)).toList();
    listJson;
    log("${jsonDecode(future.body)}");
    return jsonDecode(future.body);
  }
}
//https://jsonplaceholder.typicode.com/users