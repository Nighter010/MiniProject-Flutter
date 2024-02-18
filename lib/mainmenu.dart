import 'package:flutter/material.dart';
import 'package:mn_641463036/map/gpstracking.dart';
import 'package:mn_641463036/product/list_pro.dart';
import 'package:mn_641463036/shop/list_shop.dart';
import 'package:mn_641463036/tour_at/list_tour.dart';
// import 'package:tourlism_root_641463036/splash_screen.dart';

// import 'package:smarttracking/register.dart';
// import 'package:http/http.dart' as http;
// import 'dart:js';

// import 'package:tourlism_root_641463036/TourAt/listTourAt.dart';
// import 'package:tourlism_root_641463036/shopType/listTypeShop.dart';
// import 'package:tourlism_root_641463036/shop/listShop.dart';
// import 'package:tourlism_root_641463036/Bus/listBusT.dart';

import 'package:mn_641463036/tram/list_tram.dart';
import 'package:mn_641463036/tram_table/list_tramtb.dart';

class mainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Twin สำหรับเส้นทางของรถรางนำเที่ยว'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.of(context).pushReplacement(MaterialPageRoute(
            //   builder: (context) => SplashScreen(),
            // ));
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => showTram(),
                        ));
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'images/tram.png',
                            width: screenWidth * 0.12,
                            height: screenWidth * 0.12,
                          ),
                          Text(
                            'รถราง',
                            style: TextStyle(
                              fontSize: screenWidth * 0.015,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(screenWidth * 0.15, screenWidth * 0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => showTour(),
                        ));
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'images/tourAT.png',
                            width: screenWidth * 0.12,
                            height: screenWidth * 0.12,
                          ),
                          Text(
                            'สถานที่ท่องเที่ยว',
                            style: TextStyle(
                              fontSize: screenWidth * 0.013,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(screenWidth * 0.15, screenWidth * 0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => showTramTB(),
                        ));
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'images/bus-stop.png',
                            width: screenWidth * 0.12,
                            height: screenWidth * 0.12,
                          ),
                          Text(
                            'ตารางเดินรถ',
                            style: TextStyle(
                              fontSize: screenWidth * 0.013,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(screenWidth * 0.15, screenWidth * 0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => showShop(),
                        ));
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'images/store.png',
                            width: screenWidth * 0.12,
                            height: screenWidth * 0.12,
                          ),
                          Text(
                            'ร้านค้า',
                            style: TextStyle(
                              fontSize: screenWidth * 0.013,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(screenWidth * 0.15, screenWidth * 0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => showPro(),
                        ));
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'images/products.png',
                            width: screenWidth * 0.12,
                            height: screenWidth * 0.12,
                          ),
                          Text(
                            'สินค้า',
                            style: TextStyle(
                              fontSize: screenWidth * 0.013,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(screenWidth * 0.15, screenWidth * 0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => GPSTracking(),
                        ));
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'images/map.png',
                            width: screenWidth * 0.12,
                            height: screenWidth * 0.12,
                          ),
                          Text(
                            'แผนที่',
                            style: TextStyle(
                              fontSize: screenWidth * 0.013,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(screenWidth * 0.15, screenWidth * 0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
