import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:async_loader/async_loader.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Demo',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new MyHomePage(),
        routes: <String, WidgetBuilder>{
          '/secondpage': (BuildContext context) => new MyHomePage(),
        }
    );
  }
}

class MyHomePage extends StatelessWidget {

  final GlobalKey<AsyncLoaderState> _asyncLoaderState = new GlobalKey<AsyncLoaderState>();

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
      key: _asyncLoaderState,
      initState: () async => await getMessage(),
      renderLoad: () => new CircularProgressIndicator(),
      renderError: ([error]) => new Text('Sorry, there was an error loading your joke'),
      renderSuccess: ({data}) => new Text(data),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Demo"),
        actions: <Widget>[
          new IconButton(
              icon: const Icon(Icons.access_alarm),
              onPressed: () {
                showModalBottomSheet<Null>(context: context, builder: (BuildContext context) {
                  return new Container(
                      child: new Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: new Text('This is the modal bottom sheet. Click anywhere to dismiss.',
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  color: Theme
                                      .of(context)
                                      .accentColor,
                                  fontSize: 24.0
                              )
                          )
                      )
                  );
                });
              }
          ),
          new IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: () {
                Navigator.of(context).pushNamed('/secondpage');
              }
          ),
        ],
      ),
      body: new Center(child: _asyncLoader),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => _asyncLoaderState.currentState.reloadState(),
        tooltip: 'Reload',
        child: new Icon(Icons.refresh),
      ),
    );
  }
}

const TIMEOUT = const Duration(seconds: 3);

getMessage() async {
  return new Future.delayed(TIMEOUT, () => 'Welcome to your async screen');
}
