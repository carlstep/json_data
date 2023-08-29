// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<CurrencyData> fetchCurrencyData() async {
  final response =
      await http.get(Uri.parse('https://api.exchangerate.host/symbols'));

  return CurrencyData.fromJson(response.body as Map<String, dynamic>);
}

// List<CurrencyData> parseCurrencyData(String responseBody) {
//   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

//   return parsed
//       .map<CurrencyData>((json) => CurrencyData.fromJson(json))
//       .toList();
// }

class CurrencyData {
  Motd motd;
  bool success;
  Map<String, Symbol> symbols;

  CurrencyData({
    required this.motd,
    required this.success,
    required this.symbols,
  });

  factory CurrencyData.fromJson(Map<String, dynamic> json) => CurrencyData(
        motd: Motd.fromJson(json["motd"]),
        success: json["success"],
        symbols: Map.from(json["symbols"])
            .map((k, v) => MapEntry<String, Symbol>(k, Symbol.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "motd": motd.toJson(),
        "success": success,
        "symbols": Map.from(symbols)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class Motd {
  String msg;
  String url;

  Motd({
    required this.msg,
    required this.url,
  });

  factory Motd.fromJson(Map<String, dynamic> json) => Motd(
        msg: json["msg"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "url": url,
      };
}

class Symbol {
  String description;
  String code;

  Symbol({
    required this.description,
    required this.code,
  });

  factory Symbol.fromJson(Map<String, dynamic> json) => Symbol(
        description: json["description"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "code": code,
      };
}

class PageFourV1 extends StatefulWidget {
  const PageFourV1({super.key});

  @override
  State<PageFourV1> createState() => _PageFourV1State();
}

class _PageFourV1State extends State<PageFourV1> {
  late Future<CurrencyData> currencies;

  @override
  void initState() {
    super.initState();
    currencies = fetchCurrencyData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CurrencyData>(
        future: fetchCurrencyData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('data has error'),
            );
          } else if (snapshot.hasData) {
            return Text(snapshot.data!.symbols.toString());
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class CurrencyList extends StatelessWidget {
  const CurrencyList({
    Key? key,
    required this.currencies,
  }) : super(key: key);

  final List<CurrencyData> currencies;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: currencies.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Text(currencies[index].symbols.toString()),
        );
      },
    );
  }
}
