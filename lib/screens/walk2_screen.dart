import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as lc;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:walk_with_dog/constants/constants.dart';

class Walk2Screen extends StatefulWidget {
  const Walk2Screen({Key? key}) : super(key: key);

  @override
  _Walk2ScreenState createState() => _Walk2ScreenState();
}

class _Walk2ScreenState extends State<Walk2Screen>
    with AutomaticKeepAliveClientMixin {
  /// 산책 시간 관련
  IconData _icon = Icons.play_arrow;
  Color _color = Colors.blueAccent;
  Timer? _timer;
  bool _isPlaying = false;
  bool _isPausing = false;
  var _totalHours = 0; // TOTAL TIME HOURS
  var _totalMinutes = 0; // TOTAL TIME MINUTES
  var _totalSeconds = 0; // TOTAL TIME SECONDS
  String _status = '산책 시작';

  // 시작, 일시정지 버튼

  // Initial location of the Map view
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));

  // For controlling the view of the Map
  GoogleMapController? mapController;

  // For storing the current position
  late Position _currentPosition;
  String _currentAddress = '';

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();

  String _startAddress = '';
  String _destinationAddress = '';
  String? _placeDistance;

  Set<Marker> markers = {};

  late PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  double totalDistance = 0.0;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  lc.Location location = lc.Location();
  StreamSubscription? _locationSubscription;
  bool? _serviceEnabled;
  lc.PermissionStatus? _permissionGranted;
  lc.LocationData? _oldLocationData;
  lc.LocationData? _newLocationData;

  // 시작, 일시정지 버튼
  void _click() {
    _isPlaying = !_isPlaying;
    if (_isPlaying) {
      _icon = Icons.pause;
      _color = Colors.grey;
      _status = '일시 중지';
      _start();
    } else {
      _icon = Icons.play_arrow;
      _color = Colors.blueAccent;
      _status = '산책 시작';
      _pause();
      _isPausing = true;
    }
  }

  _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 1000),
            (timer) {
          setState(() {
            _isPlaying = true;

            /// total time
            _totalSeconds++;
            if (_totalSeconds == 60) {
              _totalSeconds = 0;
              _totalMinutes++;
            }
            if (_totalMinutes == 60) {
              _totalMinutes = 0;
              _totalHours++;
            }
          });
        });
  }

  // 타이머 중지(취소)
  void _pause() {
    _timer?.cancel();
  }

  // 초기화
  void _reset() {
    /// 재생 중 RESET하는 경우
    if (_isPlaying) {
      _pause();
    }
    setState(() {
      _isPlaying = false;
      _isPausing = false;
      _timer?.cancel();

      _totalMinutes = 0;
      _totalSeconds = 0;
      _totalHours = 0;
    });
  }

  // Method for calculating the distance between two places
  Future<bool> _calculateDistance(
      lc.LocationData start, lc.LocationData destination) async {
    try {
      // Retrieving placemarks from addresses
      List<Location> startPlacemark = await locationFromAddress(_startAddress);
      List<Location> destinationPlacemark =
          await locationFromAddress(_destinationAddress);

      // Use the retrieved coordinates of the current position,
      // instead of the address if the start position is user's
      // current position, as it results in better accuracy.
      // double startLatitude = _startAddress == _currentAddress
      //     ? _currentPosition.latitude
      //     : startPlacemark[0].latitude;
      //
      // double startLongitude = _startAddress == _currentAddress
      //     ? _currentPosition.longitude
      //     : startPlacemark[0].longitude;
      double startLatitude = start.latitude!;
      double startLongitude = start.longitude!;

      double destinationLatitude = destination.latitude!;
      double destinationLongitude = destination.longitude!;
      // double destinationLatitude = destinationPlacemark[0].latitude;
      // double destinationLongitude = destinationPlacemark[0].longitude;

      String startCoordinatesString = '($startLatitude, $startLongitude)';
      String destinationCoordinatesString =
          '($destinationLatitude, $destinationLongitude)';

      // Start Location Marker
      Marker startMarker = Marker(
        markerId: MarkerId(startCoordinatesString),
        position: LatLng(startLatitude, startLongitude),
        infoWindow: InfoWindow(
          title: 'Start $startCoordinatesString',
          snippet: _startAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Destination Location Marker
      Marker destinationMarker = Marker(
        markerId: MarkerId(destinationCoordinatesString),
        position: LatLng(destinationLatitude, destinationLongitude),
        infoWindow: InfoWindow(
          title: 'Destination $destinationCoordinatesString',
          snippet: _destinationAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Adding the markers to the list
      markers.add(startMarker);
      markers.add(destinationMarker);

      print(
        'START COORDINATES: ($startLatitude, $startLongitude)',
      );
      print(
        'DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
      );

      // Calculating to check that the position relative
      // to the frame, and pan & zoom the camera accordingly.
      double miny = (startLatitude <= destinationLatitude)
          ? startLatitude
          : destinationLatitude;
      double minx = (startLongitude <= destinationLongitude)
          ? startLongitude
          : destinationLongitude;
      double maxy = (startLatitude <= destinationLatitude)
          ? destinationLatitude
          : startLatitude;
      double maxx = (startLongitude <= destinationLongitude)
          ? destinationLongitude
          : startLongitude;

      double southWestLatitude = miny;
      double southWestLongitude = minx;

      double northEastLatitude = maxy;
      double northEastLongitude = maxx;

      // Accommodate the two locations within the
      // camera view of the map
      mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: LatLng(northEastLatitude, northEastLongitude),
            southwest: LatLng(southWestLatitude, southWestLongitude),
          ),
          100.0,
        ),
      );

      await _createPolylines(startLatitude, startLongitude, destinationLatitude,
          destinationLongitude);

      // Calculating the total distance by adding the distance
      // between small segments
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }

      setState(() {
        _placeDistance = totalDistance.toStringAsFixed(2);
        print('DISTANCE: $_placeDistance km');
      });

      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = math.cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * math.asin(math.sqrt(a));
  }

  // Create the polylines for showing the route between two places
  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      myGoogleApiKey, // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    PolylineId id = const PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription!.cancel();
    }
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    location.getLocation().then((location) {
      _newLocationData = location;
      _oldLocationData = location;
      print('_newLocationData.lng : ${_newLocationData!.longitude}');
      print('_newLocationData.lat : ${_newLocationData!.latitude}');
    });

    /// 내 현재 위치 가져오기
    _getCurrentLocation();
  }

  permissionCheck() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == lc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != lc.PermissionStatus.granted) {
        return;
      }
    }

    _locationSubscription =
        location.onLocationChanged.listen((lc.LocationData currentLocation) {
      totalDistance += (measureExact(
          _oldLocationData!.latitude, _oldLocationData!.longitude));
      // Use current location
      setState(() {
        _oldLocationData = _newLocationData;
        _newLocationData = currentLocation;
        _calculateDistance(_newLocationData!, _oldLocationData!);
        print('_oldLocationData.lng : ${_oldLocationData!.longitude}');
        print('_oldLocationData.lat : ${_oldLocationData!.latitude}');
        print('_newLocationData.lng : ${_newLocationData!.longitude}');
        print('_newLocationData.lat : ${_newLocationData!.latitude}');
      });
    });
  }

  measureExact(lat, lng) {
    // generally used geo measurement function
    var R = 6378.137; // Radius of earth in KM
    var dLat =
        lat * math.pi / 180 - _newLocationData!.latitude! * math.pi / 180;
    var dLon =
        lng * math.pi / 180 - _newLocationData!.longitude! * math.pi / 180;
    var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_newLocationData!.latitude! * math.pi / 180) *
            math.cos(lat * math.pi / 180) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    var d = R * c;
    return d; //.toStringAsFixed(2); // meters
  }

  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.width;
    return SizedBox(
      height: height,
      width: width,
      child: Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: [
            Stack(
              children: <Widget>[
                // Map View
                SizedBox(
                  height: Get.height * 0.55,
                  width: Get.width,
                  child: GoogleMap(
                    markers: Set<Marker>.from(markers),
                    initialCameraPosition: _initialLocation,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    mapType: MapType.normal,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: true,
                    polylines: Set<Polyline>.of(polylines.values),
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                  ),
                ),
                // Show zoom buttons
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ClipOval(
                          child: Material(
                            color: Colors.grey.shade400, // button color
                            child: InkWell(
                              splashColor: Colors.grey, // inkwell color
                              child: const SizedBox(
                                width: 50,
                                height: 50,
                                child: Icon(Icons.add),
                              ),
                              onTap: () {
                                mapController!.animateCamera(
                                  CameraUpdate.zoomIn(),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ClipOval(
                          child: Material(
                            color: Colors.grey.shade400, // button color
                            child: InkWell(
                              splashColor: Colors.grey, // inkwell color
                              child: const SizedBox(
                                width: 50,
                                height: 50,
                                child: Icon(Icons.remove),
                              ),
                              onTap: () {
                                mapController!.animateCamera(
                                  CameraUpdate.zoomOut(),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
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
                              _totalHours > 0
                                  ? Text(
                                      '$_totalHours:',
                                      style: TextStyle(
                                        fontSize: Get.width * 0.1,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : const SizedBox(),
                              Text(
                                _totalMinutes < 10
                                    ? '0$_totalMinutes'
                                    : '$_totalMinutes',
                                style: TextStyle(
                                  fontSize: Get.width * 0.1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _totalSeconds < 10
                                    ? ':0$_totalSeconds'
                                    : ':$_totalSeconds',
                                style: TextStyle(
                                  fontSize: Get.width * 0.1,
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
                            '${totalDistance}km',
                            style: TextStyle(
                              fontSize: Get.width * 0.1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _isPausing ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                      child: Material(
                        child: InkWell(
                          splashColor: Colors.grey, // inkwell color
                          child: Container(
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.blueAccent, width: 2),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            height: 100,
                            width: 100,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: Icon(
                                    _icon,
                                    size: 50,
                                    color: _color,
                                  ),
                                ),
                                Text(
                                  _status,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Get.width * 0.045,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            ///
                            _click();

                            /// 산책 기록 시작
                            permissionCheck();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                      child: Material(
                        child: InkWell(
                          splashColor: Colors.grey, // inkwell color
                          child: Container(
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.blueAccent, width: 2),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            height: 100,
                            width: 100,
                            child: Column(
                              children: [
                                const SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: Icon(
                                    Icons.stop,
                                    size: 50,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                Text(
                                  '산책 종료',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Get.width * 0.045,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            ///
                            _reset();
                          },
                        ),
                      ),
                    )
                  ],
                ) : Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                  child: Material(
                    child: InkWell(
                      splashColor: Colors.grey, // inkwell color
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                          Border.all(color: Colors.blueAccent, width: 2),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        height: 100,
                        width: 100,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: Icon(
                                _icon,
                                size: 50,
                                color: _color,
                              ),
                            ),
                            Text(
                              _status,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Get.width * 0.045,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        ///
                        _click();

                        /// 산책 기록 시작
                        permissionCheck();
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  // Method for retrieving the address

  _getAddress() async {
    try {
      // Places are retrieved using the coordinates
      List<Placemark> p = await GeocodingPlatform.instance
          .placemarkFromCoordinates(
              _currentPosition.latitude, _currentPosition.longitude);

      // Taking the most probable result
      Placemark place = p[0];

      setState(() {
        // Structuring the address
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";

        // Update the text of the TextField
        startAddressController.text = _currentAddress;

        // Setting the user's present location as the starting address
        _startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
