import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mn_641463036/mainmenu.dart';

class GPSTracking extends StatefulWidget {
  @override
  _GPSTrackingState createState() => _GPSTrackingState();
}

class _GPSTrackingState extends State<GPSTracking> {
  GoogleMapController? mapController;

  List<Marker> markers = [];
  @override
  void initState() {
    super.initState();
    fetchLocations();
  }

  Future<void> fetchLocations() async {
    final response = await http.get(Uri.parse(
        'http://localhost:88/apiflutter_MiniProject/tourAt/show_tour.php'));
    if (response.statusCode == 200) {
      List<dynamic> locations = json.decode(response.body);
      setState(() {
        markers = locations.map((location) {
          return Marker(
            markerId: MarkerId(location['tourCode']
                .toString()), // ตอ้ งใชข้ อ้มลู ทเี่ ป็น unique เชน่ ID
            position: LatLng(double.parse(location['latitude']),
                double.parse(location['longtitude'])),
            infoWindow: InfoWindow(
                title: location['tourName'] +
                    " "), // ปรับตามชอื่ ทตี่ อ้ งการแสดงใน InfoWindow
          );
        }).toList();
      });
    } else {
      throw Exception('การโหลดตำแหน่งผิดพลาด');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors
            .lightGreen.shade400, // ก าหนดสพี นื้ หลังของ AppBar เป็นสนี ้าเงนิ
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
// เพมิ่ โคด้ ส าหรับการกลับไดท้ นี่ ี่
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => mainMenu(),
            ));
          },
        ),
        title: Text('Smart Tracker'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
              19.7313168, 99.2586095), // ต าแหน่งเริ่มต ้นของแผนที่ (Bangkok)
          zoom: 10,
        ),
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            mapController = controller;
          });
        },
        markers: Set<Marker>.of(markers),
      ),
    );
  }
}
