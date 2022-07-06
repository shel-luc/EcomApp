import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:luxstore/Screens/detail_screen.dart';
import 'package:luxstore/widgets/product.dart';
import '../services/api.dart';
import '../services/secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Screens/products_screen.dart';
import 'package:http/http.dart' as http;

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  List categoryList = [];

  @override
  void initState() {
    super.initState();
    getCartIDs();
    getCategoryFromApi();
    getProductsFromApi();
    getCartFromLocalStorage();
  }

// final secureStorage = const FlutterSecureStorage();
  final SecureStorageService _storageService = SecureStorageService();
  final secureStorage = const FlutterSecureStorage();

  List<int> cart = [];
  // List cart = [];
  bool loading = true;
  late List productList = [];

  void getCartIDs() async {
    var res = await _storageService.read('cart');
    if (res != null) {
      setState(() {
        cart = json.decode(res).cast<int>();
        // cart = json.decode(res).map<int>((e) => e as int).toList();
      });
    }
  }

  Future<void> getCartFromLocalStorage() async {
    String? data = await secureStorage.read(key: "cart");
    if (data != null) {
      cart = jsonDecode(data);
    }
  }

  Future<void> getProductsFromApi() async {
    var response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));
    if (response.statusCode == 200) {
      setState(() {
        productList = jsonDecode(response.body);
      });
    }
    loading = false;
  }

  Future<void> getCategoryFromApi() async {
    var response = await http
        .get(Uri.parse('https://fakestoreapi.com/products/categories'));
    if (response.statusCode == 200) {
      setState(() {
        categoryList = jsonDecode(response.body);
      });
    }
    loading = false;
  }

  void fetchCategories() async {
    var response =
        await APIService.get("https://fakestoreapi.com/products/categories");
    if (response != null) {
      setState(() {
        categoryList = response.map<Map<String, dynamic>>((el) {
          return {"name": el, "products": []};
        }).toList();
        if (categoryList.length > 4) {
          categoryList = categoryList.sublist(0, 4);
        }
      });
    }
  }

  int selected = 0;
  void _changeIndex(int index) {
    setState(() {
      selected = index;
    });
  }

  void onTap() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("LuxStore"),
        actions: [
          TextButton(
              onPressed: () {},
              child: const Text(
                "Pay",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.lightBlue),
            child: Center(
                child: Text(
              "LuxStore",
              style: TextStyle(fontSize: 20, color: Colors.white),
            )),
          ),
          const ListTile(title: Text("Connect")),
          ListTile(
            title: const Text("Product List"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ProductsScreen()));
            },
          ),
          ListTile(
            title: const Text("Quit"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ]),
      ),
      body: selected == 0
          ? homeBody()
          : (selected == 1 ? productListBody() : cartBoby()),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selected,
          onTap: _changeIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "Products"),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag), label: "Pay"),
          ]),
    );
  }

  Widget renderCategory(String cat, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 150,
        color: Colors.lightBlue,
        margin: const EdgeInsets.only(bottom: 10),
        child: Stack(children: [
          Positioned(
            bottom: 10,
            right: 10,
            child: Text(
              cat,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          )
        ]),
      ),
    );
  }

  Widget productListBody() {
   return RefreshIndicator(
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
                secureStorage.write(key: "cart", value: jsonEncode(cart));
              },
              cartBtnStyle: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      cart.contains(pr['id']) ? Colors.red : Colors.black)),
              onTap: () {
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
    );
  }

  Widget homeBody() {
   return Container(
    padding: const EdgeInsets.all(8),
     child: Column(
      children: [
       Column(
           children: categoryList.sublist(0,2).map((cat) {
         return renderCategory(cat, onTap: onTap);
       }).toList()),
       Expanded(
         child: GridView.count(
           crossAxisCount: 2,
           mainAxisSpacing: 3.0,
           crossAxisSpacing: 3.0,
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
               secureStorage.write(key: "cart", value: jsonEncode(cart));
               },
               cartBtnStyle: ButtonStyle(
                   backgroundColor: MaterialStateProperty.all(
                       cart.contains(pr['id']) ? Colors.red : Colors.black)),
               onTap: () {
                 Navigator.push(
                     context,
                     MaterialPageRoute(
                         builder: (context) => DetailScreen(
                               productId: pr['id'],
                               detailProduct: pr,
                             )));
               },
             );
           }).toList(),
         ),
       ),
     ]),
   );
  }

  Widget cartBoby() {
  return const Center(
      child: Text('Pay by paypal'),
    );
  }
}
