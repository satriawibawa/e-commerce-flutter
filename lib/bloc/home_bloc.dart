import 'package:flutter/widgets.dart';
import 'package:megagalery/db/kategori.dart';
import 'package:megagalery/db/produk.dart';
import 'package:megagalery/model/kategori_list_item_model.dart';
import 'package:megagalery/model/produk_list_item_model.dart';

class HomeBloc extends ChangeNotifier {
  final kategoriDB = new KategoriDB();
  final produkDB = new ProdukDB();

  List<ProdukListItemModel> produk;
  List<KategoriListItemModel> kategori;
  String selectedCategory = "todos";
  String selectedProduct = "none";

  HomeBloc() {
    getCategories();
    getProducts();
  }

  getCategories() async {
    kategoriDB.getAll((data) {
      this.kategori = data;
      notifyListeners();
    });
  }

  getProducts() async {
    this.produk = null;
    produkDB.getAll((data) {
      this.produk = data;
      notifyListeners();
    });
  }

  getProductsByCategory() {
    produkDB.getByCategory(selectedCategory, (data) {
      this.produk = data;
      notifyListeners();
    });
  }

  changeCategory(tag) {
    this.produk = null;
    selectedCategory = tag;
    produk = null;
    getProductsByCategory();
    notifyListeners();
  }
}