import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:megagalery/bloc/home_bloc.dart';
import 'package:megagalery/bloc/keranjang_bloc.dart';
import 'package:megagalery/bloc/produk_bloc.dart';
import 'package:megagalery/bloc/theme_bloc.dart';
import 'package:megagalery/bloc/user_bloc.dart';
import 'package:megagalery/page/home_page.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeBloc>.value(value: HomeBloc()),
        ChangeNotifierProvider<KeranjangBloc>.value(value: KeranjangBloc()),
        ChangeNotifierProvider<UserBloc>.value(value: UserBloc()),
        ChangeNotifierProvider<ThemeBloc>.value(value: ThemeBloc()),
        ChangeNotifierProvider<ProdukBloc>.value(value: ProdukBloc()),
      ],
      child: MaterialApp(
        title: 'Mega Galery',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.cyan),
        home: HomePage(),
      ));
  }
}
