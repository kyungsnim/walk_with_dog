import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_elevation/map_elevation.dart';
import 'package:walk_with_dog/constants/data.dart';
import 'package:walk_with_dog/constants/data4.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ElevationPoint? hoverPoint;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('fssdffsd'),
      ),
      body: Stack(children: [
        FlutterMap(
          options: MapOptions(
            center: LatLng(startLatPoint, startLngPoint),
            // center: LatLng(37.418876, 127.135583),
          // center: LatLng(37.612258493473085, 127.00814595321324),
            // center: LatLng(45.10, 5.48),\\

            zoom: 16.0,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
            PolylineLayerOptions(
              // Will only render visible polylines, increasing performance
              polylines: [
                Polyline(
                  // An optional tag to distinguish polylines in callback
                  points: getPoints(),
                  color: Colors.blueAccent,
                  strokeWidth: 4.0,
                ),
              ],
            ),
            MarkerLayerOptions(markers: [
              if (hoverPoint is LatLng)
                Marker(
                    point: hoverPoint!,
                    width: 8,
                    height: 8,
                    builder: (BuildContext context) => Container(
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(8)),
                    ))
            ]),
          ],
        ),
        // Positioned(
        //   bottom: 0,
        //   left: 0,
        //   right: 0,
        //   height: 120,
        //   child: Container(
        //     color: Colors.white.withOpacity(0.6),
        //     child: NotificationListener<ElevationHoverNotification>(
        //         onNotification: (ElevationHoverNotification notification) {
        //           setState(() {
        //             hoverPoint = notification.position;
        //           });
        //
        //           return true;
        //         },
        //         child: Elevation(
        //           getPoints(),
        //           color: Colors.grey,
        //           elevationGradientColors: ElevationGradientColors(
        //               gt10: Colors.green,
        //               gt20: Colors.orangeAccent,
        //               gt30: Colors.redAccent),
        //         )),
        //   ),
        // )
      ]),
    );
  }
}
