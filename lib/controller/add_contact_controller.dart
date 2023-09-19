import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meus_contatos/extension/extension.dart';
import 'package:meus_contatos/ui/camera_page.dart';
import 'package:uuid/uuid.dart';

import '../model/contac_model.dart';

class AddContactController{
  var maskFormatter = MaskTextInputFormatter(
    mask: '+## (##) # ####-####',
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy
  );
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  StreamController<bool> streamButtonAdd = StreamController.broadcast();
  StreamController<File?> streamPhoto = StreamController.broadcast();
  ImagePicker imagePicker = ImagePicker();
  File? photoProfile;
  String? profileUrl;
  bool uploadPhotoLoading = false;
  bool comeBack = true;

  void disposeStream() {
    streamButtonAdd.close();
    streamPhoto.close();
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

  void clickAddContact(BuildContext context) async{
    NavigatorState navigator = Navigator.of(context);
    comeBack = false;
    if(formKey.currentState?.validate() ?? false){
      String uid = const Uuid().v4();
      if(photoProfile != null) {
        uploadPhotoLoading = true;
        streamButtonAdd.sink.add(uploadPhotoLoading);
        profileUrl = await uploadImage(photoProfile!.path, uid);
      }
      Map<String, dynamic> contact = {
        "nome": nameController.text.trim().capitalizeWords(),
        "telefone": phoneController.text,
        "email": emailController.text.toLowerCase().replaceAll(" ", ""),
        "uid": uid,
        "fotoUrl": profileUrl
      };
      Contact addContactObject = Contact(contact["nome"], contact["telefone"], contact["email"], contact["uid"], contact["fotoUrl"], null, false);
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore.collection("Contato").doc(uid).set({
        "nome": nameController.text.trim().capitalizeWords(),
        "telefone": phoneController.text,
        "email": emailController.text.toLowerCase(),
        "uid": uid,
        "fotoUrl": profileUrl
      });
      nameController.clear();
      phoneController.clear();
      emailController.clear();
      navigator.pop(addContactObject);
    }
    comeBack = true;
  }

  Future<void> captureImageCamera(BuildContext context) async{
    NavigatorState navigator = Navigator.of(context);
    File? file =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  CameraPage(photoCamera: photoProfile)),
    );
    photoProfile = file;
    streamPhoto.sink.add(photoProfile);
    navigator.pop();
  }

  Future<void> takeImageGallery(BuildContext context) async{
    NavigatorState navigator = Navigator.of(context);
    final XFile? imageGallery = await imagePicker.pickImage(source: ImageSource.gallery);
    if(imageGallery != null){ 
      photoProfile = File(imageGallery.path);
      streamPhoto.sink.add(photoProfile);
      log("$photoProfile");
    }
    navigator.pop();
  }


  Future<void> removeImage(BuildContext context) async{
    NavigatorState navigator = Navigator.of(context);
    if(photoProfile != null){
      if(await File(photoProfile!.path).exists()){
        await File(photoProfile!.path).delete();
          photoProfile = null;
          streamPhoto.sink.add(photoProfile);
      }
    }
    navigator.pop();
    navigator.pop();
  }

  Future<String> uploadImage(String path, String uid) async{
    final FirebaseStorage storage = FirebaseStorage.instance;
    File file = File(path);
    String ref = "images/$uid";
    TaskSnapshot taskSnapshot = await storage.ref(ref).putFile(file);
    String profile = await taskSnapshot.ref.getDownloadURL();
    return profile;
  }
}