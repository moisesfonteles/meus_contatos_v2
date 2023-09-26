import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:meus_contatos/extension/extension.dart';
import 'package:meus_contatos/model/other_contacts_model.dart';
import 'package:meus_contatos/repositories/objectbox_repository.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
  OtherContactRepository objectBox = OtherContactRepository();

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

  void clickSaveContact(OtherContact otherContact) {
    if(formKey.currentState?.validate() ?? false) {
      otherContact.name = nameController.text.capitalizeWords();
      otherContact.phone = phoneController.text;
      otherContact.email = emailController.text;
      otherContact.address.target!.suite = addressController.text;
      otherContact.address.target!.street = "";
      otherContact.address.target!.city = "";
    }
    objectBox.putOtherContact(otherContact);
    clickEditContact();
  }

  void deleteContact(int index, BuildContext context, OtherContact otherContact) {
    objectBox.removeOtherContact(otherContact);
    Navigator.pop(context);
    Navigator.pop(context);
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