import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../model/sale.dart';
import '../model/store.dart';

class StoreProvider extends ChangeNotifier {
  List<Store> _stores = [
    Store(
        name: 'Walmart',
        location: GeoPoint(69, 69),
        sales: [
          Sale(
              description: 'Peanuts at half price',
              expiry_date: DateTime(2023, 3, 1),
              store_id: 'Walmart Id')
        ],
        store_id: 'Walmart Id'),
    Store(
        name: 'McDonalds',
        location: GeoPoint(7, 28),
        sales: [
          Sale(
              description: '5 Chicken nuggets for orders above 50 shekels',
              expiry_date: DateTime(2023, 6, 6),
              store_id: 'McDonalds Id'),
          Sale(
              description:
                  '3 shekels for a Coca-cola bottle for orders including at least 2 BigMacs',
              expiry_date: DateTime(2023, 4, 1),
              store_id: 'McDonalds Id')
        ],
        store_id: 'McDonalds Id'),
    Store(
        name: 'Nike',
        location: GeoPoint(2, 18),
        sales: [
          Sale(
              description: 'Second pair of same shoes are 25% off',
              expiry_date: DateTime(2023, 5, 7),
              store_id: 'Nike Id'),
          Sale(
              description:
                  'Cheapest of 3 pairs bought at the same time is worth 100 shekels',
              expiry_date: DateTime(2023, 3, 27),
              store_id: 'Nike Id')
        ],
        store_id: 'Nike Id')
  ];

  List<Store> get stores {
    return [..._stores];
  }

  StoreProvider();
}
