import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_complete_guide/model/sale.dart';

class Store {
  String name;

  GeoPoint location;

  List<Sale> sales;

  Store({this.name, this.location, this.sales});
}
