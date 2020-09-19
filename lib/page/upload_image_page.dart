import 'dart:async';
import 'dart:core' as prefix0;
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:megagalery/bloc/user_bloc.dart';
import 'package:megagalery/main.dart';
import 'package:megagalery/model/keranjang_item_model.dart';
import 'package:megagalery/page/home_page.dart';
import 'package:megagalery/page/login_page.dart';
import 'package:megagalery/page/orderlist_page.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:intl/intl.dart';

class UploadImage extends StatefulWidget {
  final String provinsi, kabupaten, jeniskurir, alamttujuan;
  final int totalHarga, kodePengirman;
  final List<KeranjangItemModel> item;

  UploadImage(
      {Key key,
      this.totalHarga,
      this.item,
      this.provinsi,
      this.kabupaten,
      this.jeniskurir,
      this.kodePengirman,
      this.alamttujuan,
      this.users})
      : super(key: key);

  File _image;
  String _uploadedFileURL, _imagelink = "";
  int _loading;
  var users;
  List itempesanan = [];
  @override
  UploadImageState createState() => UploadImageState();
}

class UploadImageState extends State<UploadImage>{
  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 85)
        .then((image) {
      setState(() {
        widget._image = image;
      });
    });
  }

  Future openCamera() async {
    await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 85)
        .then((image) {
      setState(() {
        widget._image = image;
      });
    });
  }
  void clearSelection() {
    setState(() {
      widget._image = null;
      widget._uploadedFileURL = null;
    });
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserBloc>(context);
    final _database = FirebaseDatabase.instance;
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    DateTime now = DateTime.now();
    setState(() {
      widget.users = user.user;
    });
    Future uploadFile() async {
      FormData formdata = new FormData();
      formdata.add("image",
          new UploadFileInfo(widget._image, basename(widget._image.path)));
      Response response = await Dio().post(
          "https://api.imgbb.com/1/upload?key=91226d4fc19546ab6c3998d9d70f9858",
          data: formdata,
          options: Options(
            method: 'POST',
          ));

      if (response.statusCode == 200) {
        widget._imagelink = response.data["data"]["url"];
        setState(() {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MyApp()),
              (Route<dynamic> route) => false);
          return widget._loading = 200;
        });
      } else {
        final snackbar = SnackBar(
          content: Text("Upload Gambar Error."),
        );
        _scaffoldKey.currentState.showSnackBar(snackbar);
        return widget._loading = 400;
      }
    }

    var orderRef = _database.reference().child("orders");
    String newkey = orderRef.push().key;
    if (widget._loading == 200) {
      orderRef.once().then((DataSnapshot dataSnapshot) {
        if (dataSnapshot.value != null) {
          Map<dynamic, dynamic> map = dataSnapshot.value;
          var result = dataSnapshot.value.values as Iterable;
           for(var item in result) {
            if (item["user"]["id"] == widget.users.id) {
              map.forEach((key, value) {
              var neworderRef = _database.reference().child("orders");
              neworderRef.child(key).child("user").child("info").push().set({
                "pesan": widget.item.toList().map((f) => f.toJson()).toList(),
                "tgl_pesan": DateFormat("dd-MM-yyyy").format(now),
                "foto": "" + widget._imagelink,
                "alamat_pengiriman": widget.provinsi.toString() +
                    ", " +
                    widget.kabupaten.toString() +
                    ", " +
                    widget.jeniskurir +
                    ", " +
                    widget.kodePengirman.toString() +
                    ", " + widget.alamttujuan.toString(),
                "status": 1,
                "total_pesan": widget.totalHarga
              }).then((_) {
                print('Buat Akun Sukses 1');
              });
              });
            break;
            }else{
              orderRef.push().set({
                "user": {
                  "id": widget.users.id,
                  "nama": widget.users.nama,
                  "email": widget.users.email,
                  "info": {
                    newkey: {
                      "pesan": widget.item.toList().map((f) => f.toJson()).toList(),
                      "tgl_pesan": DateFormat("dd-MM-yyyy").format(now),
                      "foto": "" + widget._imagelink,
                      "alamat_pengiriman": widget.provinsi.toString() +
                          ", " +
                          widget.kabupaten.toString() +
                          ", " +
                          widget.jeniskurir +
                          ", " +
                          widget.kodePengirman.toString() +
                          ", " + 
                          widget.alamttujuan.toString(),
                      "status": 1,
                      "total_pesan": widget.totalHarga
                    }
                  }
                }
              }).then((_) {
                print('Buat Akun Sukses 3');
              });
            break;
            }
          }
        }
      });
    }
    String formattedDate = DateFormat('EEEEE').format(now);
    if(formattedDate == "Saturday" || formattedDate == "Sunday"){
    return Scaffold(
        appBar: AppBar(
          title: Text("Pembayaran di tidak dapat dilakukan"),),
        body: Column(
          children: <Widget>[
          AlertDialog(
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Silahkan coba kembali lagi pada senin - jum`at.'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      Future<String> updateBarang(String id, int count) async {
                      FirebaseDatabase.instance.reference().child("items").child(id).update({
                              'quantity': count
                              });
                            return 'success!';
                        }
                      for(int i = 0; i < widget.item.toList().map((f) => f.toJson()).toList().length; i++){
                        updateBarang(widget.item.toList().map((f) => f.toJson()).toList()[i]['key'], widget.item.toList().map((f) => f.toJson()).toList()[i]['quantity'] + widget.item.toList().map((f) => f.toJson()).toList()[i]['i'] - widget.item.toList().map((f) => f.toJson()).toList()[i]['i']);
                      }
                      Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MyApp()),
                      (Route<dynamic> route) => false); 
                    },
                  ),
                ],
              )
        ],)
    );
    }else{
    return Scaffold(
      appBar: AppBar(
        title: Text("Konfimasi Pembayaran"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Selesaikan Pembayaran Sebelum",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
                CountdownFormatted(
                duration: Duration(hours: 6),
                onFinish: (){
                  showDialog<Null>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Waktu Habis'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text('Silahkan coba kembali lagi.'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        new FlatButton(
                          child: Text('OK'),
                          onPressed: () {
                            Future<String> updateBarang(String id, int count) async {
                            FirebaseDatabase.instance.reference().child("items").child(id).update({
                                    'quantity': count
                                    });
                                  return 'success!';
                              }
                            for(int i = 0; i < widget.item.toList().map((f) => f.toJson()).toList().length; i++){
                              updateBarang(widget.item.toList().map((f) => f.toJson()).toList()[i]['key'], widget.item.toList().map((f) => f.toJson()).toList()[i]['quantity'] + widget.item.toList().map((f) => f.toJson()).toList()[i]['i'] - widget.item.toList().map((f) => f.toJson()).toList()[i]['i']);
                            }
                            Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => MyApp()),
                            (Route<dynamic> route) => false); 
                          },
                        ),
                      ],
                    );
                  },
                );
                },
                builder: (BuildContext ctx, String remaining) {
                  return Text(remaining, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center);
              },
            ),
            SizedBox(
              height: 10,
            ),
            Text("Total", textAlign: TextAlign.center),
            SizedBox(
              height: 10,
            ),
            Text('Rp${widget.totalHarga.toString()}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            Center(
                child: Text(
                    "Untuk melakukan pembayaran, silahkan transfer sesuai dengan nominal diatas.",
                    textAlign: TextAlign.center)),
            SizedBox(
              height: 10,
            ),
            Text("No Rekening", textAlign: TextAlign.center),
            Text("0038-01-015189-53-7 (BRI)",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            Text("An. Ika Awan yuliana erfianti",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            widget._image != null
                ? Image.asset(
                    widget._image.path,
                    height: 150,
                  )
                : Container(height: 150),
            widget._image == null
                ? Container(
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                        Container(
                            margin: const EdgeInsets.only(top: 0.0),
                            child: FractionallySizedBox(
                                widthFactor: 0.6,
                                child: RaisedButton(
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Icon(Icons.insert_photo),
                                      Text("Masukan File Foto"),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                  onPressed: chooseFile,
                                  color: Colors.white,
                                ))),
                        const SizedBox(height: 30.0),
                        Text("Atau"),
                        const SizedBox(height: 30.0),
                        Container(
                            margin: const EdgeInsets.only(top: 0.0),
                            child: FractionallySizedBox(
                                widthFactor: 0.6,
                                child: RaisedButton(
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Icon(Icons.camera_alt),
                                      Text("Ambil Gambar"),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                  onPressed: openCamera,
                                  color: Colors.white,
                                )))
                      ]))
                : Container(),
            widget._image != null && widget._loading != 400
                ? Container(
                    margin: const EdgeInsets.only(top: 0.0),
                    child: FractionallySizedBox(
                        widthFactor: 0.6,
                        child: RaisedButton(
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 5,
                              ),
                              Icon(Icons.cloud_upload),
                              Text("Upload File Foto"),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                          onPressed: () {
                            uploadFile();
                          },
                          color: Colors.cyan,
                        )))
                : Container(),
            widget._image != null && widget._loading != 400
                ? Container(
                    margin: const EdgeInsets.only(top: 0.0),
                    child: FractionallySizedBox(
                        widthFactor: 0.6,
                        child: RaisedButton(
                          child: Text('Clear Selection'),
                          onPressed: (clearSelection),
                        )))
                : Container(),
            ],
        ),
      ),
    );
    }
  }
}