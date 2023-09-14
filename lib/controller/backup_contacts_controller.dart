import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';

class BackupContactsController {
  Uri uri = Uri.https("jsonplaceholder.typicode.com" , "/users");

  Future<List<dynamic>> consumeDataJson() async {
    final future = await http.get(uri);
    log("${jsonDecode(future.body)}");
    return jsonDecode(future.body);
  }

  
}
//https://jsonplaceholder.typicode.com/users