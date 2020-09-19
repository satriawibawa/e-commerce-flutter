import 'package:firebase_database/firebase_database.dart';
import 'package:megagalery/model/produk_detail_model.dart';
import 'package:megagalery/model/produk_list_item_model.dart';

class ProdukDB {

  void getAll(callback) async {
    FirebaseDatabase.instance.reference().child("items").once().then((dataSnapshot) {
      List list = [];
      if (dataSnapshot.value != null && dataSnapshot.value.length > 0) {
        dataSnapshot.value.forEach((key, value) {
          list.add({"key": key, ...value});
        });
      } else {
        return null;
      }
      callback(list.toList().map((course) => ProdukListItemModel.fromJson(course)).toList());
    });
  }

  void getByCategory(category, callback) async {
    FirebaseDatabase.instance.reference().child("items").orderByChild("kategori").equalTo(category).once().then((DataSnapshot dataSnapshot) {
      List list = [];
      if (dataSnapshot.value != null && dataSnapshot.value.length > 0) {
        dataSnapshot.value.forEach((key, value) {
          list.add({"key": key, ...value});
        });
      } else {
        return null;
      }
      callback(list.toList().map((course) => ProdukListItemModel.fromJson(course)).toList());
    });
  }

  void getById(id, callback) async {
    FirebaseDatabase.instance.reference().child("items").orderByKey().equalTo(id).once().then((DataSnapshot dataSnapshot) {
      List list = [];
      if (dataSnapshot.value != null && dataSnapshot.value.length > 0) {
        dataSnapshot.value.forEach((key, value) {
          list.add({"key": key, ...value});
        });
      } else {
        return null;
      }
      callback(ProdukDetailModel.fromJson(list.toList()[0]));
    });
  }
}
