import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badge;
import 'package:provider/provider.dart';
import 'package:shopping_cart/cart_provider.dart';
import 'package:shopping_cart/cart_screen.dart';
import 'package:shopping_cart/components/reusable_row.dart';
import 'package:shopping_cart/db_helper.dart';
import 'package:shopping_cart/model/model.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  DbHelper dbHelper = DbHelper();
  List<String> productName = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'Cherry',
    'Peach',
    'Mixed Fruit Basket'
  ];
  List<String> productUnit = ['KG', 'Dozen', 'KG', 'Dozen', 'KG', 'KG', 'KG'];
  List<String> productImage = [
    'https://thumbs.dreamstime.com/b/mango-leaf-long-slices-isolated-white-background-fresh-cut-as-package-design-element-71454082.jpg',
    'https://img.freepik.com/premium-vector/orange-fruits-vector-white-background-free-vector_512531-52.jpg',
    'https://img.freepik.com/premium-photo/grape-fruit-white-background_987687-409.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrWeWlhtJ6lKxvPXnkaJSquHM3yJPtBnG8gpL2RVoaKa5pzp8ZScHwid_L9Qea6fbLpI8&usqp=CAU',
    'https://img.freepik.com/premium-photo/cherry-fruit-white-background_140916-7057.jpg?w=740',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSeAp8UPEcl3bJDz7e5mzJzh_8Mn5VO-FCkAg&s',
    'https://img.freepik.com/premium-photo/mixed-fruit-basket-healthy-life-white-background-generated-by-ai_1025753-1.jpg'
  ];
  List<int> productPrice = [10, 20, 30, 40, 50, 60, 70];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
          title: const Text('Product List'),
          centerTitle: true,
          backgroundColor: Colors.amber,
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartScreen()));
              },
              child: Center(
                child: badge.Badge(
                  badgeContent:
                      Consumer<CartProvider>(builder: (context, value, child) {
                    return Text(
                      value.getCounter().toString(),
                      style: TextStyle(color: Colors.white),
                    );
                  }),
                  badgeAnimation: const BadgeAnimation.fade(
                      animationDuration: Duration(milliseconds: 300)),
                  child: const Icon(Icons.shopping_bag_outlined),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
          ]),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: productName.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              children: [
                                Image(
                                    height: 100,
                                    width: 100,
                                    image: NetworkImage(
                                        productImage[index].toString())),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productName[index].toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        productUnit[index].toString() +
                                            " " +
                                            r"$" +
                                            productPrice[index].toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: () {
                                            dbHelper
                                                .insert(Cart(
                                                    id: index,
                                                    productId: index.toString(),
                                                    productName:
                                                        productName[index]
                                                            .toString(),
                                                    initialPrice:
                                                        productPrice[index],
                                                    productPrice:
                                                        productPrice[index],
                                                    quantity: 1,
                                                    unitTag: productUnit[index]
                                                        .toString(),
                                                    image: productImage[index]
                                                        .toString()))
                                                .then((value) {
                                              print('Product is added to Cart');
                                              cart.addTotalPrice(double.parse(
                                                  productPrice[index]
                                                      .toString()));
                                              cart.addCounter();
                                            }).onError((error, StackTrace) {
                                              print(error.toString());
                                            });
                                          },
                                          child: Container(
                                            height: 35,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: const Center(
                                              child: Text(
                                                'Add to Cart',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  })),
        ],
      ),
    );
  }
}
