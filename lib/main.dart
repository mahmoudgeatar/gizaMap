import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(29.9792, 31.1342);
  final Set<Marker> _markers = {};
  LatLng _lastMapPostion = _center;
  MapType _CurrentMapType = MapType.normal;
  static final CameraPosition _position = CameraPosition(
    bearing: 192.833,
    target: LatLng(29.9792, 31.1342),
    tilt: 59.440,
    zoom: 11.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Giza',
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              zoomControlsEnabled: true,
              mapType: _CurrentMapType,
              markers: _markers,
              onCameraMove: _oncameraMove,
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget>[
                    button(_onMapTypeButtonPressed, Icons.map),
                    SizedBox(
                      height: 16,
                    ),
                    button(_onAddMarkerButtonPressed, Icons.add_location),
                    SizedBox(
                      height: 16,
                    ),
                    button(_gotPostion1, Icons.location_searching),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _gotPostion1() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_position));
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _oncameraMove(CameraPosition position) {
    _lastMapPostion = position.target;
  }

  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      child: Icon(
        icon,
        size: 36,
      ),
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
    );
  }

  _onMapTypeButtonPressed() {
    setState(() {
      _CurrentMapType = _CurrentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(
            _lastMapPostion.toString(),
          ),
          position: _lastMapPostion,
          infoWindow: InfoWindow(
            title: 'This is a Title',
            snippet: 'This is a snippet',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }
}
