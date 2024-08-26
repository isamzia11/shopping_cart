import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/cart_provider.dart';
import 'package:badges/badges.dart' as badge;
import 'package:badges/badges.dart';
import 'package:shopping_cart/components/reusable_row.dart';
import 'package:shopping_cart/db_helper.dart';
import 'package:shopping_cart/model/model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DbHelper dbHelper = DbHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
          title: const Text('My Cart'),
          centerTitle: true,
          backgroundColor: Colors.amber,
          actions: [
            Center(
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
            const SizedBox(
              width: 20,
            ),
          ]),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FutureBuilder(
                future: cart.getData(),
                builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          Center(
                              child: Image(
                                  height: 300,
                                  width: 300,
                                  image: AssetImage('images/cart2.png'))),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            'Your Cart is Empty',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      );
                    } else {
                      return Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          children: [
                                            Image(
                                                height: 100,
                                                width: 100,
                                                image: NetworkImage(snapshot
                                                    .data![index].image
                                                    .toString())),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        snapshot.data![index]
                                                            .productName
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      InkWell(
                                                          onTap: () {
                                                            dbHelper.delete(
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .id!);

                                                            cart.deleteCounter();

                                                            cart.remvoeTotalPrice(
                                                                double.parse(snapshot
                                                                    .data![
                                                                        index]
                                                                    .productPrice
                                                                    .toString()));
                                                          },
                                                          child: Icon(
                                                              Icons.delete)),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    snapshot.data![index]
                                                            .unitTag
                                                            .toString() +
                                                        " " +
                                                        r"$" +
                                                        snapshot.data![index]
                                                            .productPrice
                                                            .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Container(
                                                      height: 35,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                int quantity =
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .quantity!;
                                                                int price = snapshot
                                                                    .data![
                                                                        index]
                                                                    .initialPrice!;
                                                                quantity--;
                                                                int? newPrice =
                                                                    price *
                                                                        quantity;
                                                                if (quantity >
                                                                    0) {
                                                                  dbHelper!
                                                                      .updtadeQuantity(Cart(
                                                                          id: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .id,
                                                                          productId: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .id
                                                                              .toString(),
                                                                          productName: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .productName,
                                                                          initialPrice: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .initialPrice,
                                                                          productPrice:
                                                                              newPrice,
                                                                          quantity:
                                                                              quantity,
                                                                          unitTag: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .unitTag
                                                                              .toString(),
                                                                          image: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .image
                                                                              .toString()))
                                                                      .then(
                                                                          (value) {
                                                                    newPrice =
                                                                        0;
                                                                    quantity =
                                                                        0;
                                                                    cart.remvoeTotalPrice(double.parse(snapshot
                                                                        .data![
                                                                            index]
                                                                        .initialPrice
                                                                        .toString()));
                                                                  }).onError((error,
                                                                          stackTrace) {
                                                                    print(error
                                                                        .toString());
                                                                  });
                                                                }
                                                              },
                                                              child: const Icon(
                                                                Icons.remove,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            Text(
                                                              snapshot
                                                                  .data![index]
                                                                  .quantity
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                int quantity =
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .quantity!;
                                                                int price = snapshot
                                                                    .data![
                                                                        index]
                                                                    .initialPrice!;
                                                                quantity++;
                                                                int? newPrice =
                                                                    price *
                                                                        quantity;
                                                                dbHelper!
                                                                    .updtadeQuantity(Cart(
                                                                        id: snapshot
                                                                            .data![
                                                                                index]
                                                                            .id,
                                                                        productId: snapshot
                                                                            .data![
                                                                                index]
                                                                            .id
                                                                            .toString(),
                                                                        productName: snapshot
                                                                            .data![
                                                                                index]
                                                                            .productName,
                                                                        initialPrice: snapshot
                                                                            .data![
                                                                                index]
                                                                            .initialPrice,
                                                                        productPrice:
                                                                            newPrice,
                                                                        quantity:
                                                                            quantity,
                                                                        unitTag: snapshot
                                                                            .data![
                                                                                index]
                                                                            .unitTag
                                                                            .toString(),
                                                                        image: snapshot
                                                                            .data![
                                                                                index]
                                                                            .image
                                                                            .toString()))
                                                                    .then(
                                                                        (value) {
                                                                  newPrice = 0;
                                                                  quantity = 0;
                                                                  cart.addTotalPrice(double.parse(snapshot
                                                                      .data![
                                                                          index]
                                                                      .initialPrice
                                                                      .toString()));
                                                                }).onError((error,
                                                                        stackTrace) {
                                                                  print(error
                                                                      .toString());
                                                                });
                                                              },
                                                              child: const Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )
                                                          ],
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
                              }));
                    }
                  }
                  return Text('');
                }),
            const Spacer(),
            Consumer<CartProvider>(builder: (context, value, child) {
              return Visibility(
                visible: value.getTotalPrice().toStringAsFixed(2) == '0.00'
                    ? false
                    : true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ReusableRow(
                        title: 'Sub Total',
                        value: r'$' + value.getTotalPrice().toStringAsFixed(2)),
                    ReusableRow(
                        title: 'Discount',
                        value:
                            r' 5%' + value.getTotalPrice().toStringAsFixed(2)),
                    ReusableRow(
                        title: 'Total',
                        value: r'$' + value.getTotalPrice().toStringAsFixed(2))
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
