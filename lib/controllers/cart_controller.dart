import 'package:get/get.dart';
import 'package:getx_sqflite/models/product.dart';
import 'package:getx_sqflite/utils/database_helper.dart';

class CartController extends GetxController {
  // list of stored in a cart
  var cartItems = List<Product>().obs;

  @override
  void onInit() {
    // fetch cartItems from database
    ProductDatabaseHelper.db
        .getCartProductList()
        .then((cartList) => {cartItems.value = cartList});
    super.onInit();
  }
  // get total price of cartItems 
  double get totalPrice => cartItems.fold(0, (sum, item) => sum + item.price);
  // get total items in cart count. 
  int get count => cartItems.length;

  /// add products to cart
  void addToCart(Product product) {
    if (product.id != null) {
      product.id = null;
    }
    ProductDatabaseHelper.db.insertProduct(product, cart: true).then((id) {
      product.id = id;
      cartItems.add(product);
    });
  }
  /// remove products from cart
  void removeFromCart(Product product) {
    if (product.id != null) {
      ProductDatabaseHelper.db
          .deleteProduct(product.id, cart: true)
          .then((value) => {cartItems.remove(product)});
    }
  }

  /// reset cart and clear all items
  void resetCart() async {
    cartItems.forEach((product) async {
      // print("${product.id} ${product.name}");
      var result =
          await ProductDatabaseHelper.db.deleteProduct(product.id, cart: true);
      if (result == 1) {
        cartItems.remove(product);
      } else {
        await ProductDatabaseHelper.db.deleteProduct(product.id, cart: true);
      }
    });
    //  cartItems.value = [];
  }
}
