import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() async{
  List currencies = await getCurrencies();
  print(currencies);
  runApp(new MyApp(currencies));
}

class MyApp extends StatelessWidget {
  final List _currencies;
  MyApp(this._currencies);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.red
      ),
      home: new HomePage(_currencies),
    );
  }
}


Future<List> getCurrencies() async{
  final String url="https://api.coinmarketcap.com/v1/ticker/?limit=30";
  http.Response response= await http.get(url);
  return JSON.decode(response.body);
}

class HomePage extends StatefulWidget {
  final List currencies;
  HomePage(this.currencies);
  @override
  _HomePageState createState() => new _HomePageState(currencies);
}

class _HomePageState extends State<HomePage> {
  List _currencies;
  _HomePageState(this._currencies);
  List<MaterialColor> cryptoColors=[Colors.blue, Colors.indigo, Colors.yellow];


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Crypto Control")),

      body: new ListView.builder(
        itemCount:_currencies.length,

        itemBuilder: (BuildContext context, int index){
          final Map mapcurrency=_currencies[index];
          final String usd =mapcurrency['price_usd'];
          final String change=mapcurrency['percent_change_1h'];
          TextSpan percentageChangeTextWidget;
          if (double.parse(change) > 0) {
            percentageChangeTextWidget = new TextSpan(
                text: "Fluctuation in last 1 hour: $change",
                style: new TextStyle(color: Colors.green));
          } else {
              percentageChangeTextWidget = new TextSpan(
                  text: "Fluctuation in last 1 hour: $change", style: new TextStyle(color: Colors.red));
          }

          return new Container(
            child: new Center(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new ListTile(
                    leading:new Image.network("http://cryptoicons.co/32@2x/color/"+mapcurrency['symbol'].toLowerCase() +"@2x.png"),
                    title: new Text(mapcurrency['name'],style: new TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: new RichText(
                      text: new TextSpan(
                       children: [
                         new TextSpan(text: "\$$usd\n", style: new TextStyle(color: Colors.black)),
                         percentageChangeTextWidget
                       ]
                      ),
                    ),
                    isThreeLine: true,
                  )
                ],
              ),
            ),
          );
      },
    ),
    );
  }

}
