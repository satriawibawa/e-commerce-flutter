import 'package:flutter/material.dart';
import 'package:megagalery/bloc/user_bloc.dart';
import 'package:megagalery/model/buat_user_model.dart';
import 'package:megagalery/validasi/email.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var user = new BuatUserModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Pendaftaran")),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: listViewForm(context),
        ),
      ),
    );
  }

  Widget listViewForm(BuildContext context) {
    return ListView(
      children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(labelText: "Nama Lengkap"),
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
          validator: (value) {
            if (value.isEmpty)
              return "Nama Tidak Valid";
            else
              return null;
          },
          onSaved: (value) {
            user.name = value;
          },
        ),
        SizedBox(height: 10,),
        TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(labelText: "Email"),
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
          validator: (value) => CustomValidasiEmail.isEmail(value),
          onSaved: (value) {
            user.email = value;
          },
        ),
        TextFormField(
          obscureText: true,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(labelText: "Kata sandi"),
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
          validator: (value) {
            if (value.isEmpty)
              return "Kata sandi";
            else
              return null;
          },
          onSaved: (value) {
            user.password = value;
          },
        ),
        SizedBox(height: 20,),
        TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(labelText: "No. Telepon"),
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
          validator: (value) {
            if (value.isEmpty)
              return "No. Telepon tidak valid";
            else
              return null;
          },
          onSaved: (value) {
            user.noTelp = int.parse(value);
          },
        ),
        SizedBox(height: 20,),
        TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(labelText: "Alamat"),
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
          validator: (value) {
            if (value.isEmpty)
              return "Alamat tidak valid";
            else
              return null;
          },
          onSaved: (value) {
            user.alamat = value;
          },
        ),
        SizedBox(height: 20,),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text(
            "Daftar",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              create(context);
            }
          },
        ),
        FlatButton(
          child: Text(
            "Batalkan",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          onPressed: () =>  Navigator.pop(context),
        )
      ],
    );
  }

  create(BuildContext context) async{
    var bloc = Provider.of<UserBloc>(context);
    var res = await bloc.create(user);
    if (res == null) {
      final snackbar = SnackBar(
        content: Text("Tidak dapat mendaftarkan pengguna"),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
    } else {
      Navigator.pop(context);
      return;
    }
  }
}