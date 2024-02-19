import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463036/tram_table/list_tramtb.dart';

class EditTramtbPage extends StatefulWidget {
  final Map<String, dynamic> data;

  EditTramtbPage({required this.data});

  @override
  _EditTramtbPageState createState() => _EditTramtbPageState();
}

class _EditTramtbPageState extends State<EditTramtbPage> {
  late TextEditingController No_tramController;
  late TextEditingController tourCodeController;
  late TextEditingController timeController;
  List<Map<String, dynamic>> tourCodes = [];
  Map<String, dynamic>? selectedtour;

  @override
  void initState() {
    super.initState();
    No_tramController =
        TextEditingController(text: widget.data['No_tram'].toString());
    tourCodeController =
        TextEditingController(text: widget.data['tourCode'].toString());
    timeController =
        TextEditingController(text: widget.data['time'].toString());
    fetchTourCodes().then((codes) {
      setState(() {
        tourCodes = codes;
        selectedtour = tourCodes.isNotEmpty ? tourCodes[0] : null;
      });
    });
  }

  Future<List<Map<String, dynamic>>> fetchTourCodes() async {
    final response = await http.get(Uri.parse(
        'http://localhost:88/apiflutter_MiniProject/tourAt/show_tour.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((item) => {
                'tourName': item['tourName'] as String,
                'tourCode': item['tourCode'] as String,
              })
          .toList();
    } else {
      throw Exception('Failed to load shop codes');
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
        title: Text('แก้ไขเส้นทางเดินรถ'),
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
                      'images/bus-stop.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  buildReadOnlyField('รหัส', No_tramController),
                  DropdownButtonFormField(
                    value: tourCodeController.text,
                    items: tourCodes.map((Map<String, dynamic> shop) {
                      return DropdownMenuItem<String>(
                        value: shop['tourCode'] as String,
                        child: Text(shop['tourName'] as String),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        tourCodeController.text = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'รหัสสถานที่ท่องเที่ยว',
                    ),
                  ),
                  SizedBox(height: 20),
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
                  ElevatedButton(
                    onPressed: () async {
                      String updatedNo_tram = No_tramController.text;
                      String updatedtourCode = tourCodeController.text;
                      String updatedtime = timeController.text;

                      String apiUrl =
                          'http://localhost:88/apiflutter_MiniProject/tramTB/crud_tourTB.php?case=PUT';

                      try {
                        var response = await http.put(
                          Uri.parse(apiUrl),
                          body: json.encode({
                            'No_tram': updatedNo_tram,
                            'tourCode': updatedtourCode,
                            'time': updatedtime,
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
    No_tramController.dispose();
    tourCodeController.dispose();
    timeController.dispose();

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
                    builder: (context) => showTramTB(),
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
