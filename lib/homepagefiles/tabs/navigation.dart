import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
 
 
class Navigation extends StatefulWidget {
  @override
  NavigationState createState() =>  NavigationState();
}
 
class NavigationState extends State<Navigation> {
  MapController _mapCtl = MapController();

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  double lat = 0.0;
  double long = 0.0;

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Stack(children: <Widget>[
           FlutterMap(
             mapController: _mapCtl,
            options:  MapOptions(
                center:  LatLng(8.378,124.634
), minZoom: 10.0),
            layers: [
               TileLayerOptions(
                  urlTemplate:
                      "https://api.mapbox.com/styles/v1/clapton23/ck4zwknzv1agc1cmdotu1ld30/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiY2xhcHRvbjIzIiwiYSI6ImNqdmJ0YTRkdjFyMTc0M3FwcXFwZzN1a2gifQ.SDVzcxmoQHzlRmaDzToO6g",
                  additionalOptions: {
                    'accessToken':
                        'pk.eyJ1IjoiY2xhcHRvbjIzIiwiYSI6ImNqdmJ0YTRkdjFyMTc0M3FwcXFwZzN1a2gifQ.SDVzcxmoQHzlRmaDzToO6g',
                    'id': 'mapbox.mapbox-streets-v7'
                  }),
               MarkerLayerOptions(markers: [
                 Marker(
                    width: 45.0,
                    height: 45.0,
                    point:  LatLng(lat ,long),
                    builder: (context) =>  Container(
                          child: IconButton(
                            icon: Icon(Icons.location_on),
                            color: Colors.blue,
                            iconSize: 45.0,
                            onPressed: () {
                              print('Marker tapped');
                            },
                          ),
                        ))
              ])
            ]),
            Padding(
      padding: const EdgeInsets.all(15.0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          onPressed: () {
             _getCurrentLocation() ;
          },
          materialTapTargetSize: MaterialTapTargetSize.padded,
          backgroundColor: Color(0xff086375),
          child: const Icon(Icons.location_searching, size: 36.0),
        ),
      ),
    ),
        ],));
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        lat = _currentPosition.latitude;
        long = _currentPosition.longitude;
      });

      _mapCtl.move(LatLng(lat,long),15.0);
    

      
    }).catchError((e) {
      print(e);
    });
  }

   
  
}