import 'package:sqflite/sqflite.dart';

import '../models/product_model.dart';
import 'database_helper.dart';

class ProductHelper {
  final _tableName = 'products';

  Future<void> insertProduct(Product product) async {
    // rekipere referans baz done a
    final helper = DatabaseHelper();
    Database db = await helper.db;

    // ensere done map yo, nan tab prodwi a
    await db.insert(_tableName, product.toMap());
  }

  Future<Product?> getProduct(Product product) async {
    // rekipere referans baz done a
    final helper = DatabaseHelper();
    Database db = await helper.db;

    // rekipere done sible a nan tab prodwi a
    Map<String, dynamic>? productMap =
        (await db.query(_tableName, where: 'id =  ?', whereArgs: [product.id]))
            as Map<String, dynamic>?;

    // konvèti map prodwi a, an modèl prodwi.
    if (productMap != null) {
      return Product.fromMap(productMap);
    }
  }

  Future<List<Product>> getProducts() async {
    // rekipere referans baz done a
    final helper = DatabaseHelper();
    Database db = await helper.db;

    // rekipere lis done nan tab prodwi a
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    // konvèti lis map prodwi yo, an lis modèl prodwi.
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  Future<void> updateProduct(Product product) async {
    // rekipere referans baz done a
    final helper = DatabaseHelper();
    Database db = await helper.db;

    // Modifye prodwi ki pase an paramèt la, gras ak id prodwi a.
    await db.update(_tableName, product.toMap(), where: 'id = ?',
        // Se la pou n mete valè ki ap konpare nan agiman an
        // pou evite enjeksyon SQL.
        whereArgs: [product.id]);
  }

  Future<void> deleteProduct(Product product) async {
    // rekipere referans baz done a
    final helper = DatabaseHelper();
    Database db = await helper.db;

    // Efase prodwi ki pase an paramèt la, gras ak id prodwi a.
    await db.delete(_tableName, where: 'id = ?',
        // Se la pou n mete valè ki ap konpare nan agiman an
        // pou evite enjeksyon SQL.
        whereArgs: [product.id]);
  }

  Future<Product?> getProductById(int productId) async {
    // rekipere referans baz done a
    final helper = DatabaseHelper();
    Database db = await helper.db;

    // rekipere done nan tab prodwi a
    final List<Map<String, dynamic>> productMaps = await db
        .rawQuery('''SELECT * FROM $_tableName WHERE name=?''', [productId]);

    // konvèti done sa, an modèl prodwi.
    if (productMaps.isNotEmpty) {
      return Product.fromMap(productMaps[0]);
    }
    return null;
  }

  Future<void> insertProducts(List<Product> products) async {
    // rekipere referans baz done a
    final helper = DatabaseHelper();
    Database db = await helper.db;

    // ensere done map la, nan tab prodwi a
    Batch batch = db.batch();
    products.forEach((pr) {
      batch.insert(_tableName, pr.toMap());
    });
    batch.commit();
  }
}
