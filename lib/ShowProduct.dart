import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Method หลักทีRun
void main() {
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: ShowProduct(),
    );
  }
}

//Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class ShowProduct extends StatefulWidget {
  @override
  State<ShowProduct> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ShowProduct> {
//ส่วนเขียน Code ภาษา dart เพื่อรับค่าจากหน้าจอมาคํานวณหรือมาทําบางอย่างและส่งค่ากลับไป

  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> products = [];
//////////////////////////////////////////////////////////////////////////////
  Future<void> fetchProducts() async {
    try {
      // ดึงข้อมูลจาก Realtime Database
      final snapshot = await dbRef.get(); // ใช้ dbRef โดยตรง
      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];
        // วนลูปเพื่อแปลงข้อมูลเป็น Map
        snapshot.children.forEach((child) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          product['key'] =
              child.key; // เก็บ key สำหรับการอ้างอิง (เช่นการแก้ไข/ลบ)
          loadedProducts.add(product);
        });

        loadedProducts.sort((a, b) => b['price'].compareTo(a['price']));

        // อัปเดต state เพื่อแสดงข้อมูล
        setState(() {
          products = loadedProducts;
        });
        print(
            "จำนวนรายการสินค้าทั้งหมด: ${products.length} รายการ"); // Debugging
      } else {
        print("ไม่พบรายการสินค้าในฐานข้อมูล"); // กรณีไม่มีข้อมูล
      }
    } catch (e) {
      print("Error loading products: $e"); // แสดงข้อผิดพลาดทาง Console
      // แสดง Snackbar เพื่อแจ้งเตือนผู้ใช้
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }

  /////////////////////////
  ///
  //ฟังก์ชันถามยืนยันก่อนลบ
  void deleteProduct(String key, BuildContext context) {
//คําสั่งลบโดยอ้างถึงตัวแปร dbRef ที่เชือมต่อตาราง product ไว้
    dbRef.child(key).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ลบสินค้าเรียบร้อย')),
      );
    fetchProducts();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }

  void showDeleteConfirmationDialog(String key, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการปิ ด Dialog โดยการแตะนอกพื้นที่
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจว่าต้องการลบสินค้านี้ใช่หรือไม่?'),
          actions: [
// ปุ่ มยกเลิก
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
              },
              child: Text('ไม่ลบ'),
            ),
// ปุ่ มยืนยันการลบ
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
                deleteProduct(key, context); // เรียกฟังก์ชันลบข้อมูล
//ข้อความแจ้งว่าลบเรียบร้อย
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ลบข้อมูลเรียบร้อยแล้ว'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('ลบ', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  ///////////////
  @override
  void initState() {
    super.initState();
    fetchProducts(); // เรียกใช้เมื่อ Widget ถูกสร้าง
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd-MMMM-yyyy').format(parsedDate);
  }

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
              'LIST PRODUCT',
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
      body: products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(product['name']),
                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // จัดให้ชิดซ้าย
                      children: [
                        Text('รายละเอียดสินค้า: ${product['description']}'),
                        Text(
                            'วันที่ผลิต: ${formatDate(product['productionDate'])}'),
                        Text('ราคา : ${product['price']} บาท'),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 80,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                              255, 0, 0, 0), // พื้นหลังสีแดงอ่อน
                          shape: BoxShape.circle, // รูปทรงวงกลม
                        ),
                        child: IconButton(
                          onPressed: () {
                            showDeleteConfirmationDialog(
                                product['key'], context);
                          },
                          icon: Icon(Icons.delete),
                          color: const Color.fromARGB(255, 255, 255, 255),
                          iconSize: 30,
                          tooltip: 'ลบสินค้า',
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  
}
