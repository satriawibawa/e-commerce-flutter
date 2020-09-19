import 'package:flutter/material.dart';
import 'package:megagalery/bloc/home_bloc.dart';
import 'package:megagalery/bloc/keranjang_bloc.dart';
import 'package:megagalery/bloc/user_bloc.dart';
import 'package:megagalery/page/contact_page.dart';
import 'package:megagalery/page/keranjang_page.dart';
import 'package:megagalery/page/location_page.dart';
import 'package:megagalery/page/login_page.dart';
import 'package:megagalery/page/orderlist_page.dart';
import 'package:megagalery/widgets/kategori_list_widget.dart';
import 'package:megagalery/widgets/produk_list_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<HomeBloc>(context);
    final keranjangBloc = Provider.of<KeranjangBloc>(context);
    final user = Provider.of<UserBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: new Center(
              child: new Text("Mega Galery", textAlign: TextAlign.center)),
          elevation: 0.0,
          backgroundColor: Colors.cyan,
          actions: <Widget>[
            Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: InkResponse(
                    onTap: () {
                      (user.user != null)
                          ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => KeranjangPage()))
                          : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage()));
                    },
                    child: Tab(
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.shopping_cart),
                          Container(
                            alignment: Alignment.center,
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                BorderRadius.all(Radius.circular(5))),
                            child: Text(
                              keranjangBloc.keranjang.length.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
        body: 
        Stack(
        children: <Widget>[
        Container(
          decoration: new BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.cyan, Colors.cyan]
                  ),
                  borderRadius: new BorderRadius.only(
                            bottomLeft:  const  Radius.circular(40.0),
                            bottomRight: const  Radius.circular(40.0))
          ),
          height: 210.0,
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Kategori",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  new InkWell(
                    onTap: () {
                      bloc.selectedCategory = "todos";
                      bloc.getProducts();
                    },
                    child: new Padding(
                      padding: new EdgeInsets.all(10.0),
                      child: new Text("Lihat Semua"),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              KategoriList(
                kategori: bloc.kategori,
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: bloc.produk != [] || bloc.produk.length != 0
                      ? new AlwaysScrollableScrollPhysics()
                      : new NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: ProdukList(produk: bloc.produk),
                ),
              ),
            ],
          ),
        )]),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              new Container(
                color: Colors.transparent,
                child: UserAccountsDrawerHeader(
                  accountName:
                  Text((user.user != null) ? user.user.nama : "Guest"),
                  accountEmail: Text((user.user != null)
                      ? user.user.email
                      : "Guest@gmail.com"),
                ),
              ),
              ListTile(
                title: Text('My Orders'),
                leading: Icon(Icons.shopping_basket),
                onTap: () {
                  (user.user != null)
                      ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderListPage()))
                      : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage()));
                },
              ),
              ListTile(
                title: Text('Contact'),
                leading: Icon(Icons.local_phone),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContactPage()));
                },
              ),
              ListTile(
                title: Text('Store location'),
                leading: Icon(Icons.location_on),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LocationPage()));
                },
              ),
              Divider(),
              (user.user != null)
                  ? ListTile(
                title: Text('Logout'),
                leading: Icon(Icons.exit_to_app),
                onTap: () {
                  user.logout();
                  keranjangBloc.keranjang.clear();
                  keranjangBloc.total = 0;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage()));
                },
              )
                  : ListTile(
                title: Text('Login'),
                leading: Icon(Icons.exit_to_app),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage()));
                },
              ),
            ],
          ),
        ));
  }
}