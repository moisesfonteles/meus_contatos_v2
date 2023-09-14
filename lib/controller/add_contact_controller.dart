import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:image_picker/image_picker.dart';
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
    comeBack = false;
    if(formKey.currentState?.validate() ?? false){
      String uid = Uuid().v4();
      if(photoProfile != null) {
        uploadPhotoLoading = true;
        streamButtonAdd.sink.add(uploadPhotoLoading);
        profileUrl = await uploadImage(photoProfile!.path, uid);
      }
      Map<String, dynamic> contact = {
        "nome": capitalizeWords(nameController.text.trim()),
        "telefone": phoneController.text,
        "email": emailController.text.toLowerCase().replaceAll(" ", ""),
        "uid": uid,
        "fotoUrl": profileUrl
      };
      Contact addContactObject = Contact(contact["nome"], contact["telefone"], contact["email"], contact["uid"], contact["fotoUrl"], null, false);
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore.collection("Contato").doc(uid).set({
        "nome": capitalizeWords(nameController.text.trim()),
        "telefone": phoneController.text,
        "email": emailController.text.toLowerCase(),
        "uid": uid,
        "fotoUrl": profileUrl
      });
      nameController.clear();
      phoneController.clear();
      emailController.clear();
      Navigator.pop(context, addContactObject);
    }
    comeBack = true;
  }

  Future<void> captureImageCamera(BuildContext context) async{
    File? file =  await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  CameraPage(photoCamera: photoProfile)),
    );
    photoProfile = file;
    streamPhoto.sink.add(photoProfile);
    Navigator.pop(context);
  }

  Future<void> takeImageGallery(BuildContext context) async{
    final XFile? imageGallery = await imagePicker.pickImage(source: ImageSource.gallery);
    if(imageGallery != null){ 
      photoProfile = File(imageGallery.path);
      streamPhoto.sink.add(photoProfile);
      log("$photoProfile");
    }
    Navigator.of(context).pop();
  }


  Future<void> removeImage(BuildContext context) async{
    if(photoProfile != null){
      if(await File(photoProfile!.path).exists()){
        await File(photoProfile!.path).delete();
          photoProfile = null;
          streamPhoto.sink.add(photoProfile);
      }
    }
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Future<String> uploadImage(String path, String uid) async{
    final FirebaseStorage storage = FirebaseStorage.instance;
    File file = File(path);
    String ref = "images/$uid";
    TaskSnapshot taskSnapshot = await storage.ref(ref).putFile(file);
    String profile = await taskSnapshot.ref.getDownloadURL();
    return profile;
  }

  String capitalizeWords(String nameController) {
    List<String> words = nameController.split(" ");
    for(int i = 0; i < words.length; i++){
      if(words[i].isNotEmpty){
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }
    return words.join(" ");
  }
}