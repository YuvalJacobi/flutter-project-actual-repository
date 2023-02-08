import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/model/sale.dart';

class SaleProvider with ChangeNotifier {
  List<Sale> _sales;

  List<Sale> get sales {
    return [..._sales];
  }

  SaleProvider();
}
