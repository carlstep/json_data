import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Currency> fetchCurrency() async {
  final response =
      await http.get(Uri.parse('https://api.exchangerate.host/symbols'));

  if (response.statusCode == 200) {
    print(response.body);
    return Currency.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class Currency {
  Motd motd;
  bool success;
  Map<String, Symbol> symbols;

  Currency({
    required this.motd,
    required this.success,
    required this.symbols,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
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

class PageFour extends StatefulWidget {
  const PageFour({super.key});

  @override
  State<PageFour> createState() => _PageFourState();
}

class _PageFourState extends State<PageFour> {
  late Future<Currency> currencies;

  @override
  void initState() {
    super.initState();
    currencies = fetchCurrency();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Currency>(
        future: currencies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.symbols.entries.toString());
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
