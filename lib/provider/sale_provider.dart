import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/model/sale.dart';

class SaleProvider extends ChangeNotifier {
  List<Sale> _sales;

  List<Sale> get sales {
    return [..._sales];
  }

  List<Sale> getSalesByStoreId(String store_id) {
    return _sales.where((element) => element.store_id == store_id);
  }

  SaleProvider();
}
