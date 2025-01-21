import 'package:flutter/material.dart';
import 'addproduct.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'Showproductgrid.dart';
import 'Showproducttype.dart';

//Method หลักทีRun
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDcgDoS6anfXx6rQWbpTTZrAYj2CgY5H0s",
            authDomain: "onlinefirebase-c94b6.firebaseapp.com",
            databaseURL:
                "https://onlinefirebase-c94b6-default-rtdb.firebaseio.com",
            projectId: "onlinefirebase-c94b6",
            storageBucket: "onlinefirebase-c94b6.firebasestorage.app",
            messagingSenderId: "515276937881",
            appId: "1:515276937881:web:7741aa7748f3e069bdf608",
            measurementId: "G-ZSXHP4SZ99"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

//Class stateless สั่งแสดงผลหนาจอ
class MyApp extends StatelessWidget {
  const MyApp({super.key});
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      home: Main(),
    );
  }
}

//Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class Main extends StatefulWidget {
  @override
  State<Main> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Main> {
//ส่วนเขียน Code ภาษา dart เพื่อรับค่าจากหน้าจอมาคํานวณหรือมาทําบางอย่างและส่งค่ากลับไป
//ส่วนการออกแบบหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 10), // เว้นระยะระหว่างไอคอนกับข้อความ
            Text(
              'MENU MAIN',
              style: TextStyle(
                color: Colors.white, // เปลี่ยนสีข้อความเป็นสีขาว
                fontWeight: FontWeight.bold, // เพิ่มน้ำหนักตัวอักษร
                letterSpacing: 1.5, // เพิ่มระยะห่างระหว่างตัวอักษร
              ),
            ),
          ],
        ),
        centerTitle: true, // จัดตำแหน่งข้อความตรงกลาง
        backgroundColor: Color.fromARGB(255, 0, 0, 0), // กำหนดสีพื้นหลัง
        elevation: 5, // เพิ่มเงาให้ AppBar
        toolbarHeight: 70, // กำหนดความสูงของ AppBar
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(50), // ปรับมุมล่างให้โค้งมน
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white), // เปลี่ยนสีไอคอน
      ),
      body: Stack(
        children: [
          // เนื้อหาของหน้า
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50), // ระยะห่างด้านบน

                // โลโก้
                Center(
                  child: Image.asset(
                    'assets/logo.png',
                    height: 200, // กำหนดความสูงของโลโก้
                    width: 200, // กำหนดความกว้างของโลโก้
                  ),
                ),

                SizedBox(height: 30), // เพิ่มระยะห่างระหว่างโลโก้และปุ่ม

                // ปุ่ม "จัดการข้อมูลสินค้า"
                Center(
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => addproduct()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 0, 0, 0),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      child: Text(
                        'จัดการข้อมูลสินค้า',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20), // ระยะห่างระหว่างปุ่ม

                // ปุ่ม "แสดงข้อมูลสินค้า"
                Center(
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => showproductgrid()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 0, 0, 0),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        'แสดงข้อมูลสินค้า',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20), // ระยะห่างระหว่างปุ่ม

                // ปุ่ม "ประเภทสินค้า"
                Center(
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Showproducttype()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 0, 0, 0),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        'ประเภทสินค้า',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
