import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:megagalery/bloc/keranjang_bloc.dart';
import 'package:megagalery/model/keranjang_item_model.dart';
import 'package:provider/provider.dart';

class KeranjangItem extends StatelessWidget {
  final KeranjangItemModel item;

  const KeranjangItem({@required this.item});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<KeranjangBloc>(context);
    final price = new NumberFormat("#,##0.00", "pt_BR");

    return GestureDetector(
      child: Card(
          child: Row(
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.all(10),
                child: Image.network(
                  item.picture,
                  //fit: BoxFit.fitWidth,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: 0.0,
                      ),
                      child: Text(item.nama,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Text(
                      "R\p. ${price.format(item.harga)}",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "R\p. ${price.format(item.harga * item.i)}",
                      // "R\p. ${price.format(item.harga)}",
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 2, bottom: 5),
                      height: 39,
                      width: 190,
                      decoration: BoxDecoration(
                          // color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12)
                            ),
                            child: FlatButton(
                              child: Text("-"),
                              onPressed: (){
                                bloc.decrease(item);
                                // bloc.barangUpdate(item);
                                }
                            ),
                          ),
                          Container(
                            width: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12)
                            ),
                            child: Text(item.i.toString()),
                          ),
                          Container(
                            width: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12)
                            ),
                            child: FlatButton(
                              child: Text("+"),
                              onPressed: (){
                                bloc.increase(item);
                                // bloc.barangUpdate(item);
                              }
                            ),
                          ),
                          Container(
                            width: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12)
                            ),
                            child: IconButton(
                              alignment: Alignment.centerRight,
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                bloc.remove(item);
                              },
                            )
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              
            ],
          )),
    );
  }
}