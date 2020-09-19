import 'package:firebase_database/firebase_database.dart';
import 'package:megagalery/model/authenticate_user_model.dart';
import 'package:megagalery/model/buat_user_model.dart';
import 'package:megagalery/model/user_model.dart';

class AccountDB {
  Future<UserModel> authenticate(AuthenticateModel model) async {
    List list = [];
    await FirebaseDatabase.instance.reference().child("user").orderByChild("email").equalTo(model.email).once().then((DataSnapshot dataSnapshot){
      if (dataSnapshot.value.values.toList()[0]["password"] == model.password){
        dataSnapshot.value.forEach((f, i){
          list.add({"id": f, ...i});
        });
      }else{
        return null;
      }
    });
    return UserModel.fromJson(list.toList()[0]);
  }

  Future<UserModel> create(BuatUserModel model) async {
    FirebaseDatabase.instance.reference().child("user").push().set({
      "nama": ""+model.name,
      "email": ""+model.email,
      "password": ""+model.password,
      "no_telp": model.noTelp,
      "alamat": ""+model.alamat
    }).then((_){
      print('Buat Akun Sukses');
    });
    return UserModel.fromJson(model.toJson());
  }
}