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

  List<Map<String, dynamic>> shopCodes = [];
  Map<String, dynamic>? selectedShop;

  @override
  void initState() {
    super.initState();
    fetchShopCodes().then((codes) {
      setState(() {
        shopCodes = codes;
        selectedShop = shopCodes.isNotEmpty ? shopCodes[0] : null;
      });
    });
  }

  Future<List<Map<String, dynamic>>> fetchShopCodes() async {
    final response = await http.get(Uri.parse(
        'http://localhost:88/apiflutter_MiniProject/shop/show_shop.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((item) => {
                'shopName': item['shopName'] as String,
                'shopCode': item['shopCode'] as String,
              })
          .toList();
    } else {
      throw Exception('Failed to load shop codes');
    }
  }

  void addPro() async {
    String proName = proNameController.text;
    String unti = untiController.text;
    String price = priceController.text;

    String apiUrl =
        'http://localhost:88/apiflutter_MiniProject/product/add_tour.php';

    Map<String, dynamic> requestBody = {
      'shopCode': selectedShop!['shopCode'],
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
        title: Text('เพิ่มสินค้า'),
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
            DropdownButtonFormField<Map<String, dynamic>>(
              value: selectedShop,
              items: shopCodes.map((Map<String, dynamic> shop) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: shop,
                  child: Text(shop['shopName'] as String),
                );
              }).toList(),
              onChanged: (Map<String, dynamic>? newValue) {
                setState(() {
                  selectedShop = newValue!;
                });
              },
              decoration: InputDecoration(labelText: 'ร้านค้า'),
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
