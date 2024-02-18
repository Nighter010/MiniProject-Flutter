import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463036/mainmenu.dart';
import 'package:mn_641463036/shop/add_shop.dart';
import 'package:mn_641463036/shop/edit_shop.dart';

class showShop extends StatefulWidget {
  @override
  _showShopState createState() => _showShopState();
}

class _showShopState extends State<showShop> {
  late Future<List<Map<String, dynamic>>> _shopData;

  Future<List<Map<String, dynamic>>> _fetchPlantData() async {
    final response = await http.get(Uri.parse(
        'http://localhost:88/apiflutter_MiniProject/shop/show_shop.php'));
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
    _shopData = _fetchPlantData();
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
              'ร้านค้า',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => addShop(),
                  ),
                );
              },
              child: Text('เพิ่มข้อมูลใหม่'),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _shopData,
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
                      'images/store.png',
                      width: 40,
                      height: 40,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'ร้านค้า',
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
                        DataColumn(label: Text('ชื่อร้านค้า')),
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
                            DataCell(Text(data['shopName'].toString())),
                            DataCell(IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditShopPage(data: data),
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
                                          Text('คุณต้องการลบข้อมูลร้านค้านี้?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            String apiUrl =
                                                'http://localhost:88/apiflutter_MiniProject/shop/del_shop.php';
                                            try {
                                              final response = await http.post(
                                                Uri.parse(apiUrl),
                                                body: {
                                                  'shopCode': data['shopCode']
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
                                                          'ลบข้อมูลร้านค้าสำเร็จ'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            setState(() {
                                                              _shopData =
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
                                                          'ไม่สามารถลบข้อมูลร้านค้าได้'),
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
    home: showShop(),
  ));
}
