import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:onlineapp_supakarn/ShowProduct.dart';

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
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      home: addproduct(),
    );
  }
}

//Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class addproduct extends StatefulWidget {
  @override
  State<addproduct> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<addproduct> {
  //
  final _formKey = GlobalKey<FormState>();
  //
  final TextEditingController nameController = TextEditingController();
  final TextEditingController desController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController productidController = TextEditingController();
  //
  final categories = ['Electronics', 'Clothing', 'Food', 'Books'];
  String? selectedCategory;
  //
  final TextEditingController dateController = TextEditingController();
  //ประกาศตัวแปรเก็บคาการเลือกวันที่
  DateTime? productionDate;
//สรางฟงกชันใหเลือกวันที่
  Future<void> pickProductionDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: productionDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != productionDate) {
      setState(() {
        productionDate = pickedDate;
        dateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Future<void> saveProductToDatabase() async {
    try {
      DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
      Map<String, dynamic> productData = {
        'name': nameController.text,
        'description': desController.text,
        'category': selectedCategory,
        'productionDate': productionDate?.toIso8601String(),
        'price': double.parse(priceController.text),
        'quantity': int.parse(quantityController.text),
      };
//ใช้คําสั่ง push() เพื่อสร้าง key อัตโนมัติสําหรับสินค้าใหม่
      await dbRef.push().set(productData);
//แจ้งเตือนเมื่อบันทึกสําเร็จ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกข้อมูลสําเร็จ')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShowProduct()),
      );
      _formKey.currentState?.reset();
      nameController.clear();
      desController.clear();
      priceController.clear();
      quantityController.clear();
      dateController.clear();
      setState(() {
        selectedCategory = null;
        productionDate = null;
      });
    } catch (e) {
//แจ้งเตือนเมื่อเกิดข้อผิดพลาด
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 10), // เว้นระยะระหว่างไอคอนกับข้อความ
            Text(
              'PRODUCT INFORMATION',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // เพิ่ม Padding รอบหน้า
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // จัดชิดซ้ายให้องค์ประกอบ
              children: [
                SizedBox(height: 20.0),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: 'ชื่อสินค้า',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกชื่อสินค้า';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: desController,
                  maxLines: 3,
                  decoration: InputDecoration(
                      labelText: 'รายละเอียดสินค้า',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกรายละเอียดสินค้า';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                      labelText: 'ประเภทสินค้า',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                  items: categories
                      .map((category) => DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาเลือกประเภทสินค้า';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'วันที่ผลิตสินค้า',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => pickProductionDate(context),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาเลือกวันที่ผลิต';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: priceController,
                  decoration: InputDecoration(
                      labelText: 'ราคาสินค้า',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกราคาสินค้า';
                    }
                    if (int.tryParse(value) == null) {
                      return 'กรุณากรอกราคาสินค้าเป็นตัวเลข';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: quantityController,
                  decoration: InputDecoration(
                      labelText: 'จำนวนสินค้า',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกจำนวนสินค้า';
                    }
                    if (int.tryParse(value) == null) {
                      return 'กรุณากรอกจำนวนสินค้าเป็นตัวเลข';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        saveProductToDatabase();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 0, 0, 0)), // สีพื้นหลัง
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.black), // สีตัวอักษร
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15), // ระยะห่างในปุ่ม
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(5), // ขอบปุ่มโค้งมน
                        ),
                      ),
                      elevation:
                          MaterialStateProperty.all<double>(5), // เพิ่มเงา
                    ),
                    child: Text(
                      'บันทึกสินค้า',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // กำหนดสีข้อความเป็นสีขาว
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
