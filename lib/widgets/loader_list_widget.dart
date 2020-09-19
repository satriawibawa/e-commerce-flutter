import 'package:flutter/cupertino.dart';

class LoaderList extends StatelessWidget {
  final object;
  final Function callback;

  LoaderList({@required this.object, @required this.callback});

  @override
  Widget build(BuildContext context) {
    if (object == null)
      return Center(
        child: Text("Tidak ada barang yang ditemukan",
            textAlign: TextAlign.center),
      );

    if (object.length == 0)
      return Stack(children: <Widget>[
        Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: Text("Tidak ada bsarang yang ditemukan",
              textAlign: TextAlign.center),
        ),
      ]);
    return callback();
  }
}