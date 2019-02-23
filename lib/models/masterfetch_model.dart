class MasterfetchModel {
  List<MainEvents> mainEvents;

  MasterfetchModel({this.mainEvents});

  MasterfetchModel.fromJson(Map<String, dynamic> json) {
    if (json['mainEvents'] != null) {
      mainEvents = new List<MainEvents>();
      json['mainEvents'].forEach((v) {
        mainEvents.add(new MainEvents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mainEvents != null) {
      data['mainEvents'] = this.mainEvents.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MainEvents {
  int categoryId;
  String categoryName;
  String categoryImages;
  List<Event> events;

  MainEvents(
      {this.categoryId, this.categoryName, this.categoryImages, this.events});

  MainEvents.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    categoryImages = json['category_images'];
    if (json['events'] != null) {
      events = new List<Event>();
      json['events'].forEach((v) {
        events.add(new Event.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['category_images'] = this.categoryImages;
    if (this.events != null) {
      data['events'] = this.events.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Event {
  int eventId;
  String name;
  String description;
  String rules;
  String venue;
  String date;
  String fee;
  int organizerId;
  int categoryId;
  String time;
  String imgUrl;
  String categoryName;
  String categoryImages;
  String prize;
  bool isExpanded = false;

  Event(
      {this.eventId,
      this.name,
      this.description,
      this.rules,
      this.venue,
      this.date,
      this.fee,
      this.organizerId,
      this.categoryId,
      this.time,
      this.imgUrl,
      this.categoryName,
      this.categoryImages,
      this.prize});

  Event.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    name = json['name'];
    description = json['description'];
    rules = json['rules'];
    venue = json['venue'];
    date = json['date'];
    fee = json['fee'];
    organizerId = json['organizer_id'];
    categoryId = json['category_id'];
    time = json['time'];
    imgUrl = json['img_url'];
    categoryName = json['category_name'];
    categoryImages = json['category_images'];
    prize = json['prize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_id'] = this.eventId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['rules'] = this.rules;
    data['venue'] = this.venue;
    data['date'] = this.date;
    data['fee'] = this.fee;
    data['organizer_id'] = this.organizerId;
    data['category_id'] = this.categoryId;
    data['time'] = this.time;
    data['img_url'] = this.imgUrl;
    data['category_name'] = this.categoryName;
    data['category_images'] = this.categoryImages;
    data['prize'] = this.prize;
    return data;
  }
}
