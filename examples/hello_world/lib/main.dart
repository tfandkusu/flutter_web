// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_web/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

// アプリルート
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web with Flask',
      // テーマ設定
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

// 名刺詳細画面
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// その状態
class _MyHomePageState extends State<MyHomePage> {
  //氏名
  String _name;

  //社名
  String _company;

  //所属
  String _division;

  //役職
  String _title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('名刺詳細')),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: makeChildren(),
            )));
  }

  // paddingの中の要素たち
  List<Widget> makeChildren() {
    if (_name == null) {
      // 名刺が無いのでプログレスを表示
      return <Widget>[CircularProgressIndicator()];
    } else {
      // 名刺を表示
      return <Widget>[
        Text(_company, style: Theme
            .of(context)
            .textTheme
            .title),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text("$_division $_title", style: Theme
              .of(context)
              .textTheme
              .body1),
        ),
        Text(_name, style: Theme
            .of(context)
            .textTheme
            .title)
      ];
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // APIから取ってくる
  loadData() async {
    String url = 'https://jjsonplaceholder.appspot.com/cards/1';
    http.Response response = await http.get(url);
    var card = json.decode(utf8.decode(response.bodyBytes));
    // 画面を更新
    setState(() {
      _name = card['name'];
      _company = card['company'];
      _division = card['division'];
      _title = card['title'];
    });
  }
}
