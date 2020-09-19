import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:megagalery/db/user.dart';
import 'package:megagalery/model/authenticate_user_model.dart';
import 'package:megagalery/model/buat_user_model.dart';
import 'package:megagalery/model/user_model.dart';
import 'package:megagalery/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends ChangeNotifier {
  var user = new UserModel();

  UserBloc() {
    user = null;
    loadUser();
  }

  Future<UserModel> authenticate(AuthenticateModel model) async {
    try {
      var pref = await SharedPreferences.getInstance();
      var repository = new AccountDB();

      var res = await repository.authenticate(model);

      user = res;
      await pref.setString("user", jsonEncode(res));

      return res;
    } catch (ex) {
      user = null;
      return null;
    }
  }

  Future<UserModel> create(BuatUserModel model) async {
    try {
      var repository = new AccountDB();

      var res = await repository.create(model);

      return res;
    } catch (ex) {
      user = null;
      return null;
    }
  }

  logout() async {
    var pref = await SharedPreferences.getInstance();
    await pref.setString("user", null);
    user = null;
    notifyListeners();
  }

  Future loadUser() async {
    var pref = await SharedPreferences.getInstance();
    var userData = pref.getString("user");
    if (userData != null) {
      var res = UserModel.fromJson(jsonDecode(userData));
      Settings.user = res;
      user = res;
    }
  }
}
