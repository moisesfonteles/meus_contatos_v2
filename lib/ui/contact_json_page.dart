import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:meus_contatos/controller/contact_json_controller.dart';
import 'package:meus_contatos/model/other_contacts_model.dart';
import 'package:meus_contatos/ui/map_json_page.dart';

class ContactJsonPage extends StatefulWidget {
  final List<OtherContact> otherContacts;
  final OtherContact otherContact;
  final int index;

  const ContactJsonPage({super.key, required this.otherContacts, required this.otherContact, required this.index});

  @override
  State<ContactJsonPage> createState() => _ContactJsonPageState();
}

class _ContactJsonPageState extends State<ContactJsonPage> {
  final ContactJsonController _controller = ContactJsonController();

  @override
  void initState() {
    _controller.nameController.text = widget.otherContact.name!;
    _controller.phoneController.text = widget.otherContact.phone!;
    _controller.emailController.text = widget.otherContact.email!;
    widget.otherContact.address!.street == "" && widget.otherContact.address!.city == "" ?
    _controller.addressController.text = "${widget.otherContact.address!.suite}" :
    _controller.addressController.text = "${widget.otherContact.address!.suite}, ${widget.otherContact.address!.street}, ${widget.otherContact.address!.city}";
    super.initState();
  }

  @override
  void dispose() {
    _controller.disposeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: StreamBuilder<bool>(
          stream: _controller.streamEditingContact.stream,
          initialData: false,
          builder: (context, snapshot) {
            return Text(widget.otherContact.name!);
          }
        ),
      ),
      body: Center(
        child: profileContactJson(),
      ),
    );
  }

  Widget profileContactJson() {
    return Form(
      key: _controller.formKey,
      child: StreamBuilder<bool>(
        initialData: false,
        stream: _controller.streamEditingContact.stream,
        builder: (context, snapshot) {
          return ListView(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    if(snapshot.data!) ...{
                      Center(
                        child: CircleAvatar(
                          maxRadius: 55,
                          backgroundColor: Colors.grey[100],
                          child: const CircleAvatar(backgroundColor: Colors.purple, maxRadius: 50, child: Icon(Icons.person, size: 70))
                        ),
                      ),
                      const SizedBox(width: 8, height: 16),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _controller.nameController,
                        decoration: const InputDecoration(border: OutlineInputBorder(),labelText: "Nome"),
                        validator: (String? value) => _controller.validatorName(value),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _controller.phoneController,
                        decoration: const InputDecoration(border: OutlineInputBorder(),labelText: "Telefone", hintText: "+99 (99) 9 9999-9999"),
                        validator: (String? value) => _controller.validatorPhone(value),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: TextFormField(
                          controller: _controller.emailController,
                          decoration: const InputDecoration(border: OutlineInputBorder(),labelText: "E-mail",hintText: "nome@email.com"),
                          textInputAction: TextInputAction.next,
                          validator: (String? value) => _controller.validatorEmail(value),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: TextFormField(
                          controller: _controller.addressController,
                          decoration: const InputDecoration(border: OutlineInputBorder(),labelText: "Endereço"),
                          textInputAction: TextInputAction.next,
                          // validator: ,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(fixedSize:  const Size(double.maxFinite, 60)),
                                onPressed: () => _controller.clickEditContact(), 
                                child: const Text("Cancelar", style: TextStyle(fontSize: 16)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(fixedSize:  const Size(double.maxFinite, 60)),
                                  onPressed: () => _controller.clickSaveContact(widget.otherContact),
                                  child: const Text("Salvar", style: TextStyle(fontSize: 16)),
                                ),
                              ),
                          ],
                        ),
                      ),
                    } else ...{
                      Center(
                        child: CircleAvatar(
                          maxRadius: 55,
                          backgroundColor: Colors.grey[100],
                          child: const CircleAvatar(backgroundColor: Colors.purple, maxRadius: 50, child: Icon(Icons.person, size: 70))
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text("${widget.otherContact.name}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 25)),
                      const SizedBox(height: 12),
                      Text("${widget.otherContact.phone}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 19)),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text("${widget.otherContact.email}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 19)),
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        height: 2,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        color: Colors.grey.shade200,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => _controller.callPhone("${widget.otherContact.phone}"),
                              child: const CircleAvatar(backgroundColor: Colors.green,child: Icon(Icons.phone, color: Colors.white)),
                            ),
                            const SizedBox(width: 16.0),
                            InkWell(
                              onTap:() => _controller.sendSms("${widget.otherContact.phone}"),
                              child: const CircleAvatar(backgroundColor: Colors.blue,child: Icon(Icons.message, color: Colors.white)),
                            ),
                            const SizedBox(width: 16.0),
                            InkWell(
                              onTap: () => _controller.sendEmail("${widget.otherContact.email}"),
                              child: CircleAvatar(backgroundColor: Colors.pink[300],child: const Icon(Icons.email, color: Colors.white)),
                            ),
                            const SizedBox(width: 16.0),
                            InkWell(
                              onTap: () => _controller.clickEditContact(),
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
                                        // onPressed: () => _controller.deleteContact(_controller.index, context, widget.contact),
                                        onPressed: () => _controller.deleteContact(widget.index, context, widget.otherContact),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              mapAddressContact(),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => MapContactJson(otherContact: widget.otherContact, index: widget.index,)));
                                  },
                                  child: const Icon(Icons.fullscreen, color: Colors.black87, size: 34),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: widget.otherContact.address!.street == "" && widget.otherContact.address!.city == "" ?
                        Text("${widget.otherContact.address!.suite}", style: const TextStyle(fontSize: 19), textAlign: TextAlign.center) :
                        Text("${widget.otherContact.address?.suite}, ${widget.otherContact.address?.street}, ${widget.otherContact.address?.city}" , style: const TextStyle(fontSize: 19), textAlign: TextAlign.center),
                      ),
                    },
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget mapAddressContact() {
    return FlutterMap(
      options: MapOptions(
        zoom: 16,
        center: LatLng(double.parse("${widget.otherContact.address?.geo?.lat}"), double.parse("${widget.otherContact.address?.geo?.lng}")),
        minZoom: 10.0,
        maxZoom: 18
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(double.parse("${widget.otherContact.address?.geo?.lat}"), double.parse("${widget.otherContact.address?.geo?.lng}")),
              width: 40,
              height: 40,
              builder: (context) => Image.asset("assets/pin.png"),
            ),
          ],
        ),
      ],
    );
  }
}