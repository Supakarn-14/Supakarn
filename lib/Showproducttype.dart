import 'package:flutter/material.dart';
import 'dart:async';
import 'showfiltertype.dart';

// Main method to run the app
void main() {
  runApp(MyApp());
}

// StatelessWidget for the app root
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tour List',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(239, 245, 188, 2)),
        useMaterial3: true,
      ),
      home: Showproducttype(),
    );
  }
}

// StatefulWidget to manage the interactive state
class Showproducttype extends StatefulWidget {
  @override
  State<Showproducttype> createState() => _MyHomePageState();
}

// State class for the Tour widget
class _MyHomePageState extends State<Showproducttype> {
  final List<Map<String, dynamic>> items1 = [
    {
      'name': 'Electronics',
      'icon': Icons.devices, // ไอคอนสำหรับ Electronics
    },
    {
      'name': 'Clothing',
      'icon': Icons.checkroom, // ไอคอนสำหรับ Clothing
    },
    {
      'name': 'Food',
      'icon': Icons.fastfood, // ไอคอนสำหรับ Food
    },
    {
      'name': 'Books',
      'icon': Icons.book, // ไอคอนสำหรับ Books
    },
    // เพิ่มประเภทสินค้าอื่น ๆ พร้อมไอคอนได้ที่นี่
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 10),
            Text(
              'ประเภทสินค้า',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        elevation: 5,
        toolbarHeight: 70,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(50),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                height: 800,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 15.0,
                    childAspectRatio: 2,
                  ),
                  itemCount: items1.length,
                  itemBuilder: (context, index) {
                    final item = items1[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ShowFilterType(category: item['name']),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black, // Set card color to black
                          border: Border.all(
                            color: Colors.white, // Set border color to white
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${item['name']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors
                                          .white, // Set text color to white
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                  Icon(
                                    item['icon'], // Use the icon from the list
                                    size: 24,
                                    color:
                                        Colors.white, // Set icon color to white
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
