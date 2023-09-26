

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meus_contatos/ui/contacts_list_page.dart';
import 'database/db.dart';
import 'database/objectbox_database.dart';
import 'firebase/firebase_options.dart';

late ObjectBox objectbox;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await ObjectBox.create();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  DB.instance.getTheContacts(await DB.instance.database());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const ContactsListPage(),
    )
  );
}
