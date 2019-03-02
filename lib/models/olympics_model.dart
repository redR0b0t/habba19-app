class OlympicsModel {
  List<Data> data;
  bool success;

  OlympicsModel({this.data, this.success});

  OlympicsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class Data {
  int collegeId;
  String name;
  int points;
  String imgUrl, description;

  Data({this.collegeId, this.name, this.points, this.imgUrl, this.description});

  Data.fromJson(Map<String, dynamic> json) {
    collegeId = json['college_id'];
    name = json['name'];
    points = json['points'];
    imgUrl = json['img_url'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['college_id'] = this.collegeId;
    data['name'] = this.name;
    data['points'] = this.points;
    data['img_url'] = this.imgUrl;
    return data;
  }
}
