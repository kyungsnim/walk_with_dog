import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_elevation/map_elevation.dart';
import 'package:walk_with_dog/constants/data.dart';
import 'package:walk_with_dog/constants/data4.dart';

class MyHomePage extends StatefulWidget {
  int? totalHours;
  int? totalMinutes;
  int? totalSeconds;
  double? totalDistance;

  MyHomePage(this.totalHours, this.totalMinutes, this.totalSeconds,
      this.totalDistance);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ElevationPoint? hoverPoint;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 300), () {
      checkMapSize(context);
    });
    return Scaffold(
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
              retinaMode: true,
            ),
            PolylineLayerOptions(
              // Will only render visible polylines, increasing performance
              polylines: [
                Polyline(
                  // An optional tag to distinguish polylines in callback
                  points: getPoints(),
                  color: Colors.blueAccent,
                  strokeWidth: 10.0,
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
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Container(
              alignment: Alignment.center,
              width: Get.width * 0.95,
              height: Get.height * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white70,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '산책시간',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: Get.width * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                widget.totalHours! > 0
                                    ? Text(
                                        '${widget.totalHours}:',
                                        style: TextStyle(
                                          fontSize: Get.width * 0.08,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : const SizedBox(),
                                Text(
                                  widget.totalMinutes! < 10
                                      ? '0${widget.totalMinutes}'
                                      : '${widget.totalMinutes}',
                                  style: TextStyle(
                                    fontSize: Get.width * 0.08,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.totalSeconds! < 10
                                      ? ':0${widget.totalSeconds}'
                                      : ':${widget.totalSeconds}',
                                  style: TextStyle(
                                    fontSize: Get.width * 0.08,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('산책거리',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: Get.width * 0.05,
                                  fontWeight: FontWeight.bold,
                                )),
                            const SizedBox(height: 10),
                            Text(
                              '${widget.totalDistance!.toStringAsFixed(2)}km',
                              style: TextStyle(
                                fontSize: Get.width * 0.08,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.blueAccent,
                            ),
                            color: Colors.blueAccent.shade700,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.play_arrow,
                                  size: Get.width * 0.08,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '산책기록 남기기',
                                  style: TextStyle(
                                    fontSize: Get.width * 0.05,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),

        /// 뒤로가기
        // Positioned(
        //   top: Get.height * 0.1,
        //   left: Get.width * 0.08,
        //   child: InkWell(
        //     onTap: () => Get.back(),
        //     child: Container(
        //       width: Get.width * 0.2,
        //       height: Get.width * 0.2,
        //       alignment: Alignment.center,
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(50),
        //         color: Colors.grey,
        //       ),
        //       child: const Padding(
        //         padding: EdgeInsets.all(8.0),
        //         child: Icon(
        //           Icons.arrow_back_ios,
        //           color: Colors.white,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ]),
    );
  }

  checkMapSize(context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('산책경로 확인'),
            content: const Text('산책경로가 지도에 담기도록 사이즈를 조절하신 후 산책기록을 저장하세요.'),
            actions: [
              TextButton(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text('확인',
                      style: TextStyle(color: Colors.grey, fontSize: 20)),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }
}
