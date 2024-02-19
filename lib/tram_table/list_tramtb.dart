import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:fn_641463036/plant/edit_plant.dart';
import 'package:mn_641463036/mainmenu.dart';
import 'package:mn_641463036/tram_table/add_tramtb.dart';
import 'package:mn_641463036/tram_table/edit_tramtb.dart';

class showTramTB extends StatefulWidget {
  @override
  _showTramTBState createState() => _showTramTBState();
}

class _showTramTBState extends State<showTramTB> {
  late Future<List<Map<String, dynamic>>> _tourTBData;

  Future<List<Map<String, dynamic>>> _fetchPlantData() async {
    final response = await http.get(Uri.parse(
        'http://localhost:88/apiflutter_MiniProject/tramTB/show_tourTBJ.php'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final List<dynamic> parsed = json.decode(response.body);
      return parsed.cast<Map<String, dynamic>>();
    } else {
      throw Exception('ไม่สามารถเชื่อมต่อข้อมูลได้');
    }
  }

  @override
  void initState() {
    super.initState();
    _tourTBData = _fetchPlantData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 94, 255),
        leading: IconButton(
          icon: Icon(Icons.home_outlined),
          color: Colors.red,
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => mainMenu(),
              ),
            );
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'เส้นทางเดินรถ',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => addTramtb(),
                  ),
                );
              },
              child: Text('เพิ่มข้อมูลใหม่'),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _tourTBData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('ไม่พบข้อมูล'));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/bus-stop.png',
                      width: 40,
                      height: 40,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'เส้นทางเดินรถ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: <DataColumn>[
                        DataColumn(label: Text('ลำดับที่')),
                        DataColumn(label: Text('รหัสสถานที่')),
                        DataColumn(label: Text('ชื่อสถานที่')),
                        DataColumn(label: Text('เวลา')),
                        DataColumn(
                          label: Text('แก้ไข'),
                        ),
                        DataColumn(
                          label: Text('ลบ'),
                        ),
                      ],
                      rows: snapshot.data!.map((data) {
                        return DataRow(
                          cells: <DataCell>[
                            DataCell(Text(data['No_tram'].toString())),
                            DataCell(Text(data['tourCode'].toString())),
                            DataCell(Text(data['tourName'].toString())),
                            DataCell(Text(data['time'].toString())),
                            DataCell(IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditTramtbPage(data: data),
                                  ),
                                );
                              },
                            )),
                            DataCell(IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('ยืนยันการลบ'),
                                      content: Text(
                                          'คุณต้องการลบข้อมูลการเดินรถนี้?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            String apiUrl =
                                                'http://localhost:88/apiflutter_MiniProject/tramTB/del_tourTB.php';
                                            try {
                                              final response = await http.post(
                                                Uri.parse(apiUrl),
                                                body: {
                                                  'No_tram': data['No_tram']
                                                      .toString(),
                                                },
                                              );
                                              if (response.statusCode == 200) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text('สำเร็จ'),
                                                      content: Text(
                                                          'ลบข้อมูลตารางรถสำเร็จ'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            setState(() {
                                                              _tourTBData =
                                                                  _fetchPlantData();
                                                            });
                                                          },
                                                          child: Text('ตกลง'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text('ผิดพลาด'),
                                                      content: Text(
                                                          'ไม่สามารถลบข้อมูลเส้นทางเดินรถได้'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text('ตกลง'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            } catch (error) {
                                              print('Error: $error');
                                            }
                                          },
                                          child: Text('ยืนยัน'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('ยกเลิก'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            )),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: showTramTB(),
  ));
}
