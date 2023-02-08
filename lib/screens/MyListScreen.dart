import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/sale.dart';
import '../model/store.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';

class MyListScreen extends StatefulWidget {
  const MyListScreen({Key key}) : super(key: key);

  @override
  State<MyListScreen> createState() => _MyListScreenState();
}

class _MyListScreenState extends State<MyListScreen> {
  List<Store> _stores = [
    Store(name: 'Walmart', location: GeoPoint(69, 69), sales: [
      Sale(
          description: 'Peanuts at half price',
          expiry_date: DateTime(2023, 3, 1))
    ]),
    Store(name: 'McDonalds', location: GeoPoint(7, 28), sales: [
      Sale(
          description: '5 Chicken nuggets for orders above 50 shekels',
          expiry_date: DateTime(2023, 6, 6)),
      Sale(
          description:
              '3 shekels for a Coca-cola bottle for orders including at least 2 BigMacs',
          expiry_date: DateTime(2023, 4, 1))
    ]),
    Store(name: 'Nike', location: GeoPoint(2, 18), sales: [
      Sale(
          description: 'Second pair of same shoes are 25% off',
          expiry_date: DateTime(2023, 5, 7)),
      Sale(
          description:
              'Cheapest of 3 pairs bought at the same time is worth 100 shekels',
          expiry_date: DateTime(2023, 3, 27))
    ])
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My List Screen"),
      ),
    );
  }
}
