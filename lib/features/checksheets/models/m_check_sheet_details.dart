class CheckSheetDetails {
  int? id;
  int? sEQUENCE;
  String? gROUPDET;
  int? gROUPDETID;
  String? status;
  String? recordedPath;
  int? station;

  CheckSheetDetails({
    this.id,
    this.sEQUENCE,
    this.gROUPDET,
    this.gROUPDETID,
    this.status,
    this.recordedPath,
    this.station,
  });

  CheckSheetDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sEQUENCE = json['SEQUENCE'];
    gROUPDET = json['GROUP_DET'];
    gROUPDETID = json['GROUP_DET_ID'];
    station = json['station'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['SEQUENCE'] = sEQUENCE;
    data['GROUP_DET'] = gROUPDET;
    data['GROUP_DET_ID'] = gROUPDETID;
    return data;
  }
}
