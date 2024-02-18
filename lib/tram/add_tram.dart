import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463036/tram/list_tram.dart';

class addTram extends StatefulWidget {
  @override
  _addTramState createState() => _addTramState();
}

class _addTramState extends State<addTram> {
  TextEditingController tramNoController = TextEditingController();

  void addTram() async {
    String tramNo = tramNoController.text;

    // Replace the URL with the API endpoint for inserting into tourist_attraction
    String apiUrl =
        'http://localhost:88/apiflutter_MiniProject/tram/add_tram.php';

    Map<String, dynamic> requestBody = {'tramNo': tramNo};

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
              builder: (context) => showTram(),
            ));
          },
        ),
        centerTitle: true,
        title: Text('เพิ่มรถราง'),
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
              controller: tramNoController,
              decoration: InputDecoration(labelText: 'หมายเลขรถราง'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: addTram,
              child: Text('เพิ่มรถราง'),
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
                builder: (context) => showTram(),
              ));
            },
            child: Text('ไปที่เมนูหลัก'),
          ),
        ],
      );
    },
  );
}
