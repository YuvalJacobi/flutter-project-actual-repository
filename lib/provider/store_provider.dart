import '../model/store.dart';

class StoreProvider {
  List<Store> _stores;

  List<Store> get stores {
    return [..._stores];
  }

  StoreProvider();
}
