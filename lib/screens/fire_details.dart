import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';

class FireDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Fire>(
        converter: (Store<AppState> store) => store.state.fire,
        builder: (BuildContext context, Fire fire) {
          String _title = fire.town;

          if (fire.town != fire.local) {
            _title = '$_title, ${fire.local}';
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.redAccent,
              iconTheme: new IconThemeData(color: Colors.white),
              title: new Text(
                _title,
                style: new TextStyle(color: Colors.white),
              ),
            ),
            body: Container(),
          );
        });
  }
}
