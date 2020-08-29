import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:test_app/models/User.dart';

class DetailUser extends StatefulWidget {
  final UserModel user ;
  const DetailUser({Key key, this.user}) : super(key: key);
  @override
  _DetailUserState createState() => _DetailUserState();
}

class _DetailUserState extends State<DetailUser> {

  MapboxMapController mapController;
  final LatLng location = LatLng(20.6596988, -103.3496092);
  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _onStyleLoaded();
    mapController.addSymbol(SymbolOptions(
        geometry: location,
        iconImage: "assetImage",
        textColor: "#3D5AFE",
    ));
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/custom-icon.png");
    addImageFromUrl("networkImage", "https://via.placeholder.com/50");
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  /// Adds a network image to the currently displayed style
  Future<void> addImageFromUrl(String name, String url) async {
    var response = await get(url);
    return mapController.addImage(name, response.bodyBytes);
  }

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle del contacto"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          ListTile(
              title: Text(widget.user.fullname),
              subtitle: Column(
                children: [
                  Container(
                      alignment: Alignment.topLeft,
                      child: Text( widget.user.email,)),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 24.0),
                      Text(widget.user.raiting)
                    ],
                  ),
                ],
              ),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.user.picture),
              )),
          Divider(),
          Container(
              padding: EdgeInsets.all(12.0),
              alignment: Alignment.topLeft,
              child: Text("Dirección", style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)),
          ListTile(
            subtitle: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(4.0),
                    alignment: Alignment.topLeft,
                    child: Text("Calle: "+ widget.user.street)),
                Container(
                    padding: EdgeInsets.all(4.0),
                    alignment: Alignment.topLeft,
                    child: Text("Ciudad: "+ widget.user.city)),
                Container(
                    padding: EdgeInsets.all(4.0),
                    alignment: Alignment.topLeft,
                    child: Text("Estado:  "+widget.user.state)),
                Container(
                    padding: EdgeInsets.all(4.0),
                    alignment: Alignment.topLeft,
                    child: Text("Código Postal: "+ widget.user.postal_code)),
                Container(
                    padding: EdgeInsets.all(4.0),
                    alignment: Alignment.topLeft,
                    child: Text("Télefono: "+ widget.user.phone_number))
              ],
            ),
          ),

          //Here going map :::::::::::::::::::::::

          Container(
              padding: EdgeInsets.all(12.0),
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.grey, size: 24.0),
                  Text("Ubicación", style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                ],
              )),

          Container(
              padding: EdgeInsets.all(12.0),
              alignment: Alignment.topLeft,
              height: 250,
              width: 500,
              child: MapboxMap(
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                initialCameraPosition: const CameraPosition(
                    target: LatLng(20.6596988, -103.3496092),
                    zoom: 14.0,
                ),
              )
          ),
          Container(
              padding: EdgeInsets.all(14.0),
              width: double.infinity,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.green)),
                onPressed: () {},
                color: Colors.green,
                textColor: Colors.white,
                child: Text("Contactar".toUpperCase(),
                    style: TextStyle(fontSize: 14)),
              )
          ),



        ],
      ),
    );
  }
}
