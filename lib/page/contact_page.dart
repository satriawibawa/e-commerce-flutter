import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  _launchURL() async {
    const url = 'https://api.whatsapp.com/send?phone=628xxxxxx';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Contact"),
          backgroundColor: Colors.cyan,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Butuh bantuan ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 22)),
              new GestureDetector(
                  onTap: () {
                    _launchURL();
                  },
                  child: Image.asset(
                    'assets/gambar/wa.png',
                    width: 30.0,
                    height: 50.0,
                  )),
              new GestureDetector(
                onTap: () {
                  _launchURL();
                },
                child: Text("+62xxxxxxxxxx",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontSize: 16)),
              ),
              RaisedButton.icon(
                  elevation: 4.0,
                  icon: Image.asset(
                    'assets/gambar/wa.png',
                    width: 20,
                    height: 20,
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    _launchURL();
                  },
                  label: Text("Contact WA Click",
                      style: TextStyle(color: Colors.white, fontSize: 16.0))),
            ],
          ),
        ));
  }
}
