import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:meus_contatos/controller/add_contact_controller.dart';
import 'package:meus_contatos/extension/extension.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../ui/camera_page.dart';
import '../model/contac_model.dart';

class ContactController{
  var maskFormatter = MaskTextInputFormatter(
    mask: '+## (##) # ####-####',
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy
  );
  final formKey = GlobalKey<FormState>();
  List<Contact> contacts = [];
  AddContactController addContactController = AddContactController();
  bool editingContact = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  StreamController<bool> streamEditContact = StreamController.broadcast();
  StreamController<bool> streamUploadPhoto = StreamController.broadcast();
  StreamController<File?> streamPhotoProfile = StreamController.broadcast();
  int index = 0;
  ImagePicker imagePicker = ImagePicker();
  File? photoProfile;
  String? profileUrl;
  bool uploadPhotoLoading = false;
  bool comeBack = true;
  bool removedImage = false;

  void disposeStream(){
    streamEditContact.close();
    streamUploadPhoto.close();
    streamPhotoProfile.close();
  }

  void clickEditContact(){
    if(editingContact){
      editingContact = false;
      streamEditContact.sink.add(editingContact);
    } else{
      editingContact = true;
      streamEditContact.sink.add(editingContact);
    }
  }
  
  void uploadingPhoto() {
    if(uploadPhotoLoading) {
      uploadPhotoLoading = false;
      streamUploadPhoto.sink.add(uploadPhotoLoading);
    } else{
      uploadPhotoLoading = true;
      streamUploadPhoto.sink.add(uploadPhotoLoading);
    }
  }

  String? validatorName(String? value){
    value = value?.trim();
    if(value == null || value.isEmpty){
      return "Nome obrigatório";
    }
    return null;
  }

  String? validatorPhone(String? value) {
    int count = value!.length;
    if(value.isEmpty || count < 20){
      return "Telefone obrigatório";
    }
    return null;
  }

  String? validatorEmail(String? value){
    if(value!.isNotEmpty){
      if(value.contains("@") && (value.contains(".com") || value.contains(".br"))){
        return null;
      } else{
        return "email inválido";
      }
    } else{
      return null;
    }
  }

  Future<void> clickSaveContact(Contact contact, BuildContext context,) async{
    comeBack = false;
    if (formKey.currentState?.validate() ?? false) {
      if(contact.profileUrl == null && photoProfile != null) {
        profileUrl = await uploadImage(photoProfile!.path, contact.uid as String);
        contact.profileUrl = profileUrl;
        photoProfile = null;
      } else if(contact.profileUrl != null && photoProfile != null) {
        profileUrl = await uploadImage(photoProfile!.path, contact.uid as String);
        contact.profileUrl = profileUrl;
        photoProfile = null;
      } else if(contact.profileUrl != null && photoProfile == null) {
        contact.profileUrl = profileUrl;
      } else if(contact.profileUrl == null && photoProfile == null){
        if(removedImage == true) {
          log("removedImage é $removedImage");
          profileUrl = null;
          contact.profileUrl = profileUrl;
          deleteImageStorage(contact.uid as String);
        }
      }
      contact.name = nameController.text.trim().capitalizeWords();
      contact.phone = phoneController.text;
      contact.email = emailController.text.toLowerCase().replaceAll(" ", "");
      contact.photoProfile = photoProfile;
      contacts.sort((a, b) => a.name!.compareTo(b.name!));
      editingContact = false;
      streamEditContact.sink.add(editingContact);
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore.collection("Contato").doc(contact.uid).update({
        "nome": nameController.text.trim().capitalizeWords(), "telefone": phoneController.text, "email": emailController.text.toLowerCase(), "fotoUrl": profileUrl
      });
    }
    comeBack = true;
    removedImage = false;
  }

  void deleteContact(int index, BuildContext context, Contact contact){
    Navigator.pop(context);
    Navigator.pop(context);
    contacts.removeAt(index);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection("Contato").doc(contact.uid).delete();
    if(contact.profileUrl != null) {
      deleteImageStorage(contact.uid as String);
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

  void sendEmail(String email) async{
    String emaill = email;
    String subject = 'Este é um e-mail teste';
    String body = 'Este é um corpo de um e-mail teste';   
    String emailUrl = "mailto:$emaill?subject=$subject&body=$body";
    if (await canLaunchUrlString(emailUrl)) {
      await launchUrlString(emailUrl);
    }
  }

  Future<void> captureImageCamera(BuildContext context) async{
    NavigatorState navigator = Navigator.of(context);
    File? file =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  CameraPage(photoCamera: photoProfile)),
    );
    photoProfile = file;
    streamPhotoProfile.sink.add(photoProfile);
    navigator.pop();
  }

  Future<void> takeImageGallery(context) async{
    NavigatorState navigator = Navigator.of(context);
    final XFile? imageGallery = await imagePicker.pickImage(source: ImageSource.gallery);
    if(imageGallery != null){ 
      photoProfile = File(imageGallery.path);
    }
    streamPhotoProfile.sink.add(photoProfile);
    navigator.pop();
  }

  Future<void> removeImage(Contact contact) async{
    if(contact.profileUrl != null && photoProfile == null) {
      contact.profileUrl = null;
      comeBack = false;
    } else if(contact.profileUrl != null && photoProfile != null) {
      contact.profileUrl = null;
      await File(photoProfile!.path).delete();
      photoProfile = null;
      comeBack = false;
    } else if(contact.profileUrl == null && photoProfile != null) {
      await File(photoProfile!.path).delete();
      photoProfile = null;
    }
    streamPhotoProfile.sink.add(photoProfile);
  }

  Future<String> uploadImage(String path, String uid) async{
    final FirebaseStorage storage = FirebaseStorage.instance;
    File file = File(path);
    String ref = "images/$uid";
    TaskSnapshot taskSnapshot = await storage.ref(ref).putFile(file);
    String profile = await taskSnapshot.ref.getDownloadURL();
    return profile;
  }

  Future<String> deleteImageStorage(String uid) async{
    final FirebaseStorage storage = FirebaseStorage.instance;
    String ref = "images/$uid";
    await storage.ref(ref).delete();
    return ref;
  }
}