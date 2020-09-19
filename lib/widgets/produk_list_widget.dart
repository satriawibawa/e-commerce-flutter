import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megagalery/model/produk_list_item_model.dart';
import 'package:megagalery/widgets/loader_list_widget.dart';
import 'package:megagalery/widgets/produk_card_widget.dart';

class ProdukList extends StatelessWidget {
  final List<ProdukListItemModel> produk;

  const ProdukList({@required this.produk});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: ,
      child: LoaderList(
        object: produk,
        callback: list,
      ),
    );
  }

  Widget list() {
    return GridView.builder(
      // scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      primary: true,
      physics: new NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 17,
        mainAxisSpacing: 17,
      ),
      itemCount: produk.length,
      itemBuilder: (context, index) {
        ProdukListItemModel item = produk[index];

        return Padding(
          padding: EdgeInsets.all(5),
          child: ProdukCard(
            item: item,
          ),
        );
      },
    );
  }
}