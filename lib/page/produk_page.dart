import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:megagalery/bloc/produk_bloc.dart';
import 'package:megagalery/model/produk_detail_model.dart';
import 'package:megagalery/model/produk_list_item_model.dart';
import 'package:megagalery/widgets/loader_item_widget.dart';
import 'package:megagalery/widgets/tambah_keranjang_widget.dart';
import 'package:provider/provider.dart';

class ProdukPage extends StatelessWidget {
  final String id;

  ProdukPage({@required this.id});

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<ProdukBloc>(context);
    return Scaffold(
      body: LoaderItem(
        object: bloc.produkDetailModel,
        callback: content,
      ),
    );
  }

  Widget content(ProdukDetailModel product) {

    ProdukListItemModel productListModel = new ProdukListItemModel(
        key: product.key,
        nama: product.nama,
        kategori: product.kategori,
        harga: product.harga,
        picture: product.picture,
        quantity: product.quantity,
        berat: product.berat,
        description: product.description
    );
    final price = new NumberFormat("#,##0", "pt_BR");
    return Scaffold(
      appBar: AppBar(
        title: Text(productListModel.nama),
      ),
      body: Container(
        decoration: BoxDecoration(
            border:
            Border(top: BorderSide(color: Colors.grey[300], width: 1.0))),
        child: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 280.0,
                  padding: EdgeInsets.only(top: 10.0),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 200.0,
                        child: PageView(
                          children: <Widget>[
                            Image.network((productListModel.picture != null) ? productListModel.picture: "https://icoconvert.com/images/noimage2.png",
                              // height: 150.0
                            //   height: double.infinity,
                            // width: double.infinity,
                            alignment: Alignment.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[],
                      ),
                    ],
                  ),
                ),
                Container(
                    height: 270.0,
                    alignment: Alignment(1.0, 1.0),
                    child: Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: Column(
                        verticalDirection: VerticalDirection.down,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                      ),
                    ))
              ],
            ),
            Divider(
              color: Colors.grey[300],
              height: 1.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    productListModel.nama,
                    style:
                    TextStyle(fontWeight: FontWeight.w500, fontSize: 19.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(productListModel.description),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
          margin: EdgeInsets.only(bottom: 0.0),
          height: 60.0,
          decoration: BoxDecoration(
              color: Colors.white,
              border:
              Border(top: BorderSide(color: Colors.grey[300], width: 1.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 60.0,
                      child: Text(
                        "Harga",
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ),
                    Text("Rp.${price.format(productListModel.harga)}",
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Container(
                child: TambahKeKeranjang(
                    item: productListModel
                ),
              ),
            ],
          )),
    );
  }
}