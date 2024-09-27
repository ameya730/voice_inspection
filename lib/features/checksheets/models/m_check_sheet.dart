class MCheckSheet {
  String? gROUP;
  int? gROUPID;
  int? sEQUENCE;
  String? sKU;

  MCheckSheet({this.gROUP, this.gROUPID, this.sEQUENCE, this.sKU});

  MCheckSheet.fromJson(Map<String, dynamic> json) {
    gROUP = json['GROUP'];
    gROUPID = json['GROUP_ID'];
    sEQUENCE = json['SEQUENCE'];
    sKU = json['SKU'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['GROUP'] = gROUP;
    data['GROUP_ID'] = gROUPID;
    data['SEQUENCE'] = sEQUENCE;
    data['SKU'] = sKU;
    return data;
  }
}
