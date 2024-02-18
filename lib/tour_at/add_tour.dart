import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463036/tour_at/list_tour.dart';

class addTour extends StatefulWidget {
  @override
  _addTourState createState() => _addTourState();
}

class _addTourState extends State<addTour> {
  TextEditingController tourCodeController = TextEditingController();
  TextEditingController tourNameController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longtitudeController = TextEditingController();

  void addTour() async {
    String tourCode = tourCodeController.text;
    String tourName = tourNameController.text;
    String latitude = latitudeController.text;
    String longtitude = longtitudeController.text;

    // Replace the URL with the API endpoint for inserting into tourist_attraction
    String apiUrl =
        'http://localhost:88/apiflutter_MiniProject/tourAt/add_tour.php';

    Map<String, dynamic> requestBody = {
      'tourCode': tourCode,
      'tourName': tourName,
      'latitude': latitude,
      'longtitude': longtitude
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        showSuccessDialog(context);
      } else {
        print('ลงทะเบียนไม่สำเร็จ');
      }
    } catch (error) {
      print('เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => showTour(),
            ));
          },
        ),
        centerTitle: true,
        title: Text('เพิ่มสถานที่ท่องเที่ยว'),
        titleTextStyle: TextStyle(
          fontSize: 30,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: tourNameController,
              decoration: InputDecoration(labelText: 'ชื่อสถานที่ท่องเที่ยว'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: latitudeController,
              decoration: InputDecoration(labelText: 'ละติจูด'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: longtitudeController,
              decoration: InputDecoration(labelText: 'ลองติจูด'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: addTour,
              child: Text('เพิ่มสถานที่ท่องเที่ยว'),
              style: OutlinedButton.styleFrom(
                fixedSize: Size(300, 50),
                side: BorderSide(
                  color: Color.fromARGB(255, 0, 255, 0),
                  width: 2.0,
                ),
                backgroundColor: Color.fromARGB(255, 0, 255, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('สำเร็จแล้ว'),
        content: Text('ข้อมูลพืช บันทึกเรียบร้อยแล้ว..'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => showTour(),
              ));
            },
            child: Text('ไปที่เมนูหลัก'),
          ),
        ],
      );
    },
  );
}
