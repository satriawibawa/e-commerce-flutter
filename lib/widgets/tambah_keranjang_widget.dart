import 'package:flutter/material.dart';
import 'package:megagalery/bloc/keranjang_bloc.dart';
import 'package:megagalery/bloc/user_bloc.dart';
import 'package:megagalery/model/keranjang_item_model.dart';
import 'package:megagalery/model/produk_list_item_model.dart';
import 'package:megagalery/page/login_page.dart';
import 'package:provider/provider.dart';

class TambahKeKeranjang extends StatelessWidget {
  final ProdukListItemModel item;
  final int kategoriId;
  const TambahKeKeranjang({@required this.item, this.kategoriId});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<KeranjangBloc>(context);
    final user = Provider.of<UserBloc>(context);

    var keranjangItem = new KeranjangItemModel(
        key: item.key,
        harga: item.harga,
        picture: item.picture,
        i: 1,
        quantity: item.quantity,
        berat: item.berat,
        nama: item.nama);

    if (user.user != null) {
      if (keranjangItem.quantity != 0){
        if (!bloc.itemInCart(keranjangItem)) {
          return Container(
            width: 80,
            height: 40,
            child: FlatButton(
              color: Colors.cyan,
              child: Icon(Icons.add_shopping_cart),
              textColor: Colors.white,
              onPressed: () {
                bloc.barangUpdate(keranjangItem);
                bloc.add(keranjangItem);
                final snackbar = SnackBar(
                  content: Text("${item.nama} ditambahkan"),
                );
                Scaffold.of(context).showSnackBar(snackbar);
              },
            ),
          );
        } else {
          return Container(
            width: 80,
            height: 40,
            child: FlatButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Icon(Icons.remove_shopping_cart),
              onPressed: () {
                bloc.barangUpdate(keranjangItem);
                bloc.remove(keranjangItem);
                final snackbar = SnackBar(
                  content: Text("${item.nama} dihapus"),
                );
                Scaffold.of(context).showSnackBar(snackbar);
              },
            ),
          );
        }
      }else{
        return Container(
            width: 145,
            height: 40,
            child: FlatButton(
              color: Colors.black12,
              textColor: Colors.white,
              child: Icon(Icons.block),
                    // Text("Habis"),
              onPressed: () {
                final snackbar = SnackBar(
                  content: Text("${item.nama} Stok Habis"),
                );
                Scaffold.of(context).showSnackBar(snackbar);
              },
            ),
          );
      }
    } else {
      return Container(
          child: FlatButton(
            color: Colors.cyan,
            textColor: Colors.white,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text(
              "Login",
            ),
          ));
    }
  }
}