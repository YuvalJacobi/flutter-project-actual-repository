import 'package:flutter/cupertino.dart';

class SaleProvider with ChangeNotifier {
  List<SaleProvider> _sale_providers;

  List<SaleProvider> get sale_provders {
    return [..._sale_providers];
  }

  SaleProvider();
}
