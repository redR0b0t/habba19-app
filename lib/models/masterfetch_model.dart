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

  List<Event> _masterList = [];

  List<Event> get masterList {
    _masterList = [];
    this.mainEvents.forEach((MainEvents mainEvents) {
      _masterList.addAll(mainEvents.events);
    });
    return _masterList;
  }

  List<Event> get day1List {
    try {
      return masterList.where((Event e) {
        try {
          String startDate = e.startDate;
          return DateTime.parse(startDate).day == 28;
        } catch (e) {
          return false;
        }
      }).toList();
    } catch (e) {}
  }

  List<Event> get day2List {
    return masterList.where((Event e) {
      try {
        String startDate = e.startDate;
        return DateTime.parse(startDate).day == 29;
      } catch (e) {
        print(e);
        return false;
      }
    }).toList();
  }

  List<Event> get day3List {
    return masterList.where((Event e) {
      try {
        String startDate = e.startDate;
        return DateTime.parse(startDate).day == 30;
      } catch (e) {
        return false;
      }
    }).toList();
  }

  List<Event> get day0List {
    return masterList.where((Event e) {
      try {
        String startDate = e.startDate;
        int day = DateTime.parse(startDate).day;
        return day != 28 && day != 29 && day != 30;
      } catch (e) {
        return false;
      }
    }).toList();
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
  String startDate;
  String endDate;
  String fee;
  int organizerId;
  int categoryId;
  String time;
  String imgUrl;
  String categoryName;
  String categoryImages;
  String prize;
  String organizerName;
  String organizerPhone;
  bool isExpanded = false;

  Event(
      {this.eventId,
      this.name,
      this.description,
      this.rules,
      this.venue,
      this.startDate,
      this.endDate,
      this.fee,
      this.organizerId,
      this.categoryId,
      this.time,
      this.imgUrl,
      this.categoryName,
      this.categoryImages,
      this.organizerName,
      this.organizerPhone,
      this.prize});

  Event.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    name = json['name'];
    description = json['description'];
    rules = json['rules'];
    venue = json['venue'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    fee = json['fee'];
    organizerId = json['organizer_id'];
    categoryId = json['category_id'];
    time = json['time'];
    imgUrl = json['img_url'];
    categoryName = json['category_name'];
    categoryImages = json['category_images'];
    prize = json['prize'];
    organizerPhone = json['organizer_phone'];
    organizerName = json['organizer_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_id'] = this.eventId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['rules'] = this.rules;
    data['venue'] = this.venue;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['fee'] = this.fee;
    data['organizer_id'] = this.organizerId;
    data['category_id'] = this.categoryId;
    data['time'] = this.time;
    data['img_url'] = this.imgUrl;
    data['category_name'] = this.categoryName;
    data['category_images'] = this.categoryImages;
    data['organizer_name'] = this.organizerName;
    data['organizer_phone'] = this.organizerPhone;
    data['prize'] = this.prize;
    return data;
  }
}
