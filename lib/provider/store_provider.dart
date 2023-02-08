import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../model/store.dart';

class StoreProvider with ChangeNotifier {
  List<Store> _stores;

  List<Store> get stores {
    return [..._stores];
  }

  StoreProvider();

  Store fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Store(
        name: data['name'], location: data['location'], sales: data['sales']);
  }

  Map<String, dynamic> toFirestore(Store store) {
    return {
      if (store.name != null) 'name': store.name,
      if (store.location != null) 'location': store.location,
      if (store.sales != null) 'sales': store.sales
    };
  }
}
