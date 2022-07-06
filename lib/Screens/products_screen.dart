import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:luxstore/Screens/detail_screen.dart';
import 'package:luxstore/widgets/product.dart';

import '../services/api.dart';
import '../services/notification.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List cart = [];
  bool loading = true;
  late List productList = [];

  final secureStorage = const FlutterSecureStorage();

  Future<void> getProductsFromApi() async {
     setState(() {
    loading = true;
  });
  var response = await APIService.get("https://fakestoreapi.com/products");
  if(response.isNotEmpty) {
     setState(() {
      productList = response.map<Product>((map){
      map['category'] = {'name': map['category']};
        return Product.fromMap(map);
      }).toList();
    });
  }
  setState(() {
    loading = false;
  });
  }

  Future<void> getCartFromLocalStorage() async {
    String? data = await secureStorage.read(key: "cart");
    if (data != null) {
      cart = jsonDecode(data);
    }
  }

  @override
  void initState() {
    getProductsFromApi();
    getCartFromLocalStorage();
    NotificationService().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product list"), actions: [
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
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: getProductsFromApi,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5.0,
                  crossAxisSpacing: 5.0,
                  children: productList.map((pr) {
                    return Product(
                      productMap: pr,
                      onAddToCart: () {
                        if (cart.contains(pr['id'])) {
                          setState(() {
                            cart.remove(pr['id']);
                          });
                        } else {
                          setState(() {
                            cart.add(pr['id']);
                          });
                        }
                        secureStorage.write(
                            key: "cart", value: jsonEncode(cart));
                      },
                      cartBtnStyle: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          cart.contains(pr['id'])? Colors.red : Colors.black)
                        ),
                        onTap: (){
                           Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailScreen(
                        productId: pr['id'],
                        detailProduct: pr,
                      )));
                        },
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
