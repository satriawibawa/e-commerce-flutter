import 'package:flutter/widgets.dart';
import 'package:megagalery/db/produk.dart';
import 'package:megagalery/model/produk_detail_model.dart';

class ProdukBloc extends ChangeNotifier {
  final productdb = new ProdukDB();

  ProdukDetailModel produkDetailModel;
  String selectedProduk = "none";

  getProductById() {
    this.produkDetailModel = null;
    productdb.getById(selectedProduk, (data) {
      this.produkDetailModel = data;
      notifyListeners();
    });
  }

  changeId(tag) {
    selectedProduk = tag;
    getProductById();
    notifyListeners();
  }
}
