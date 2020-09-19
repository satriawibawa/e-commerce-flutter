import 'package:flutter/material.dart';
import 'package:megagalery/bloc/home_bloc.dart';
import 'package:megagalery/bloc/theme_bloc.dart';
import 'package:megagalery/model/kategori_list_item_model.dart';
import 'package:provider/provider.dart';

class KategoriCard extends StatelessWidget {

  final KategoriListItemModel item;

  const KategoriCard({@required this.item});

  @override
  Widget build(BuildContext context) {
    final HomeBloc bloc = Provider.of<HomeBloc>(context);
    final ThemeBloc tema = Provider.of<ThemeBloc>(context);

    return Container(
        width: 130,
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        decoration: BoxDecoration(
            border: Border.all(width: 2),
            color: item.id == bloc.selectedCategory ?
            tema.hidup
                : Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(70))
        ),
        child:  Container(
          height: 50.0,
          child: GestureDetector(
            onTap: () {bloc.changeCategory(item.id);},
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      item.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}