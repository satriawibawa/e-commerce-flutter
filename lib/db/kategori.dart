import 'package:firebase_database/firebase_database.dart';
import 'package:megagalery/model/kategori_list_item_model.dart';

class KategoriDB {

  void getAll(callback) async {
    FirebaseDatabase.instance.reference().child("kategori").once().then((DataSnapshot dataSnapshot) {
      List list = [];
      dataSnapshot.value.forEach((key, value){
        list.add({"key": key, ...value});
      });
      callback(list.toList().map((course) => KategoriListItemModel.fromJson(course)).toList());
    });
  }
}