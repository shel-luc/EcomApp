import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Screens/home_page_screen.dart';
import '../services/api.dart';
import '../services/secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


// ignore: must_be_immutable
class DetailScreen extends StatefulWidget {
  DetailScreen({Key? key, required this.detailProduct, required this.productId})
      : super(key: key);

  int productId;
  Map? detailProduct;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Map? detailProduct;
  final SecureStorageService _storageService = SecureStorageService();
  final secureStorage = const FlutterSecureStorage();

  List<int> cart = [];

  Future<void> getDetailProduct() async {
    var response = await http.get(
        Uri.parse('https://fakestoreapi.com/products/${widget.productId}'));
    if (response.statusCode == 200) {
      setState(() {
        detailProduct = jsonDecode(response.body);
      });
    }
  }
  void getCartIDs() async {
    var res = await _storageService.read('cart');
    if (res != null) {
      setState(() {
        cart = json.decode(res).cast<int>();
        // cart = json.decode(res).map<int>((e) => e as int).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDetailProduct();
    getCartIDs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(detailProduct != null ? "${detailProduct?['title']}" : "..."), actions: [
        Row(
          children: [
            Text(
              cart.length.toString(),
              style: const TextStyle(fontSize: 20.0),
            ),
            const Icon(Icons.shopping_cart)
          ],
        )
      ]),
      body: detailProduct == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    child: Image.network(detailProduct?['image']),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(detailProduct?['title']),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           if (cart.contains(detailProduct?['id'])) {
                  setState(() {
                    cart.remove(detailProduct?['id']);
                  });
                } else {
                  setState(() {
                    cart.add(detailProduct?['id']);
                  });
                }
                secureStorage.write(key: "cart", value: jsonEncode(cart));
                                },
    
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
