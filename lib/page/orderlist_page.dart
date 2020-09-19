import 'dart:core';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:megagalery/bloc/user_bloc.dart';
import 'package:provider/provider.dart';

class OrderListPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
      ),
      body: Card(
        margin: EdgeInsets.symmetric(vertical: 4.0,horizontal: 8.0),
        child: Padding(padding: EdgeInsets.all(8.0),
          child: StreamBuilder<Event>(
            stream: FirebaseDatabase.instance.reference().child("orders").onValue,
            builder: (context,AsyncSnapshot<Event> snapshot){
              if(!snapshot.hasData && !snapshot.hasError){
              return Center(child: CircularProgressIndicator());
              }else {
                Map<dynamic, dynamic> values = snapshot.data.snapshot.value;
                List info = [], dataList = [], datapesan =[];
                if(values != null){
                values.forEach((key, value){
                  sleep(const Duration(seconds:3));
                  if(user.user.id == value["user"]["id"] || value.length > 1){
                   Map<dynamic, dynamic> list = value["user"]["info"];
                   list.forEach((key, value){
                        info.add(value);
                        dataList.add(key);
                   });
                  }else{
                    return Center(
                      child: Text("Order List Kosong",
                          textAlign: TextAlign.center),
                    );
                  }
                });
                for(var i = 0; i < dataList.length; i++){
                  List dataListPesan = [];
                      for(var j = 0; j < info[i]['pesan'].length; j++){
                          if(info[i] == 1){
                            dataListPesan.add(info[i]['pesan'][0]['nama'] + " x " +info[i]['pesan'][0]['i'].toString());
                          }else{
                            dataListPesan.add(info[i]['pesan'][j]['nama'] + " x " + info[i]['pesan'][j]['i'].toString());
                          }
                      }
                      datapesan.add(dataListPesan.map((f) => f).toList());
                  }
                return ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Kode Pemesanan: ${dataList[index]}",style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 4.0,),
                          Text("Deskripsi"),
                          Text("Tanggal: ${info[index]['tgl_pesan']}"),
                          Text("Barang: ${datapesan[index]}"),
                          Text("Alamat: ${info[index]['alamat_pengiriman']}\n"),
                          Text("Total: Rp${info[index]['total_pesan'].toString()} sudah termasuk ongkir\n"),
                          SizedBox(height: 4.0,),
                          Text("Status Pemesanan:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              _buildCircle("1", "Proses", info[index]['status'], 0),
                              Container(
                                height: 1.0,
                                width: 40.0,
                                color: Colors.grey[500],
                              ),
                              _buildCircle("2", "Pengiriman", info[index]['status'], 1),
                              Container(
                                height: 1.0,
                                width: 40.0,
                                color: Colors.grey[500],
                              ),
                              _buildCircle("3", "Diterima", info[index]['status'], 2),
                            ],
                          ),
                          Divider(),
                        ],
                      );
                  },
                );
              }else{
                return Center(
                  child: Text("Order List Kosong",
                      textAlign: TextAlign.center),
                );
              }
            }
            }),
        )
    ));
  }

  Widget _buildCircle(String title, String subtitle, int status,int thisStatus){
    Color backColor;
    Widget child;

    if(status < thisStatus){
      backColor = Colors.grey[500];
      child = Text(title, style: TextStyle(color: Colors.white),);
    }
    else if(status == thisStatus){
      backColor = Colors.grey[500];
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(title,style: TextStyle(color: Colors.white),),
          // CircularProgressIndicator(
          //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          // )
        ],
      );
    }else{
      backColor  = Colors.green;
      child = Icon(Icons.check,color: Colors.white,);
    }
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }
}