import 'package:flutter/material.dart';
import 'package:megagalery/bloc/user_bloc.dart';
import 'package:megagalery/model/authenticate_user_model.dart';
import 'package:megagalery/page/signup_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var email = "";
  var password = "";

  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: formListView(context),
        ),
      ),
    );
  }

  Widget formListView(BuildContext context) {
    return ListView(
      children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(labelText: "Email"),
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
          validator: (value) {
            if (value.isEmpty)
              return "Pengguna tidak valid";
            else
              return null;
          },
          onSaved: (value) {
            email = value;
          },
        ),
        TextFormField(
          obscureText: true,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(labelText: "Kata sandi"),
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
          validator: (value) {
            if (value.isEmpty)
              return "Kata Sandi Tidak Valid";
            else
              return null;
          },
          onSaved: (value) {
            password = value;
          },
        ),
        SizedBox(
          height: 20,
        ),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text(
            "Masuk",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              authenticate(context);
            }
          },
        ),
        FlatButton(
          child: Text(
            "Pendaftaran?",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignupPage())),
        ),
//        RaisedButton(
//          color: Theme.of(context).primaryColor,
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              Image.asset("assets/icons/logo_google.png", height: 36,),
//              Text(
//                "Login Google",
//                style: TextStyle(color: Colors.white),
//              )
//            ],
//          ),
//          onPressed: () => loginGoogle(),
//        ),
      ],
    );
  }

  authenticate(BuildContext context) async {
    var bloc = Provider.of<UserBloc>(context);

    var user = await bloc.authenticate(AuthenticateModel(
      email: email,
      password: password,
    ));
    if (user == null) {
      final snackbar = SnackBar(
        content: Text("Nama pengguna atau kata sandi tidak valid"),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
    } else {
      Navigator.pop(context);
      return;
    }
  }

//  Future<FirebaseUser> _handleSignIn() async {
//    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
//    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//
//    final AuthCredential credential = GoogleAuthProvider.getCredential(
//      accessToken: googleAuth.accessToken,
//      idToken: googleAuth.idToken,
//    );
//
//    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
//    print("signed in " + user.displayName);
//    return user;
//  }
//
//  loginGoogle() async{
//    await _handleSignIn()
//        .then((FirebaseUser user) => print(user))
//        .catchError((e) => print(e));
//  }
}