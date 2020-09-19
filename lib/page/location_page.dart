import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPage extends StatefulWidget {
   @override
   _LocationPageState createState() => _LocationPageState();
}
class _LocationPageState extends State<LocationPage> {

  final Set<Marker> _markers = {};
  LatLng _currentPosition = LatLng(-6.7693522, 110.8720895);

  @override
  void initState() {
    _markers.add(
      Marker(
        markerId: MarkerId("-6.7693522, 110.8720895"),
        position: _currentPosition,
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alamat Toko'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 16.0,
        ),
        markers: _markers,
      ),
    );
  }
}