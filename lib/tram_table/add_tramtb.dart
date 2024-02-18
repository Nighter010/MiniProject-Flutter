import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463036/tram_table/list_tramtb.dart';
import 'dart:convert';

class addTramtb extends StatefulWidget {
  @override
  _addTramtbState createState() => _addTramtbState();
}

class _addTramtbState extends State<addTramtb> {
  TextEditingController No_tramController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  List<String> tourCode = [];
  String? selectedtourCode;

  @override
  void initState() {
    super.initState();
    fetchtourCodes().then((codes) {
      setState(() {
        tourCode = codes;
        selectedtourCode = tourCode.isNotEmpty ? tourCode[0] : null;
      });
    });
  }

  Future<List<String>> fetchtourCodes() async {
    final response = await http.get(Uri.parse(
        'http://localhost:88/apiflutter_MiniProject/tourAt/show_tour.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => item['tourCode'] as String).toList();
    } else {
      throw Exception('Failed to load shop codes');
    }
  }

  void addTramtb() async {
    String No_tram = No_tramController.text;
    String time = timeController.text;

    // Replace the URL with the API endpoint for inserting into tourist_attraction
    String apiUrl =
        'http://localhost:88/apiflutter_MiniProject/tramTB/add_tourTB.php';

    Map<String, dynamic> requestBody = {
      'No_tram': No_tram,
      'tourCode': tourCode,
      'time': time,
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

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        timeController.text = picked.format(context);
      });
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
              builder: (context) => showTramTB(),
            ));
          },
        ),
        centerTitle: true,
        title: Text('เพิ่มเส้นทางเดินรถ'),
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
            DropdownButtonFormField<String>(
              value: selectedtourCode,
              items: tourCode.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedtourCode = newValue!;
                });
              },
              decoration: InputDecoration(labelText: 'รหัสสถานที่ท่องเที่ยว'),
            ),
            SizedBox(height: 16.0),
            InkWell(
              onTap: () {
                selectTime(context);
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'เวลา',
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      timeController.text,
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.access_time),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: addTramtb,
              child: Text('เพิ่มเส้นทางเดินรถ'),
              style: ElevatedButton.styleFrom(
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
        content: Text('ข้อมูลเส้นทางเดินรถ บันทึกเรียบร้อยแล้ว..'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => showTramTB(),
              ));
            },
            child: Text('ไปที่เมนูหลัก'),
          ),
        ],
      );
    },
  );
}
