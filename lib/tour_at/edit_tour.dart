import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463036/tour_at/list_tour.dart';

class EditTourPage extends StatefulWidget {
  final Map<String, dynamic> data;

  EditTourPage({required this.data});

  @override
  _EditTourPageState createState() => _EditTourPageState();
}

class _EditTourPageState extends State<EditTourPage> {
  late TextEditingController tourCodeController;
  late TextEditingController tourNameController;
  late TextEditingController latitudeController;
  late TextEditingController longtitudeController;

  @override
  void initState() {
    super.initState();
    tourCodeController =
        TextEditingController(text: widget.data['tourCode'].toString());
    tourNameController =
        TextEditingController(text: widget.data['tourName'].toString());
    latitudeController =
        TextEditingController(text: widget.data['latitude'].toString());
    longtitudeController =
        TextEditingController(text: widget.data['longtitude'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขสถานที่ท่องเที่ยว'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5.0,
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Image.asset(
                      'images/tourAT.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  buildReadOnlyField('รหัส', tourCodeController),
                  TextFormField(
                    controller: tourNameController,
                    decoration: InputDecoration(
                      labelText: 'ชื่อสถานที่ท่องเที่ยว',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: latitudeController,
                    decoration: InputDecoration(
                      labelText: 'ละติจูด',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: longtitudeController,
                    decoration: InputDecoration(
                      labelText: 'ลองติจูด',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      String updatedtourCode = tourCodeController.text;
                      String updatedtourName = tourNameController.text;
                      String updatedlatitude = latitudeController.text;
                      String updatedlongtitude = longtitudeController.text;

                      String apiUrl =
                          'http://localhost:88/apiflutter_MiniProject/tourAt/crud_tour.php?case=PUT';

                      try {
                        var response = await http.put(
                          Uri.parse(apiUrl),
                          body: json.encode({
                            'tourCode': updatedtourCode,
                            'tourName': updatedtourName,
                            'latitude': updatedlatitude,
                            'longtitude': updatedlongtitude,
                          }),
                          headers: {'Content-Type': 'application/json'},
                        );

                        if (response.statusCode == 200) {
                          showSuccessDialog(
                            context,
                            "บันทึกข้อมูลสถานที่เรียบร้อยแล้ว.",
                          );
                        } else {
                          showSuccessDialog(
                            context,
                            "ไม่สามารถบันทึกข้อมูลสถานที่ได้. ${response.body}",
                          );
                        }
                      } catch (error) {
                        print('Error: $error');
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 8),
                        Text('บันทึกข้อมูล'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildReadOnlyField(
      String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true, // Set to true to disable user input
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }

  @override
  void dispose() {
    tourCodeController.dispose();
    tourNameController.dispose();
    latitudeController.dispose();
    longtitudeController.dispose();
    super.dispose();
  }

  void showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => showTour(),
                  ),
                );
              },
              child: Text('กลับไปที่รายการสถานที่'),
            ),
          ],
        );
      },
    );
  }
}
