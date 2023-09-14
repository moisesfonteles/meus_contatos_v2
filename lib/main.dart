import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meus_contatos/ui/contacts_list_page.dart';
import 'firebase/firebase_options.dart';
import 'controller/backup_contacts_controller.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  BackupContactsController().consumeDataJson();
  await Firebase.initializeApp( // Isso inicializa o Firebase no aplicativo Flutter.
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
