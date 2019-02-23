class NewsFeedModel {
  List<NewsItem> newsItems;
  bool success;

  NewsFeedModel({this.newsItems, this.success});

  NewsFeedModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      newsItems = new List<NewsItem>();
      json['data'].forEach((v) {
        newsItems.add(new NewsItem.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.newsItems != null) {
      data['data'] = this.newsItems.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class NewsItem {
  int id;
  String title;
  String body;
  String url;

  NewsItem({this.id, this.title, this.body, this.url});

  NewsItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['url'] = this.url;
    return data;
  }
}