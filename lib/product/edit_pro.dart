import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mn_641463036/product/list_pro.dart';

class EditProPage extends StatefulWidget {
  final Map<String, dynamic> data;

  EditProPage({required this.data});

  @override
  _EditProPageState createState() => _EditProPageState();
}

class _EditProPageState extends State<EditProPage> {
  late TextEditingController shopCodeController;
  late TextEditingController proCodeController;
  late TextEditingController proNameController;
  late TextEditingController untiController;
  late TextEditingController priceController;

  List<Map<String, dynamic>> shopCodes = [];
  Map<String, dynamic>? selectedShop;

  @override
  void initState() {
    super.initState();
    shopCodeController =
        TextEditingController(text: widget.data['shopCode'].toString());
    proCodeController =
        TextEditingController(text: widget.data['proCode'].toString());
    proNameController =
        TextEditingController(text: widget.data['proName'].toString());
    untiController =
        TextEditingController(text: widget.data['unti'].toString());
    priceController =
        TextEditingController(text: widget.data['price'].toString());
    fetchShopCode().then((codes) {
      setState(() {
        shopCodes = codes;
        selectedShop = shopCodes.isNotEmpty ? shopCodes[0] : null;
      });
    });
  }

  Future<List<Map<String, dynamic>>> fetchShopCode() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขสินค้า'),
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
                      'images/products.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  DropdownButtonFormField(
                    value: shopCodeController.text,
                    items: shopCodes.map((Map<String, dynamic> shop) {
                      return DropdownMenuItem<String>(
                        value: shop['shopCode'] as String,
                        child: Text(shop['shopName'] as String),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        shopCodeController.text = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'รหัสร้านค้า',
                    ),
                  ),
                  buildReadOnlyField('รหัสสินค้า', proCodeController),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: proNameController,
                    decoration: InputDecoration(
                      labelText: 'ชื่อสินค้า',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: untiController,
                    decoration: InputDecoration(
                      labelText: 'หน่วยนับ',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: priceController,
                    decoration: InputDecoration(
                      labelText: 'ราคา',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      String updatedshopCode = shopCodeController.text;
                      String updatedproCode = proCodeController.text;
                      String updatedproName = proNameController.text;
                      String updatedunti = untiController.text;
                      String updatedprice = priceController.text;

                      String apiUrl =
                          'http://localhost:88/apiflutter_MiniProject/product/crud_tour.php?case=PUT';

                      try {
                        var response = await http.put(
                          Uri.parse(apiUrl),
                          body: json.encode({
                            'proCode': updatedproCode,
                            'shopCode': updatedshopCode,
                            'proName': updatedproName,
                            'unti': updatedunti,
                            'price': updatedprice,
                          }),
                          headers: {'Content-Type': 'application/json'},
                        );

                        if (response.statusCode == 200) {
                          showSuccessDialog(
                            context,
                            "บันทึกข้อมูลสินค้าเรียบร้อยแล้ว.",
                          );
                        } else {
                          showSuccessDialog(
                            context,
                            "ไม่สามารถบันทึกข้อมูลสินค้าได้. ${response.body}",
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
    shopCodeController.dispose();
    proCodeController.dispose();
    proNameController.dispose();
    untiController.dispose();
    priceController.dispose();
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
                    builder: (context) => showPro(),
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
