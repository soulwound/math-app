import 'dart:convert';

import 'package:http/http.dart' as http;

class QuoteAPIRequest {

  String url;
  String key;

  QuoteAPIRequest(this.url, this.key);

  Future<List<String>> getQuote() async {
    var response = await http.get(Uri.parse(url), headers: {'X-Api-Key': key});
    List responseQuote = jsonDecode(response.body);
    String quote = responseQuote[0]['quote'];
    String author = responseQuote[0]['author'];
    return [quote, author];
  }
}