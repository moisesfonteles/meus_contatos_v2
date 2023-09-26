import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../model/other_contacts_model.dart';

class MapContactJson extends StatefulWidget {
  final OtherContact otherContact;
  final int index;

  const MapContactJson({super.key, required this.otherContact, required this.index});
  

  @override
  State<MapContactJson> createState() => _MapContactJsonState();
}

class _MapContactJsonState extends State<MapContactJson> {
  final mapController = MapController();

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.otherContact.address.target!.suite}, ${widget.otherContact.address.target!.suite}, ${widget.otherContact.address.target!.city}"),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          zoom: 16,
          center: LatLng(double.parse("${widget.otherContact.address.target!.geo.target!.lat}"), double.parse("${widget.otherContact.address.target!.geo.target!.lng}")),
          minZoom: 2,
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
                point: LatLng(double.parse("${widget.otherContact.address.target!.geo.target!.lat}"), double.parse("${widget.otherContact.address.target!.geo.target!.lng}")),
                width: 40,
                height: 40,
                builder: (context) => Image.asset("assets/pin.png"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}