import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463036/mainmenu.dart';
import 'package:mn_641463036/product/add_pro.dart';
import 'package:mn_641463036/product/edit_pro.dart';

class showPro extends StatefulWidget {
  @override
  _showProState createState() => _showProState();
}

class _showProState extends State<showPro> {
  late Future<List<Map<String, dynamic>>> _tourData;

  Future<List<Map<String, dynamic>>> _fetchPlantData() async {
    final response = await http.get(Uri.parse(
        'http://localhost:88/apiflutter_MiniProject/product/show_pro.php'));
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
    _tourData = _fetchPlantData();
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
              'สินค้า',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => addPro(),
                  ),
                );
              },
              child: Text('เพิ่มข้อมูลใหม่'),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _tourData,
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
                      'images/products.png',
                      width: 40,
                      height: 40,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'สินค้า',
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
                        DataColumn(label: Text('รหัสร้านค้า')),
                        DataColumn(label: Text('รหัสสินค้า')),
                        DataColumn(label: Text('ชื่อสินค้า')),
                        DataColumn(label: Text('หน่วยนับ')),
                        DataColumn(label: Text('ราคา')),
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
                            DataCell(Text(data['shopCode'].toString())),
                            DataCell(Text(data['proCode'].toString())),
                            DataCell(Text(data['proName'].toString())),
                            DataCell(Text(data['unti'].toString())),
                            DataCell(Text(data['price'].toString())),
                            DataCell(IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditProPage(data: data),
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
                                      content:
                                          Text('คุณต้องการลบข้อมูลสถานที่นี้?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            String apiUrl =
                                                'http://localhost:88/apiflutter_MiniProject/product/del_tour.php';
                                            try {
                                              final response = await http.post(
                                                Uri.parse(apiUrl),
                                                body: {
                                                  'shopCode': data['shopCode']
                                                      .toString(),
                                                  'proCode': data['proCode']
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
                                                          'ลบข้อมูลสินค้าสำเร็จ'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            setState(() {
                                                              _tourData =
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
                                                          'ไม่สามารถลบข้อมูลสินค้าได้'),
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
    home: showPro(),
  ));
}
