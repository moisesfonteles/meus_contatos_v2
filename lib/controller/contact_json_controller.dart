import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:meus_contatos/extension/extension.dart';
import 'package:meus_contatos/model/other_contacts_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../database/db.dart';


class ContactJsonController {
  final formKey = GlobalKey<FormState>();
  bool editingContact = false;
  StreamController<bool> streamEditingContact = StreamController<bool>.broadcast();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController lngController = TextEditingController();

  void disposeStream(){
    streamEditingContact.close();
  }

  void clickEditContact(){
    editingContact = !editingContact;
    streamEditingContact.sink.add(editingContact);
  }

  String? validatorName(String? value){
    value = value?.trim();
    if(value == null || value.isEmpty){
      return "Nome obrigatório";
    }
    return null;
  }

  String? validatorPhone(String? value){
    value = value?.trim();
    if(value == null || value.isEmpty){
      return "Telefone obrigatório";
    }
    return null;
  }

  String? validatorEmail(String? value){
    if(value!.isNotEmpty){
      if(value.contains("@") && (value.contains("."))){
        return null;
      } else{
        return "email inválido";
      }
    } else{
      return null;
    }
  }

  void clickSaveContact(OtherContact otherContact) async{
    Database db = await DB.instance.database();
    if(formKey.currentState?.validate() ?? false) {
      otherContact.name = nameController.text.capitalizeWords();
      otherContact.phone = phoneController.text;
      otherContact.email = emailController.text;
      otherContact.address!.suite = addressController.text;
      otherContact.address!.street = "";
      otherContact.address!.city = "";
      DB.instance.updateTheContacts(db, otherContact.name!, otherContact.phone!, otherContact.email!, otherContact.address!.suite!, otherContact.address!.street!, otherContact.address!.city!, otherContact.address!.geo!.lat!, otherContact.address!.geo!.lng!, otherContact.id!);
    }
    clickEditContact();
  }

  Future<void> deleteContact(int index, BuildContext context, OtherContact otherContact) async{
    NavigatorState navigator = Navigator.of(context);
    Database db = await DB.instance.database();
    navigator.pop();
    navigator.pop();
    DB.instance.deleteTheContact(db, otherContact.id!);
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

  void sendEmail(String email) async{
    String emaill = email;
    String subject = 'Este é um e-mail teste';
    String body = 'Este é um corpo de um e-mail teste';   
    String emailUrl = "mailto:$emaill?subject=$subject&body=$body";
    if (await canLaunchUrlString(emailUrl)) {
      await launchUrlString(emailUrl);
    }
  }
}