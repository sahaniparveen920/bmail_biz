

class TrashEmail {
  bool? success;
  List<Emails>? emails;

  TrashEmail({this.success, this.emails});

  TrashEmail.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['emails'] != null) {
      emails = <Emails>[];
      json['emails'].forEach((v) {
        emails!.add(new Emails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.emails != null) {
      data['emails'] = this.emails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Emails {
  String? subject;
  String? from;
  String? date;
  String? body;
  String? messageId;

  Emails({this.subject, this.from, this.date, this.body, this.messageId});

  Emails.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    from = json['from'];
    date = json['date'];
    body = json['body'];
    messageId = json['message_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject'] = this.subject;
    data['from'] = this.from;
    data['date'] = this.date;
    data['body'] = this.body;
    data['message_id'] = this.messageId;
    return data;
  }
}