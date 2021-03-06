import 'dart:convert';
import 'dart:convert' show utf8;
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fogosmobile/constants/endpoints.dart';

class Warnings extends StatefulWidget {
  @override
  _WarningsState createState() => _WarningsState();
}

class _WarningsState extends State<Warnings> {
  List warnings = [];
  bool connection = true;

  @override
  initState() {
    super.initState();
    this.getWarnigs();
  }

  Future<void> getWarnigs() async {
    try {
      String url = endpoints['getWarnings'];
      final response = await http.get(url);
      final data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        connection = true;
        warnings = data['data'];
      });
    } catch (e) {
      setState(() {
      connection = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        iconTheme: new IconThemeData(color: Colors.white),
        title: new Text(
          FogosLocalizations.of(context).textWarnings,
          style: new TextStyle(color: Colors.white),
        ),
      ),
      body: new Container(
        child: warningsBuilder()
        ),
    );
  }

  Widget warningsBuilder() {
    if (warnings.length != 0 && connection) {
      return new Column(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(top: 20.0),
          ),
          new Expanded(
            child: new ListView.builder(
              itemCount: this.warnings.length,
              itemBuilder: (BuildContext context, int index) {
                final _warning = this.warnings[index];
                return ListTile(
                  leading: Text(
                    _warning['label'],
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  title: Text(_warning['text']),
                );
              },
            ),
          ),
        ],
      );
    } else if (!connection) {
      return Container(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
              child: Row(children: <Widget>[
            Expanded(
              child: Column(
                children: [
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 75.0),
                        ),
                        Container(
                            child: RaisedButton(
                          child: Text(FogosLocalizations.of(context).textRefreshButton),
                          onPressed: this.getWarnigs,
                        ))
                      ]),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(FogosLocalizations.of(context).textNoConnection,
                            style: TextStyle(color: Colors.redAccent)),
                      ]),
                ],
              ),
            )
          ])));
    } else {
      return Center(
          child: CircularProgressIndicator(
        strokeWidth: 4.0,
        valueColor: AlwaysStoppedAnimation(Colors.redAccent),
      ));
    }
  }
}