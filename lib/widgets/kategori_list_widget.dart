import 'package:flutter/widgets.dart';
import 'package:megagalery/model/kategori_list_item_model.dart';
import 'package:megagalery/widgets/kategori_card_widget.dart';
import 'package:megagalery/widgets/loader_list_widget.dart';

class KategoriList extends StatelessWidget {
  final List<KategoriListItemModel> kategori;

  const KategoriList({@required this.kategori});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: LoaderList(
        object: kategori,
        callback: list,
      ),
    );
  }

  Widget list() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: kategori.length,
      itemBuilder: (context, index) {
        KategoriListItemModel item = kategori[index];
        return Padding(
          padding: EdgeInsets.all(10),
          child: KategoriCard(
            item: item,
          ),
        );
      },
    );
  }
}