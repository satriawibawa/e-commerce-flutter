import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:megagalery/main.dart';
import 'package:megagalery/model/keranjang_item_model.dart';
import 'package:megagalery/page/upload_image_page.dart';

class Checkout extends StatefulWidget {
  final List<KeranjangItemModel> itemKeranjang;
  final int total, berat;
  Checkout({Key key, this.itemKeranjang, this.total, this.berat})
      : super(key: key);
  CheckoutState createState() => CheckoutState();
}

class CheckoutState extends State<Checkout> {
  final String provinsiurl = 'https://api.rajaongkir.com/starter/province';
  final String kota = 'https://api.rajaongkir.com/starter/city';
  final String cek = 'https://api.rajaongkir.com/starter/cost';
  final myController = TextEditingController();
  final _alamattujuan = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List _locationsprovinsiurl = List(),
      _locationskotaurl = List(),
      _hasildata = List();
  String _selectedProvinsi, _selectedKota, _kurir, _jeniskurir = "";
  int kodePos = 0;
  List<String> kurir = ['pos'];

  String idProvinsi;
  Future<String> getDataProvinsi() async {
    var res = await http.get(Uri.encodeFull(provinsiurl),
        headers: {'key': '7f3bf6dd15eca151f2b21dfc5ef115a2'});
    if (res.statusCode == 200) {
      setState(() {
        Map<String, dynamic> content = json.decode(res.body);
        content.forEach((key, value) {
          for (var i = 0; i < value['results'].length; i++) {
            _locationsprovinsiurl.add(value['results'][i]);
          }
        });
      });
    } else {
      throw Exception('Failed to load get');
    }
    return 'success!';
  }

  Future<String> getDataKota(String idkota) async {
    var res = await http.get(
        Uri.encodeFull(kota + '?province=' + idkota.toString()),
        headers: {'key': '7f3bf6dd15eca151f2b21dfc5ef115a2'});
    if (res.statusCode == 200) {
      try {
        setState(() {
          Map<String, dynamic> content = json.decode(res.body);
          content.forEach((key, value) {
            _locationskotaurl.clear();
            for (var i = 0; i < value['results'].length; i++) {
              _locationskotaurl.add(value['results'][i]);
            }
          });
        });
      } on Exception catch (_) {
        print('never reached');
      }
    } else {
      throw Exception('Failed to load get');
    }
    return 'success!';
  }

  Future<String> getKodePos(String cityid) async {
    var res = await http.get(Uri.encodeFull(kota + '?id=' + cityid.toString()),
        headers: {'key': '7f3bf6dd15eca151f2b21dfc5ef115a2'});
    setState(() {
      Map<String, dynamic> content = json.decode(res.body);
      kodePos = int.parse(content['rajaongkir']['results']['postal_code']);
    });
    return 'success!';
  }

  List _harga1 = List();
  Future<String> result(
      String destination, String weight, String courier) async {
    Map<String, dynamic> body = {
      "origin": "209",
      "destination": destination,
      "weight": weight,
      "courier": courier
    };
    var res = await http.post(Uri.encodeFull(cek),
        headers: {
          'key': '7f3bf6dd15eca151f2b21dfc5ef115a2',
          'content-type': 'application/x-www-form-urlencoded'
        },
        body: body);
    setState(() {
      Map<String, dynamic> content = json.decode(res.body);
      _jeniskurir = content['rajaongkir']['results'][0]['name'];
      _hasildata = content['rajaongkir']['results'][0]['costs'];
      _harga1.clear();
      for (var i = 0; i < _hasildata.length; i++) {
        _harga1.add(_hasildata[i]['cost'][0]);
      }
    });
    return 'success!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Checkout")),
      body: Container(
        child: Form(
          key: _formKey,
          child: listViewForm(context),
        ),
      ),
    );
  }

  Widget listViewForm(BuildContext context) {
    double _inputHeight = 50;
    myController.text = widget.berat.toString();
    if (widget.itemKeranjang.length != 0) {
      return ListView(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
            Text('Pengiriman'),
            Row(
              children: <Widget>[
                Text(
                  'Provinsi : ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton(
                  hint: Text('provinsi'),
                  value: _selectedProvinsi,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedProvinsi = newValue.toString();
                      getDataKota(newValue.toString());
                      _selectedKota = null;
                    });
                  },
                  items: _locationsprovinsiurl.map((item) {
                    return DropdownMenuItem(
                      child: Text(item['province']),
                      value: item['province_id'],
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Text(
                  'Kabupaten : ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton(
                  hint: Text('pilih kota'),
                  value: _selectedKota,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedKota = newValue.toString();
                      this.getKodePos(newValue.toString());
                    });
                  },
                  items: _locationskotaurl.map((item) {
                    return DropdownMenuItem(
                      child: Text(item['city_name']),
                      value: item['city_id'],
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Text(
                  'Pilih Kurir : ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton(
                  hint: Text('pilih Kurir'),
                  value: _kurir,
                  onChanged: (newValue) {
                    setState(() {
                      _kurir = newValue.toString();
                    });
                  },
                  items: kurir.map((item) {
                    return DropdownMenuItem(
                      child: Text(item),
                      value: item,
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Kode : ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(kodePos.toString()),
                Spacer(),
                Text(
                  'Berat gram : ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                
                Text(widget.berat.toString()),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
            Text('Alamat Lengkap : ',style: TextStyle(fontWeight: FontWeight.bold),),
            ]),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _alamattujuan,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              validator: (value) {
                if (value.isEmpty)
                  return "alamat harus di isi.";
                else
                  return null;
              },
              decoration: InputDecoration(
                  hintText: "Masukan alamat",
                  enabledBorder: UnderlineInputBorder(      
                      borderSide: BorderSide(color: Colors.cyan),   
                      ),  
              focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                   ),  
                  ),
              maxLines: null,
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    "Cek",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    result(_selectedKota, myController.text, _kurir);
                  },
                )),
          ])),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      Text('Kurir: ' + _jeniskurir.toString()),
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _hasildata.length,
                          itemBuilder: (context, index) {
                            int total1 = widget.total;
                            total1 = widget.total +
                                _hasildata[index]['cost'][0]['value'];
                            return Container(
                                child: Card(
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                  ListTile(
                                      subtitle: Column(children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Description : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          _hasildata[index]['description'],
                                          style: TextStyle(
                                              fontStyle: FontStyle.normal,
                                              fontSize: 15.0),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Harga Ongkir: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          _hasildata[index]['cost'][0]['value']
                                                  .toString() +
                                              " + Harga Barang " +
                                              widget.total.toString(),
                                          style: TextStyle(
                                              fontStyle: FontStyle.normal,
                                              fontSize: 15.0),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Harga Total: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          total1.toString(),
                                          style: TextStyle(
                                              fontStyle: FontStyle.normal,
                                              fontSize: 15.0),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Estimate Waktu : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          _hasildata[index]['cost'][0]['etd']
                                                  .toString() +
                                              " hari",
                                          style: TextStyle(
                                              fontStyle: FontStyle.normal,
                                              fontSize: 15.0),
                                        ),
                                      ],
                                    ),
                                  ])),
                                  SizedBox(
                                      width: double.infinity,
                                      child: RaisedButton(
                                        color: Theme.of(context).primaryColor,
                                        child: Text(
                                          "Lanjut",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          String kota = "";
                                          for (var i = 0;
                                              i < _locationskotaurl.length;
                                              i++) {
                                            if (_locationskotaurl[i]
                                                    ['city_id'] ==
                                                _selectedKota) {
                                              kota = _locationskotaurl[i]
                                                  ['city_name'];
                                            }
                                          }
                                          if (_formKey.currentState
                                              .validate()) {
                                            _formKey.currentState.save();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UploadImage(
                                                          item: widget
                                                              .itemKeranjang,
                                                          totalHarga: total1,
                                                          provinsi: _locationsprovinsiurl[
                                                              int.parse(
                                                                      _selectedProvinsi) -
                                                                  1]['province'],
                                                          kabupaten: kota,
                                                          jeniskurir:
                                                              _jeniskurir,
                                                          kodePengirman:
                                                              kodePos,
                                                          alamttujuan:
                                                              _alamattujuan
                                                                  .text,
                                                        )));
                                          }
                                        },
                                      )),
                                ])));
                          })
                    ],
                  ),
                )
              ],
            ),
          ),
        
      ]);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MyApp()),
              (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    this.getDataProvinsi();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }
}
