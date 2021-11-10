import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elastic_client/elastic_client.dart';
import 'package:sportiwe_admin/configs/constants.dart';
import 'package:http/http.dart' as http;
import 'package:sportiwe_admin/configs/elastic_search_api_keys.dart';
import 'package:sportiwe_admin/models/report_model.dart';
import 'package:sportiwe_admin/utils/my_print.dart';

class ElasticController {
  static ElasticController? _instance;

  HttpTransport? transport;
  Client? client;

  factory ElasticController() {
    if(_instance == null) {
      _instance = ElasticController._();
    }
    return _instance!;
  }

  ElasticController.__(String url, String basicAuth) {
    transport = HttpTransport(url: url, authorization: basicAuth);
    client = Client(transport!);
  }

  ElasticController._() {
    transport = HttpTransport(url: getElasticSearchUrl(), authorization: getElasticSearchBasicAuth());
    client = Client(transport!);
  }

  static ElasticController getObject(String url, String basicAuth) {
    return ElasticController.__(url, basicAuth);
  }

  Future<bool> createDocument(String index, String docId, Map<String, dynamic> data) async {
    String url = getElasticSearchUrl();
    url += "$index/_doc/$docId";

    Map<String, String> header = {
      "Authorization" : getElasticSearchBasicAuth(),
      "Content-Type" : "application/json",
      "Access-Control-Allow-Origin": "*",
    };

    Map<String, dynamic> body = data;

    http.Response response = await http.put(Uri.parse(url), headers: header, body: jsonEncode(body));
    MyPrint.printOnConsole("Create Document Response For, Body: $docId:${response.body}, Status Code:${response.statusCode}");

    return response.statusCode == 201;
  }

  Future<bool> updateDocument(String index, String docId, Map<String, dynamic> data) async {
    String url = getElasticSearchUrl();
    url += "$index/_update/$docId";

    Map<String, String> header = {
      "Authorization" : getElasticSearchBasicAuth(),
      "Content-Type" : "application/json",
      "Access-Control-Allow-Origin": "*",
    };

    Map<String, dynamic> body = {
      "doc" : data,
    };

    http.Response response = await http.post(Uri.parse(url), headers: header, body: jsonEncode(body));
    MyPrint.printOnConsole("Update Document Response For $docId:${response.body}");

    return response.statusCode == 200;
  }

  Future<Doc?> getDocument(String index, String docId) async {
    MyPrint.printOnConsole('GetDocument Called');

    String url = getElasticSearchUrl();
    url += "$index/_doc/$docId";

    Map<String, String> header = {
      "Authorization" : getElasticSearchBasicAuth(),
      "Content-Type" : "application/json",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",

    };

    http.Response response = await http.get(Uri.parse(url), headers: header);
    //MyPrint.printOnConsole("Get Document Status For $docId:${response.statusCode}");
    //MyPrint.printOnConsole("Get Document Response For $docId:${response.body}");

    Doc? doc;

    try {
      if(response.statusCode == 200) {
        Map<String, dynamic> data = Map.castFrom(jsonDecode(response.body));
        doc = Doc(data['_id'], Map.castFrom(data['_source'] ?? {}));
      }
    }
    catch(e) {
      MyPrint.printOnConsole("Error in Converting Map to Doc in ElasticController().getDocument():${e}");
    }

    return doc;
  }

  Future<void> _copyDocsFromOneToOtherElastic() async {
    ElasticController elasticControllerOld = ElasticController.getObject(getElasticSearchUrl(), getElasticSearchBasicAuth());
    ElasticController elasticControllerNew = ElasticController.getObject("https://sportiwe-dev-770218.es.asia-south1.gcp.elastic-cloud.com:9243/", "Basic ZWxhc3RpYzozaVdWQ1prY3NoQVJod0NpZGxNSVRPNmY=");

    SearchResult searchResult = await elasticControllerOld.client!.search(index: getVenuesIndex(), limit: 10000);
    MyPrint.printOnConsole("Hits:${searchResult.hits.length}");

    List<Doc> docs = searchResult.hits.map((e) {
      return Doc(e.id, e.doc);
    }).toList();

    await elasticControllerNew.client!.bulk(index: getVenuesIndex(), updateDocs: docs);
  }

  Future<bool> arrayUnion(String reportId, Map<String, dynamic> data)async{
    String url = getElasticSearchUrl();
    url += "${getReportIndex()}/_update/$reportId";

    Map<String, String> header = {
      "Authorization" : getElasticSearchBasicAuth(),
      "Content-Type" : "application/json",
      "Access-Control-Allow-Origin": "*",
    };
    // ReporterModel reporterModel  = ReporterModel(
    //     status: "Pending",
    //     created_time: Timestamp.now(),
    //     description: "This",
    //     reportersId: "xyz"
    // );

    Map<String, dynamic> body = {
      "script" : {
        "source": "ctx._source.reporters.addAll(params.reporter)",
        "lang": "painless",
        "params" : {
          "reporter" : [data]
        }
      }
    };

    http.Response response = await http.post(Uri.parse(url), headers: header, body: jsonEncode(body));
    MyPrint.printOnConsole("Update Document Response For $reportId:${response.body}");

    return response.statusCode == 200;
  }


}