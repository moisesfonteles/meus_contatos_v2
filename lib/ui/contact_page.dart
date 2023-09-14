


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meus_contatos/controller/contact_controller.dart';

import '../model/contac_model.dart';

class ContactPage extends StatefulWidget {
  List<Contact> contacts;
  Contact contact;
  int index;
  ContactPage({super.key,required this.contacts, required this.contact, required this.index});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final ContactController _controller = ContactController();

  @override
  void initState() {
    _controller.nameController.text = widget.contact.name as String;
    _controller.contacts = widget.contacts;
    _controller.phoneController.text = widget.contact.phone as String;
    _controller.emailController.text = widget.contact.email as String;
    _controller.profileUrl = widget.contact.profileUrl;
    _controller.index = widget.index;
    super.initState();
  }

  @override
  void dispose() {
    _controller.disposeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _controller.comeBack,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(widget.contact.name as String),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: profileContact(),
          ),
        ),
      ),
    );
  }

  Widget profileContact(){
    return Form(
      key: _controller.formKey,
      child: StreamBuilder<bool>(
        stream: _controller.streamEditContact.stream,
        initialData: false,
        builder: (context, snapshot) {
          return ListView(
            children: [
              Column(
                children: [
                  if(snapshot.data!) ...{
                    Center(
                      child: StreamBuilder(
                        stream: _controller.streamPhotoProfile.stream,
                        builder: (context, snapshot) {
                          return Stack(
                            children: [
                              if(widget.contact.profileUrl == null && snapshot.data == null) ...{
                                CircleAvatar(
                                  maxRadius: 55,
                                  backgroundColor: Colors.grey[100],
                                  child: const CircleAvatar(backgroundColor: Colors.purple, maxRadius: 50, child: Icon(Icons.person, size: 70))
                                ),
                              } else ...{
                                CircleAvatar(
                                  maxRadius: 55,
                                  backgroundColor: Colors.grey[100],
                                  child: CircleAvatar(
                                    backgroundColor: Colors.purple,
                                    foregroundImage: (snapshot.data != null ?  FileImage(_controller.photoProfile!) : NetworkImage(widget.contact.profileUrl as String) as ImageProvider<Object>),
                                    maxRadius: 50,
                                    child: CircularProgressIndicator(color: Colors.white),
                                  ),
                                ),
                              },
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                      context: context,
                                      builder: (BuildContext context) => containershowModalBottomSheet()
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey[100],
                                    maxRadius: 24,
                                    child: CircleAvatar(backgroundColor: Colors.purple[200], maxRadius: 20, child: const Icon(Icons.add_a_photo_rounded, size: 20,  color: Colors.purple),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      ),             
                    ),
                    const SizedBox(width: 8, height: 16),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _controller.nameController,
                      decoration: const InputDecoration(border: OutlineInputBorder(),labelText: "Nome"),
                      validator:(String? value) => _controller.validatorName(value),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _controller.phoneController,
                      decoration: const InputDecoration(border: OutlineInputBorder(),labelText: "Telefone", hintText: "+99 (99) 9 9999-9999"),
                      validator:(String? value) => _controller.validatorPhone(value),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, _controller.maskFormatter],
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _controller.emailController,
                      decoration: const InputDecoration(border: OutlineInputBorder(),labelText: "E-mail (Opcional)",hintText: "nome@email.com"),
                      onEditingComplete: _controller.uploadPhotoLoading ? () {} : () async {
                        _controller.uploadingPhoto();
                        await _controller.clickSaveContact(widget.contact, context);
                        _controller.uploadingPhoto();
                      },
                      textInputAction: TextInputAction.done,
                      validator: (String? value) => _controller.validatorEmail(value),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: StreamBuilder<bool>(
                            stream: _controller.streamUploadPhoto.stream,
                            builder: (context, snapshot) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(fixedSize:  Size(double.maxFinite, 60)),
                                onPressed: _controller.uploadPhotoLoading ? () {} : () {
                                  _controller.clickEditContact();
                                  _controller.nameController.text = widget.contact.name as String;
                                  _controller.phoneController.text = widget.contact.phone as String;
                                  _controller.emailController.text = widget.contact.email as String;                         
                                  widget.contact.profileUrl = _controller.profileUrl;
                                  _controller.photoProfile = null;
                                  _controller.comeBack = true;
                                },
                                child: const Text("Cancelar", style: TextStyle(fontSize: 16)),
                              );
                            }
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: StreamBuilder<bool>(
                            stream: _controller.streamUploadPhoto.stream,
                            builder: (context, snapshot) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(fixedSize:  Size(double.maxFinite, 60)),
                                onPressed: _controller.uploadPhotoLoading ? () {} : () async {
                                  _controller.uploadingPhoto();
                                  await _controller.clickSaveContact(widget.contact, context);
                                  _controller.uploadingPhoto();
                                },
                                child: _controller.uploadPhotoLoading ? CircularProgressIndicator(color: Colors.white) : const Text("Salvar", style: TextStyle(fontSize: 16)),
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                  } else ...{
                    if(widget.contact.profileUrl == null && _controller.photoProfile == null) ...{
                      CircleAvatar(
                        backgroundColor: Colors.grey[100],
                        maxRadius: 55,
                        child: CircleAvatar(backgroundColor: Colors.purple, maxRadius: 50, child: Icon(Icons.person,size: 70)),
                      ),
                    } else ...{
                      CircleAvatar(
                        maxRadius: 55,
                        backgroundColor: Colors.grey[100],
                        child: StreamBuilder<File?>(
                          stream: _controller.streamPhotoProfile.stream,
                          builder: (context, snapshot) {
                            return CircleAvatar(
                              backgroundColor: Colors.purple,
                              foregroundImage: (_controller.photoProfile != null ?  FileImage(_controller.photoProfile!) : NetworkImage(widget.contact.profileUrl as String) as ImageProvider<Object>),
                              maxRadius: 50,
                              child: CircularProgressIndicator(color: Colors.white),
                            );
                          }
                        ),
                      ),
                    },
                    SizedBox(height: 16.0),
                    Text(widget.contact.name as String, textAlign: TextAlign.center, style: const TextStyle(fontSize: 25)),
                    SizedBox(height: 12.0),
                    Text(widget.contact.phone as String, style: const TextStyle(fontSize: 19)),
                    if(widget.contact.email!.isNotEmpty) ...{
                      SizedBox(height: 12.0),
                      Text(widget.contact.email as String, textAlign: TextAlign.center, style: const TextStyle(fontSize: 19)),
                    },
                    const SizedBox(height: 20.0),
                    Container(
                      height: 2,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      color: Colors.grey.shade200,
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => _controller.callPhone(widget.contact.phone as String),
                          child: const CircleAvatar(backgroundColor: Colors.green,child: Icon(Icons.phone, color: Colors.white)),
                        ),
                        const SizedBox(width: 16.0),
                        InkWell(
                          onTap:() => _controller.sendSms(widget.contact.phone as String),
                          child: const CircleAvatar(backgroundColor: Colors.blue,child: Icon(Icons.message, color: Colors.white)),
                        ),
                        if(widget.contact.email!.isNotEmpty) ...{
                          const SizedBox(width: 16.0),
                          InkWell(
                            onTap: () => _controller.sendEmail(widget.contact.email as String),
                            child: CircleAvatar(backgroundColor: Colors.pink[300],child: const Icon(Icons.email, color: Colors.white)),
                          ),
                        },
                        const SizedBox(width: 16.0),
                        InkWell(
                          onTap:() {
                            _controller.clickEditContact();
                          },
                          child: const CircleAvatar(backgroundColor: Colors.orange,child: Icon(Icons.edit, color: Colors.white)),
                        ),
                        const SizedBox(width: 16.0),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Excluir este contato?"),
                                content: const Text("Você tem certeza que deseja excluir este contato?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }, 
                                    style: TextButton.styleFrom(foregroundColor: Colors.purple[700]),
                                    child: const Text("Cancelar"),
                                  ),
                                  TextButton(
                                    onPressed: () => _controller.deleteContact(_controller.index, context, widget.contact),
                                    style: TextButton.styleFrom(foregroundColor: Colors.purple[700]),
                                    child: const Text("Excluir"),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const CircleAvatar(backgroundColor: Colors.red,child: Icon(Icons.delete, color: Colors.white)),
                        ),
                      ],
                    ),
                  },
                ],
              ),
            ], 
          );
        }
      ),
    );
  }

  Widget containershowModalBottomSheet(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      padding: EdgeInsets.all(25.0),
      height: 150,
      child: Column(
        children: [
          Row(children: [Text("Foto do perfil", style: TextStyle(fontSize: 18, color: Colors.white))]),
          SizedBox(height: 24.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () async{
                  await _controller.captureImageCamera(context);
                  Navigator.pop(context);
                },
                child: Column(
                  children: [
                    Icon(Icons.camera_alt, color: Colors.white),
                    SizedBox(height: 8.0),
                    Text("Camera", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              InkWell(
                onTap: () async{
                  await _controller.takeImageGallery(context);
                },
                child: Column(
                  children: [
                    Icon(Icons.photo, color: Colors.white),
                    SizedBox(height: 8.0),
                    Text("Galeria", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              if(widget.contact.profileUrl ==  null && _controller.photoProfile == null) ...{
                InkWell(
                  child: Column(
                    children: [
                      Icon(Icons.delete, color: Colors.purple[400]),
                      SizedBox(height: 8.0),
                      Text("Excluir", style: TextStyle(color: Colors.purple[400])),
                    ],
                  ),
                ),
              } else ...{
                InkWell(
                  onTap:  () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Excluir esta foto?"),
                        content: const Text("Você tem certeza que deseja excluir esta foto?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(foregroundColor: Colors.purple[700]),
                            child: const Text("Cancelar"),
                          ),
                          TextButton(
                            onPressed: ()  {
                              _controller.removeImage(widget.contact);
                              _controller.removedImage = true;
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(foregroundColor: Colors.purple[700]),
                            child: const Text("Excluir"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Icon(Icons.delete, color: Colors.white),
                      SizedBox(height: 8.0),
                      Text("Excluir", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              },
            ],
          ),
        ],
      ),
    );
  }
}