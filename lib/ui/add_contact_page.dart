
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meus_contatos/controller/add_contact_controller.dart';


class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final AddContactController _controller = AddContactController();

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
        appBar: AppBar(title: const Text("Adicionar Contato")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: profileContacts(),
          ),
        ),
      ),
    );
  }
  
  Widget profileContacts(){
    return Form(
      key: _controller.formKey,
      child: ListView(
        children: [
          Center(
            child: StreamBuilder(
              stream: _controller.streamPhoto.stream,
              builder: (context, snapshot) {
                return Stack(
                  children: [
                    if(_controller.photoProfile == null) ...{
                      CircleAvatar(
                        backgroundColor: Colors.grey[100],
                        maxRadius: 55,
                        child: const CircleAvatar(backgroundColor: Colors.purple, maxRadius: 50, child: Icon(Icons.person, size: 70))
                      ),
                    } else ...{
                      CircleAvatar(
                        foregroundImage: FileImage(_controller.photoProfile!),
                        backgroundColor: Colors.purple,
                        maxRadius: 55,
                        child: const Icon(Icons.person, size: 70),
                      ),
                    },
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
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
          const SizedBox(width: 8, height: 20),
          TextFormField(
            textInputAction: TextInputAction.next,
            controller: _controller.nameController,
            decoration: const InputDecoration(border: OutlineInputBorder(),labelText: "Nome"),
            validator:(String? value) => _controller.validatorName(value),
          ),
          const SizedBox(width: 8, height: 20),
          TextFormField(
            textInputAction: TextInputAction.next,
            controller: _controller.phoneController,
            decoration: const InputDecoration(border: OutlineInputBorder(),labelText: "Telefone", hintText: "+99 (99) 9 9999-9999"),
            validator:(String? value) => _controller.validatorPhone(value),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, _controller.maskFormatter],
          ),
          const SizedBox(width: 8, height: 20),
          TextFormField(
            controller: _controller.emailController,
            decoration: const InputDecoration(border: OutlineInputBorder(),labelText: "E-mail (Opcional)",hintText: "nome@email.com"),
            validator: (String? value) => _controller.validatorEmail(value),
            onEditingComplete: _controller.uploadPhotoLoading ? () {} : () => _controller.clickAddContact(context),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 20),
          Center(
            child: StreamBuilder(
              stream: _controller.streamButtonAdd.stream,
              builder: (context, snapshot) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(fixedSize:  const Size(double.maxFinite, 62)),
                  onPressed: _controller.uploadPhotoLoading ? () {} : () => _controller.clickAddContact(context),
                  child: _controller.uploadPhotoLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Adicionar", style: TextStyle(fontSize: 16)),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget containershowModalBottomSheet(){
    return Container(
      decoration: const BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(25.0),
      height: 150,
      child: Column(
        children: [
          Row(  children: const [Text("Foto do perfil", style: TextStyle(fontSize: 18, color: Colors.white))]),
          const SizedBox(height: 24.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap:() async => await _controller.captureImageCamera(context),
                child: Column(
                  children: const [
                    Icon(Icons.camera_alt, color: Colors.white),
                    SizedBox(height: 8.0),
                    Text("Câmera", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              InkWell(
                onTap:() async => await _controller.takeImageGallery(context),
                child: Column(
                  children: const [
                    Icon(Icons.photo, color: Colors.white),
                    SizedBox(height: 8.0),
                    Text("Galeria", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              if(_controller.photoProfile == null) ...{
                InkWell(
                  child: Column(
                    children: [
                      Icon(Icons.delete, color: Colors.purple[400]),
                      const SizedBox(height: 8.0),
                      Text("Excluir", style: TextStyle(color: Colors.purple[400])),
                    ],
                  ),
                ),
              } else ...{
                InkWell(
                  onTap: () {
                    showDialog(context: context,
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
                            onPressed: () async => await _controller.removeImage(context),
                            style: TextButton.styleFrom(foregroundColor: Colors.purple[700]),
                            child: const Text("Excluir"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Column(
                    children: const [
                      Icon(Icons.delete, color: Colors.white),
                      SizedBox(height: 8.0),
                      Text("Excluir", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              }
            ],
          ),
        ],
      ),
    );
  }
}