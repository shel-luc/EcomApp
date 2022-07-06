import 'package:flutter/material.dart';
import 'package:luxstore/helpers/database_helper.dart';
import 'Screens/products_screen.dart';
import 'Screens/home_page_screen.dart';
import 'services/secure_storage.dart';


String? token;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SecureStorageService _storageService = SecureStorageService();
  token = await _storageService.read("token");

  final DatabaseHelper dbClient = DatabaseHelper();
  dbClient.initDb();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePageScreen(),
    );
  }
}
