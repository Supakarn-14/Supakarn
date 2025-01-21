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
      home: showproductgrid(),
    );
  }
}

//Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class showproductgrid extends StatefulWidget {
  @override
  State<showproductgrid> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<showproductgrid> {
//ส่วนเขียน Code ภาษา dart เพื่อรับค่าจากหน้าจอมาคํานวณหรือมาทําบางอย่างและส่งค่ากลับไป

  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> products = [];
//////////////////////////////////////////////////////////////////////////////
  Future<void> fetchProducts() async {
    try {
      // ดึงข้อมูลทั้งหมดจาก Realtime Database
      final snapshot = await dbRef.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];
        // วนลูปเพื่อแปลงข้อมูลเป็น Map
        snapshot.children.forEach((child) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          product['key'] =
              child.key; // เก็บ key สําหรับการอ้างอิง (เช่นการแก้ไข/ลบ)
          loadedProducts.add(product);
        });

        // เรียงข้อมูลตามราคาจากมากไปน้อย
        loadedProducts.sort((b, a) => b['price'].compareTo(a['price']));

        // อัปเดต state เพื่อแสดงข้อมูล
        setState(() {
          products = loadedProducts;
        });
        print("จํานวนรายการสินค้าทั้งหมด: ${products.length} รายการ");
      } else {
        print("ไม่พบรายการสินค้าในฐานข้อมูล");
      }
    } catch (e) {
      print("Error loading products: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
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

///////////////////////////////////////////////////
  //ฟังก์ชันแสดง AlertDialog หน้าจอเพื่อแก้ไขข้อมูล
  void showEditProductDialog(Map<String, dynamic> product) {
    // Initialize controllers with existing data
    TextEditingController nameController =
        TextEditingController(text: product['name']);
    TextEditingController descriptionController =
        TextEditingController(text: product['description']);
    TextEditingController priceController =
        TextEditingController(text: product['price'].toString());
    TextEditingController categoryController =
        TextEditingController(text: product['category'].toString());
    TextEditingController quantityController =
        TextEditingController(text: product['quantity'].toString());

    // Format the production date to the desired format
    DateTime productionDate = DateTime.parse(product['productionDate']);
    TextEditingController productionDateController = TextEditingController(
        text: DateFormat('dd-MMMM-yyyy').format(productionDate));

    // Create the dialog
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('แก้ไขข้อมูลสินค้า'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'รายละเอียด'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'ราคา'),
                ),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: 'ประเภทสินค้า'),
                ),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'จำนวน'),
                ),
                TextField(
                  controller: productionDateController,
                  decoration: InputDecoration(labelText: 'วันที่ผลิต'),
                  readOnly: true, // Make it read-only as we format it manually
                ),
                
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                // Prepare the updated data
                Map<String, dynamic> updatedData = {
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'price': int.parse(priceController.text),
                  'category': categoryController.text,
                  'quantity': int.parse(quantityController.text),
                  'productionDate': DateFormat('yyyy-MM-dd')
                      .format(productionDate), // Store the date in the database
                };

                // Update the database
                dbRef.child(product['key']).update(updatedData).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('แก้ไขข้อมูลเรียบร้อย')),
                  );
                  fetchProducts(); // Reload the data
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $error')),
                  );
                });
                Navigator.of(dialogContext).pop(); // Close dialog
              },
              child: Text('บันทึก'),
            ),
          ],
        );
      },
    );
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
        : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // จำนวนคอลัมน์
              crossAxisSpacing: 10, // ระยะห่างระหว่างคอลัมน์
              mainAxisSpacing: 5, // ระยะห่างระหว่างแถว
              childAspectRatio: 2 / 2.8, // อัตราส่วนกว้าง-ยาวของแต่ละ item
            ),
            itemCount: products.length,
            padding: const EdgeInsets.all(10), // กำหนด padding ของ GridView
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  // เมื่อกดที่แต่ละรายการ
                  print("Selected product: ${product['name']}");
                },
                child: Card(
                  elevation: 5, // ความสูงของเงา
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // ขอบมน
                  ),
                  color: Colors.black, // ตั้งค่าสีพื้นหลังของ Card เป็นสีดำ
                  child: Padding(
                    padding:
                        const EdgeInsets.all(8.0), // ระยะห่างด้านในของ Card
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ชื่อสินค้า
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: Container(
                              margin: const EdgeInsets.all(12),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255), // ตั้งค่าสีพื้นหลังของคอนเทนเนอร์
                                borderRadius: BorderRadius.circular(3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                product['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 0, 0, 0), // สีข้อความเป็นสีขาว
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: 8),

                        // รายละเอียดสินค้า
                        Text(
                          'รายละเอียดสินค้า: ${product['description']}',
                          style: const TextStyle(fontSize: 14, color: Colors.white), // สีตัวอักษรเป็นสีขาว
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 8),
                        const Spacer(), // ดันเนื้อหาขึ้นด้านบน

                        // แสดงราคาและปุ่มลบในแถวเดียวกัน
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // แสดงราคาสินค้า
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6), // ระยะห่างด้านใน
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255), // พื้นหลังสีดำสนิท
                                borderRadius:
                                    BorderRadius.circular(6), // มุมโค้งมน
                                border: Border.all(
                                  color: const Color.fromARGB(255, 255, 255, 255), // สีขอบ
                                  width: 1.5, // ความกว้างของขอบ
                                ),
                              ),
                              child: Text(
                                'ราคา: ${product['price']} บาท', // ข้อความแสดงราคา
                                style: const TextStyle(
                                  fontSize: 16, // ขนาดตัวอักษร
                                  fontWeight:
                                      FontWeight.bold, // ทำตัวอักษรหนา
                                  color: Color.fromARGB(255, 0, 0, 0), // สีข้อความเป็นสีขาว
                                ),
                                textAlign: TextAlign
                                    .center, // จัดข้อความให้อยู่ตรงกลาง
                              ),
                            ),

                            // ปุ่มลบ (ถังขยะ)

                            Container(
                              width: 40, // กำหนดความกว้างของวงกลม
                              height: 40, // กำหนดความสูงของวงกลม
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255), // พื้นหลังสีดำ
                                shape: BoxShape.circle, // รูปทรงวงกลม
                              ),
                              child: IconButton(
                                onPressed: () {
                                  showEditProductDialog(
                                      product); // เปด Dialog แกไขสินคา
                                  (
                                    product['key'],
                                    context
                                  ); // เรียกฟังก์ชันลบข้อมูล
                                },
                                icon: const Icon(Icons.edit),
                                color: const Color.fromARGB(255, 0, 0, 0), // สีของไอคอนเป็นสีขาว
                                iconSize:
                                    20, // ลดขนาดของไอคอนให้เหมาะสมกับวงกลม
                                tooltip: 'แก้ไขสินค้า',
                              ),
                            ),
                            Container(
                              width: 40, // กำหนดความกว้างของวงกลม
                              height: 40, // กำหนดความสูงของวงกลม
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255), // พื้นหลังสีดำ
                                shape: BoxShape.circle, // รูปทรงวงกลม
                              ),
                              child: IconButton(
                                onPressed: () {
                                  // กดปุ่มลบแล้วจะให้เกิดอะไรขึ้น
                                  showDeleteConfirmationDialog(product['key'],
                                      context); // เรียกฟังก์ชันลบข้อมูล
                                },
                                icon: const Icon(Icons.delete),
                                color: const Color.fromARGB(255, 0, 0, 0), // สีของไอคอนเป็นสีขาว
                                iconSize:
                                    20, // ลดขนาดของไอคอนให้เหมาะสมกับวงกลม
                                tooltip: 'ลบสินค้า',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
  );
}
}
