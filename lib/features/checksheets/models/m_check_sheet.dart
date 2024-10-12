import 'package:voice_poc/features/checksheets/models/m_check_sheet_details.dart';

class MCheckSheet {
  int? gROUPID;
  String? sKU;
  String? gROUP;
  int? sEQUENCE;
  List<CHECKSHEETDET>? cHECKSHEETDET;
  String? status;
  String? recordedPath;

  MCheckSheet({
    this.gROUPID,
    this.sKU,
    this.gROUP,
    this.sEQUENCE,
    this.cHECKSHEETDET,
    this.status,
    this.recordedPath,
  });

  MCheckSheet.fromJson(Map<String, dynamic> json) {
    gROUPID = json['GROUP_ID'];
    sKU = json['SKU'];
    gROUP = json['GROUP'];
    sEQUENCE = json['SEQUENCE'];
    if (json['CHECKSHEETDET'] != null) {
      cHECKSHEETDET = <CHECKSHEETDET>[];
      json['CHECKSHEETDET'].forEach((v) {
        cHECKSHEETDET!.add(CHECKSHEETDET.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['GROUP_ID'] = gROUPID;
    data['SKU'] = sKU;
    data['GROUP'] = gROUP;
    data['SEQUENCE'] = sEQUENCE;
    if (cHECKSHEETDET != null) {
      data['CHECKSHEETDET'] = cHECKSHEETDET!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
