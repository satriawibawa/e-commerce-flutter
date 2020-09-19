import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:megagalery/model/keranjang_item_model.dart';

class KeranjangBloc extends ChangeNotifier {
  var keranjang = new List<KeranjangItemModel>();
  final _db = FirebaseDatabase.instance;
  int total = 0;
  int count = 0;

  get() {
    return keranjang;
  }

  barangUpdate(KeranjangItemModel item) {
    keranjang.forEach((x) {
      if (item.key == x.key) {
        _db.reference().child("items").child(x.key).update({
          'quantity': count + 1
          });
      }
    });

  }

  add(KeranjangItemModel item) {
    keranjang.add(item);
    _db.reference().child("items").child(item.key).update({
      'quantity': item.quantity - 1
      });
    calculateTotal();
  }

  remove(KeranjangItemModel item) {
    keranjang.removeWhere((x) => x.key == item.key);
    _db.reference().child("items").child(item.key).update({
      'quantity': item.quantity
      });
    calculateTotal();
  }

  itemInCart(KeranjangItemModel item) {
    var result = false;

    keranjang.forEach((x) {
      if (item.key == x.key) result = true;
    });

    return result;
  }

  increase(KeranjangItemModel item) {
    if (item.i < item.quantity) {
      item.i++;
      count = item.quantity - item.i;
       _db.reference().child("items").child(item.key).update({
      'quantity': count
      });
      calculateTotal();
    }

  }

  decrease(KeranjangItemModel item) {
    if (item.i > 0) {
      item.i--;
      count = item.quantity;
      _db.reference().child("items").child(item.key).update({
      'quantity': count
      });
      calculateTotal();
    }
    if(item.i == 0){
      keranjang.removeWhere((x) => x.key == item.key);
    }
  }

  calculateTotal() {
    total = 0;
    keranjang.forEach((x) {
      total += (x.harga * x.i);
    });
    notifyListeners();
  }
}
