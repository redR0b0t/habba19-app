class UserDetailsModel {
  Data data;
  bool success;

  UserDetailsModel({this.data, this.success});

  UserDetailsModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['success'] = this.success;
    return data;
  }
}

class Data {
  Details details;
  List<EventsRegistered> eventsRegistered;
  List<Notifications> notifications;

  Data({this.details, this.eventsRegistered, this.notifications});

  Data.fromJson(Map<String, dynamic> json) {
    details =
        json['details'] != null ? new Details.fromJson(json['details']) : null;
    if (json['eventsRegistered'] != null) {
      eventsRegistered = new List<EventsRegistered>();
      json['eventsRegistered'].forEach((v) {
        eventsRegistered.add(new EventsRegistered.fromJson(v));
      });
    }
    if (json['notifications'] != null) {
      notifications = new List<Notifications>();
      json['notifications'].forEach((v) {
        notifications.add(new Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details.toJson();
    }
    if (this.eventsRegistered != null) {
      data['eventsRegistered'] =
          this.eventsRegistered.map((v) => v.toJson()).toList();
    }
    if (this.notifications != null) {
      data['notifications'] =
          this.notifications.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
  String name;
  String email;
  String phoneNumber;
  String collegeName;

  Details({this.name, this.email, this.phoneNumber, this.collegeName});

  Details.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    collegeName = json['college_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['college_name'] = this.collegeName;
    return data;
  }
}

class EventsRegistered {
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
  String prize;
  String organizerName;
  String phoneNumber;
  String email;

  EventsRegistered(
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
      this.prize,
      this.organizerName,
      this.phoneNumber,
      this.email});

  EventsRegistered.fromJson(Map<String, dynamic> json) {
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
    prize = json['prize'];
    organizerName = json['organizer_name'];
    phoneNumber = json['phone_number'];
    email = json['email'];
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
    data['prize'] = this.prize;
    data['organizer_name'] = this.organizerName;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    return data;
  }
}

class Notifications {
  String title;
  String message;

  Notifications({this.title, this.message});

  Notifications.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['message'] = this.message;
    return data;
  }
}
