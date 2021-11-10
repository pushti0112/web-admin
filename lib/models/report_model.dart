import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportiwe_admin/utils/date_presentation.dart';
import 'package:sportiwe_admin/utils/my_print.dart';

class ReportModel {
  //target id is venueId/userId
  String? target_id, type, name, address, city,state;
  List<ReporterModel>? reporters;

  ReportModel({this.type, this.reporters, this.target_id, this.name,this.address,this.city,this.state});

  static elasticFromMap(Map<String, dynamic> map) {
    String? target_id, type, name, address, city,state;
    List<ReporterModel>? reporters;
    target_id = map['target_id'] != null && map['target_id'].isNotEmpty
        ? map['target_id'].toString()
        : "";
    name = map['name'] != null && map['name'].isNotEmpty
        ? map['name'].toString()
        : "";
    address = map['address'] != null && map['address'].isNotEmpty
        ? map['address'].toString()
        : "";
    city = map['city'] != null && map['city'].isNotEmpty
        ? map['city'].toString()
        : "";
    state = map['state'] != null && map['state'].isNotEmpty
        ? map['state'].toString()
        : "";
    reporters = [];
    try {
      List<Map<String, dynamic>> list = List.from(List.castFrom(map['reporters'] ?? []));
      list.forEach((Map<String, dynamic> map) {
        if(map.isNotEmpty) {
          reporters!.add(ReporterModel.elasticFromMap(map));
        }
      });
    } catch(e) {
      MyPrint.printOnConsole("Error in Parsing Reporters model in reporter model:${e}");
    }

    return ReportModel(type: type, reporters: reporters, target_id: target_id,state: state,city: city,address: address,name: name);
  }

  void elasticUpdateFromMap(Map<String, dynamic> map) {
    target_id = map['target_id'] != null && map['target_id'].isNotEmpty
        ? map['target_id'].toString()
        : "";
    type = map['type'] != null && map['type'].isNotEmpty
        ? map['type'].toString()
        : "";
    reporters = [];
    try {
      List<Map<String, dynamic>> list = List.from(List.castFrom(map['reporters'] ?? []));
      list.forEach((Map<String, dynamic> map) {
        if(map != null && map.isNotEmpty) {
          reporters!.add(ReporterModel.elasticFromMap(map));
        }
      });
    } catch(e) {
      MyPrint.printOnConsole("Error in Parsing Reporters model in reporter model:${e}");
    }
  }

  Map<String,dynamic> elasticToMap(){
    List<Map<String, dynamic>> list = [];
    if(reporters != null) {
      reporters!.forEach((ReporterModel reporterModel) {
        list.add(reporterModel.elasticToMap());
      });
    }
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data["target_id"] = target_id ?? "";
    data["type"] = type ?? "";
    data["city"] = city ?? "";
    data["address"] = address ?? "";
    data["state"] = state ?? "";
    data["name"] = name ?? "";
    data["reporters"] = list;

    return data;
  }
}

class ReporterModel {
  String? description, status, reportersId,reporterName;
  Timestamp? created_time;

  ReporterModel(
      {this.reportersId, this.description, this.status, this.created_time,this.reporterName});

  static elasticFromMap(Map<String, dynamic> map) {
    String? description, status, reportersId,reporterName;
    Timestamp? created_time;
    reportersId = map['reportersId'] != null && map['reportersId'].isNotEmpty
        ? map['reportersId'].toString()
        : "";

    description = map['description'] != null && map['description'].isNotEmpty
        ? map['description'].toString()
        : "";
    status = map['status'] != null && map['status'].isNotEmpty
        ? map['status'].toString()
        : "";
    reporterName = map['reporterName'] != null && map['reporterName'].isNotEmpty
        ? map['reporterName'].toString()
        : "";

    created_time = map['created_time'] != null && map['created_time'].isNotEmpty
        ? Timestamp.fromDate(DateTime.parse(map['created_time']))
        : null;

    return ReporterModel(
        description: description,
        status: status,
        reporterName: reporterName,
        reportersId: reportersId,
        created_time: created_time);
  }
  Map<String,dynamic> elasticToMap(){
    return {
      "reportersId":reportersId ?? "",
      "status":status ?? "",
      "reporterName":reporterName ?? "",
      "description":description?? "",
      "created_time" : created_time != null ?DatePresentation.yyyyMMddHHmmssFormatter(created_time!):null,
    };
  }
}