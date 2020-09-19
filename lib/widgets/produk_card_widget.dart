import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:megagalery/bloc/produk_bloc.dart';
import 'package:megagalery/model/produk_list_item_model.dart';
import 'package:megagalery/page/produk_page.dart';
import 'package:megagalery/widgets/tambah_keranjang_widget.dart';
import 'package:provider/provider.dart';

class ProdukCard extends StatelessWidget {
  final ProdukListItemModel item;

  ProdukCard({@required this.item});

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<ProdukBloc>(context);
    final price = new NumberFormat("#,##0", "pt_BR");
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9.0),
        boxShadow: [
          BoxShadow(
              color: Colors.grey[300], offset: Offset(0, 3), blurRadius: 3.0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () {
                bloc.changeId(item.key);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProdukPage(
                          id: item.key,
                        )));
              },
              child: Center(
                child: Container(
                  child: Image.network((item.picture != null) ? item.picture: "http://bangkatengahkab.go.id/asset/foto_berita/no-image.jpg",
                  )
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: 16.0,
                  ),
                  child: Text(
                    item.nama,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Text(
                  "stok: " + item.quantity.toString(),
                  style: TextStyle(color: Colors.grey[500]),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      child: Text("Rp.${price.format(item.harga)}",
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis,),
                      ),
                    Flexible(
                      child: TambahKeKeranjang(
                          item: item
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}