import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../model/contac_model.dart';


class ContactsListController{
  bool loadingFirestoreEnd = false;
  bool longPress = false;
  late Map removeCard;
  bool comeBack = true;
  int countSelect = 0;
  StreamController<List<Contact>> streamContatsList = StreamController.broadcast();

  void disposeStream(){
    streamContatsList.close();
  }

  Future<void> loadingFirestore() async {
    try {
      streamContatsList.sink.add([]);
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      var snapshot = await firestore.collection("Contato").get();
      List<Contact> contacts = snapshot.docs.map((doc) {
        Map<String, dynamic> contact = doc.data();
        return Contact(contact["nome"], contact["telefone"], contact["email"], contact["uid"], contact["fotoUrl"], null, false);
      }).toList();
      contacts.sort((a, b) => a.name!.compareTo(b.name!));
      loadingFirestoreEnd = true;
      streamContatsList.sink.add(contacts);
    } catch (e) {
      log("Erro ao buscar dados: $e");
    }
  }

  Future<bool> onLongPress(List<Contact> contacts, [Contact? contact]) {
    if (longPress) {
      for (var e in contacts) {
        e.isSelected = false;
      }
      countSelect = 0;
      longPress = false;
      streamContatsList.sink.add(contacts);
      return Future.value(false);
    } else {
      contact?.isSelected = true;
      countSelect = 1;
      longPress = true;
      streamContatsList.sink.add(contacts);
      return Future.value(true);
    }
  }
  
  void callPhone(String phone) async{
    String telephoneNumber = phone.replaceAll(" ", "");
    String telephoneUrl = "tel:$telephoneNumber";
    if (await canLaunchUrlString(telephoneUrl)) {
      await launchUrlString(telephoneUrl);
    } else {
      throw "Ocorreu um erro ao tentar ligar para esse número.";
    }
  }

  void sendSms(String phone) async{
    String telephoneNumber = phone.replaceAll(" ", "");
      String smsUrl = "sms:$telephoneNumber";
      if (await canLaunchUrlString(smsUrl)) {
        await launchUrlString(smsUrl);
      } else {
        throw "Ocorreu um erro ao tentar enviar uma mensagem para esse número.";
      }
  }

  Future<String> deleteImageStorage(String uid) async{
    final FirebaseStorage storage = FirebaseStorage.instance;
    String ref = "images/$uid";
    await storage.ref(ref).delete();
    return ref;
  }

  void listUptade(List<Contact> contacts) {
    streamContatsList.sink.add(contacts);
  }

  void selectContact (Contact contact, List<Contact> contacts) {
    if(contact.isSelected) {
      contact.isSelected = false;
      streamContatsList.sink.add(contacts);
      countSelect = countSelect - 1;
      if(countSelect == 0) {
        longPress = false;
      }
    } else {
      contact.isSelected = true;
      streamContatsList.sink.add(contacts);
      countSelect = countSelect + 1;
    }
  }

  void deleteContactsSelecteds(BuildContext context, List<Contact> contacts) {
    List<Contact> selectedContacts = contacts.where((e) => e.isSelected == true).toList();
    for(var contact in selectedContacts) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore.collection("Contato").doc(contact.uid).delete();
      contacts.remove(contact);
      streamContatsList.sink.add(contacts);
    }
    longPress = false;
    Navigator.pop(context);
  }
}