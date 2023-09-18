
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:meus_contatos/controller/contact_json_controller.dart';
import 'package:meus_contatos/model/other_contacts_model.dart';

class ContactJsonPage extends StatefulWidget {
  List<OtherContact> otherContacts;
  OtherContact otherContact;
  int index;

  ContactJsonPage({super.key, required this.otherContacts, required this.otherContact, required this.index});

  @override
  State<ContactJsonPage> createState() => _ContactJsonPageState();
}

class _ContactJsonPageState extends State<ContactJsonPage> {
  final ContactJsonController _controller = ContactJsonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.otherContact.name!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: profileContactJson(),
        ),
      ),
    );
  }

  Widget profileContactJson() {
    return ListView(
      children: [
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
        const SizedBox(height: 12),
        Text("${widget.otherContact.email}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 19)),
        const SizedBox(height: 20.0),
        Container(
          height: 2,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          color: Colors.grey.shade200,
        ),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => _controller.callPhone(widget.otherContact.phone as String),
              child: const CircleAvatar(backgroundColor: Colors.green,child: Icon(Icons.phone, color: Colors.white)),
            ),
            const SizedBox(width: 16.0),
            InkWell(
              onTap:() => _controller.sendSms(widget.otherContact.phone as String),
              child: const CircleAvatar(backgroundColor: Colors.blue,child: Icon(Icons.message, color: Colors.white)),
            ),
            const SizedBox(width: 16.0),
            InkWell(
              onTap: () => _controller.sendEmail(widget.otherContact.email as String),
              child: CircleAvatar(backgroundColor: Colors.pink[300],child: const Icon(Icons.email, color: Colors.white)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: mapAddressContact(),
        ),
        const SizedBox(height: 20),
        Text("${widget.otherContact.address?.suite}, ${widget.otherContact.address?.street}, ${widget.otherContact.address?.city}" , style: const TextStyle(fontSize: 19), textAlign: TextAlign.center), 
      ],
    );
  }

  Widget mapAddressContact() {
    return FlutterMap(
      options: MapOptions(
        zoom: 16,
        center: LatLng(51.509364, -0.128928),
        minZoom: 10.0,
        maxZoom: 18
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
        ),
      ],
    );
  }
}