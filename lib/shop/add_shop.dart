import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463036/shop/list_shop.dart';

class addShop extends StatefulWidget {
  @override
  _addShopState createState() => _addShopState();
}

class _addShopState extends State<addShop> {
  TextEditingController shopCodeController = TextEditingController();
  TextEditingController shopNameController = TextEditingController();

  void addShop() async {
    String shopCode = shopCodeController.text;
    String shopName = shopNameController.text;

    // Replace the URL with the API endpoint for inserting into tourist_attraction
    String apiUrl =
        'http://localhost:88/apiflutter_MiniProject/shop/add_shop.php';

    Map<String, dynamic> requestBody = {
      'shopCode': shopCode,
      'shopName': shopName,
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
        backgroundColor: Color.fromARGB(255, 0, 94, 255),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => showShop(),
            ));
          },
        ),
        centerTitle: true,
        title: Text('เพิ่มร้านค้า'),
        titleTextStyle: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: shopNameController,
              decoration: InputDecoration(labelText: 'ชื่อร้านค้า'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: addShop,
              child: Text('เพิ่มร้านค้า'),
              style: OutlinedButton.styleFrom(
                fixedSize: Size(300, 50),
                side: BorderSide(
                  color: Color.fromARGB(255, 39, 186, 39),
                  width: 2.0,
                ),
                backgroundColor: Color.fromARGB(255, 45, 149, 45),
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
        content: Text('ข้อมูลร้านค้า บันทึกเรียบร้อยแล้ว..'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => showShop(),
              ));
            },
            child: Text('ไปที่เมนูหลัก'),
          ),
        ],
      );
    },
  );
}
