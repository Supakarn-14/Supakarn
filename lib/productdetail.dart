import 'package:flutter/material.dart';

// รับข้อมูลสินค้าที่ส่งมา
class ProductDetail extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductDetail({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 10), // เว้นระยะระหว่างไอคอนกับข้อความ
            Text(
              product['name'], // ใช้ชื่อสินค้าแทน "MENU MAIN"
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ชื่อสินค้า
            Text(
              'ชื่อสินค้า: ${product['name']}',
              style: TextStyle(
                fontSize: 22, // ขนาดตัวอักษรใหญ่ขึ้น
                fontWeight: FontWeight.bold,
                color: Colors.black87, // สีข้อความเข้ม
              ),
            ),
            const SizedBox(height: 12), // ช่องว่างระหว่างชื่อสินค้า

            // รายละเอียดสินค้า
            Text(
              'รายละเอียด: ${product['description']}',
              style: TextStyle(
                fontSize: 16, // ขนาดตัวอักษรกำลังดี
                color: Colors.grey[800], // สีอ่อนเล็กน้อย เพื่อความอ่านง่าย
              ),
            ),
            const SizedBox(height: 12), // ช่องว่างระหว่างรายละเอียด

            // ราคา
            Text(
              'ราคา: ${product['price']} บาท',
              style: TextStyle(
                fontSize: 18, // ขนาดตัวอักษรใหญ่ขึ้นเล็กน้อย
                fontWeight: FontWeight.bold, // ทำให้ราคาดูเด่น
                color: Colors.green[700], // สีเขียวเพื่อเน้นราคา
              ),
            ),
            const SizedBox(height: 12), // ช่องว่างระหว่างราคา

            // จำนวนสินค้า
            Text(
              'จำนวน: ${product['quantity']} ชิ้น',
              style: TextStyle(
                fontSize: 16, // ขนาดตัวอักษรปกติ
                color: Colors.blueGrey, // สีข้อความไม่เด่นมาก
              ),
            ),
          ],
        ),
      ),
    );
  }
}
