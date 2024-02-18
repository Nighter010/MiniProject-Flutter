import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463036/product/list_pro.dart';
import 'dart:convert';

class addPro extends StatefulWidget {
  @override
  _addProState createState() => _addProState();
}

class _addProState extends State<addPro> {
  TextEditingController proNameController = TextEditingController();
  TextEditingController untiController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  List<String> shopCode = [];
  String? selectedShopCode;

  @override
  void initState() {
    super.initState();
    fetchShopCodes().then((codes) {
      setState(() {
        shopCode = codes;
        selectedShopCode = shopCode.isNotEmpty ? shopCode[0] : null;
      });
    });
  }

  Future<List<String>> fetchShopCodes() async {
    final response = await http.get(Uri.parse(
        'http://localhost:88/apiflutter_MiniProject/shop/show_shop.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => item['shopCode'] as String).toList();
    } else {
      throw Exception('Failed to load shop codes');
    }
  }

  void addPro() async {
    String proName = proNameController.text;
    String unti = untiController.text;
    String price = priceController.text;

    // Replace the URL with the API endpoint for inserting into tourist_attraction
    String apiUrl =
        'http://localhost:88/apiflutter_MiniProject/product/add_tour.php';

    Map<String, dynamic> requestBody = {
      'shopCode': selectedShopCode,
      'proName': proName,
      'unti': unti,
      'price': price,
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
              builder: (context) => showPro(),
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
            DropdownButtonFormField<String>(
              value: selectedShopCode,
              items: shopCode.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedShopCode = newValue!;
                });
              },
              decoration: InputDecoration(labelText: 'รหัสร้านค้า'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: proNameController,
              decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: untiController,
              decoration: InputDecoration(labelText: 'หน่วยนับ'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'ราคา'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: addPro,
              child: Text('เพิ่มสินค้า'),
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
        content: Text('ข้อมูลสินค้า บันทึกเรียบร้อยแล้ว..'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => showPro(),
              ));
            },
            child: Text('ไปที่เมนูหลัก'),
          ),
        ],
      );
    },
  );
}
