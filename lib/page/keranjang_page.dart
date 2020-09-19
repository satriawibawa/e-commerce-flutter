import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:megagalery/bloc/keranjang_bloc.dart';
import 'package:megagalery/model/keranjang_item_model.dart';
import 'package:megagalery/page/Checkout.dart';
import 'package:megagalery/widgets/keranjang_item_widget.dart';
import 'package:megagalery/widgets/loader_list_widget.dart';
import 'package:provider/provider.dart';

class KeranjangPage extends StatefulWidget {
  @override
  _KeranjangPageState createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final price = new NumberFormat("#,##0.00", "pt_BR");

  var items = new List<KeranjangItemModel>();

  var bloc;

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<KeranjangBloc>(context);
    items = bloc.keranjang;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Keranjang"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: LoaderList(
                object: bloc.keranjang,
                callback: list,
              ),
            ),
            Container(
              color: Colors.black.withOpacity(0.05),
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "R\p. ${price.format(bloc.total)}",
                    style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w300),
                  ),
                  FlatButton(
                    child: Text(
                      "Checkout",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if(items.length != 0) {
                        var berat = 0;
                        for(var i = 0; i < items.length; i++){
                          berat += items[i].berat * items[i].i;
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Checkout(itemKeranjang: items,total: bloc.total, berat: berat)));
                      }else{
                        final snackbar = SnackBar(
                          content: Text("Keranjang Kosong."),
                        );
                        _scaffoldKey.currentState.showSnackBar(snackbar);
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget list() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Dismissible(
          child: KeranjangItem(item: items[index]),
          key: Key(items[index].key),
          onDismissed: (direction) {
            bloc.remove(items[index]);
          },
          background: Container(
            color: Colors.red.withOpacity(0.1),
          ),
        );
      },
    );
  }
}