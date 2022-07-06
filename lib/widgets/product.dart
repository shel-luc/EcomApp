import 'dart:convert';

import 'package:flutter/material.dart';

import '../Screens/detail_screen.dart';

class Product extends StatelessWidget {
  Product(
      {Key? key,
      required this.productMap,
      required this.onAddToCart,
      required this.cartBtnStyle,
      required this.onTap})
      : super(key: key);

  Map productMap;
  VoidCallback onAddToCart;
  ButtonStyle? cartBtnStyle;
  VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent.withOpacity(0.3),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailScreen(
                        productId: productMap['id'],
                        detailProduct: productMap,
                      )));
            },
            child: SizedBox(
              height: 150.0,
              width: 150.0,
              child: Image.network(productMap['image'], fit: BoxFit.contain),
            ),
          ),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DetailScreen(
                          productId: productMap['id'],
                          detailProduct: productMap,
                        )));
              },
              child: Text(
                productMap['title'].substring(0, 10).toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
          Text(productMap['description'].substring(0, 10),
              style: const TextStyle(color: Colors.black45)),
          const SizedBox(
            height: 3.0,
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${productMap['price']} HTG"),
              const Spacer(),
              ElevatedButton(
                onPressed: onAddToCart,
                style: cartBtnStyle,
                child: const Icon(Icons.shopping_cart),
              )
            ],
          )
        ]));
  }

  static Future<void> fromMap(map) {}
}
