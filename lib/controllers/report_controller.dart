import 'package:elastic_client/elastic_client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportiwe_admin/configs/constants.dart';
import 'package:sportiwe_admin/configs/elastic_search_api_keys.dart';

import 'package:sportiwe_admin/controllers/elastic_controller.dart';
import 'package:sportiwe_admin/controllers/providers/report_provider.dart';

import 'package:sportiwe_admin/models/report_model.dart';
import 'package:sportiwe_admin/utils/my_print.dart';
import 'package:sportiwe_admin/utils/snakbar.dart';

class ReportController {
  static ReportController? _instance;

  factory ReportController() {
    if (_instance == null) {
      _instance = ReportController._();
    }
    return _instance!;
  }

  ReportController._();

  Future<void> createNewReport(BuildContext context, ReportModel reportModel,
      ReporterModel reporterModel) async {
    try {
      Doc? doc = await ElasticController()
          .getDocument(getReportIndex(), reportModel.target_id!);
      print(doc);
      if (doc != null) {
        bool isSuccess = await ElasticController().arrayUnion(reportModel.target_id!, reporterModel.elasticToMap());
        if(isSuccess) {
          Snakbar().show_success_snakbar(context, "Reported Successfully");
        } else {
          Snakbar().show_error_snakbar(context, "Not able to report");
        }
      } else {
        reportModel.reporters = [reporterModel];
       await ElasticController().createDocument(getReportIndex(),
            reportModel.target_id!, reportModel.elasticToMap()).then((bool isSuccess) {
          if(isSuccess) Snakbar().show_success_snakbar(context, "Reported Successfully");
          else Snakbar().show_error_snakbar(context, "Reporting Failed");
        });
      }
    } catch (e) {
      print("Error in create new report: $e");
    }
  }

  Future<void> getReportsList(String reportType,BuildContext context) async{
    try{
      List<Map<String, dynamic>> must = [];
      List<ReporterModel> reporterList =[];
      
      ReportProvider reportProvider = Provider.of<ReportProvider>(context, listen: false);

      if(reportType=='Users'){
        must.add({
          "match": {
            "type": "Report_Type_User"
          }
        });
      }
      else{
        must.add({
          "match": {
            "type": "Report_Type_Venue"
          }
        });
      }

      Map<String, dynamic> query = {
        "bool": {
          "must": must, 
        }
      };
   
      SearchResult searchResult = await ElasticController().client!.index(name: getReportIndex()).search(
        query: query,
        // size: documentLimit,
        // offset: elasticIndex,
      );
 
      MyPrint.printOnConsole("Venue Docs Length:${searchResult.hits.length}");

      searchResult.hits.forEach((element) {
        MyPrint.printOnConsole("Document:${element.id}");
      // venues.add(VenueModel.elasticFromMap(Map.castFrom(element.doc)));
        reporterList.add(ReporterModel.elasticFromMap(Map.castFrom(element.doc)));

      });
      reportProvider.reportersList!.addAll(reporterList);
      MyPrint.printOnConsole("reporterlist"+reportProvider.reportersList.toString());
    }
    catch(e){
      MyPrint.printOnConsole("error..."+e.toString());
    }
    

  }
  
}