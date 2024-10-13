import 'package:voice_poc/features/checksheets/models/m_check_sheet_details.dart';

class MCheckSheet {
  int? gROUPID;
  String? sKU;
  String? gROUP;
  int? sEQUENCE;
  List<CheckSheetDetails>? details;
  String? status;
  String? recordedPath;

  MCheckSheet({
    this.gROUPID,
    this.sKU,
    this.gROUP,
    this.sEQUENCE,
    this.details,
    this.status,
    this.recordedPath,
  });

  MCheckSheet.fromJson(Map<String, dynamic> json) {
    gROUPID = json['GROUP_ID'];
    sKU = json['SKU'];
    gROUP = json['GROUP'];
    sEQUENCE = json['SEQUENCE'];
    if (json['CHECKSHEETDET'] != null) {
      details = <CheckSheetDetails>[];
      json['CHECKSHEETDET'].forEach((v) {
        details!.add(CheckSheetDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['GROUP_ID'] = gROUPID;
    data['SKU'] = sKU;
    data['GROUP'] = gROUP;
    data['SEQUENCE'] = sEQUENCE;
    if (details != null) {
      data['CHECKSHEETDET'] = details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
