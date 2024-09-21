class DraftsEmails {
  bool? success;
  List<Emails>? emails;
  String? msg;

  DraftsEmails({this.success, this.emails, this.msg});

  DraftsEmails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['emails'] != null) {
      emails = <Emails>[];
      json['emails'].forEach((v) {
        emails!.add(new Emails.fromJson(v));
      });
    }
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.emails != null) {
      data['emails'] = this.emails!.map((v) => v.toJson()).toList();
    }
    data['msg'] = this.msg;
    return data;
  }
}

class Emails {
  String? subject;
  String? from;
  String? date;
  String? body;

  Emails({this.subject, this.from, this.date, this.body});

  Emails.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    from = json['from'];
    date = json['date'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject'] = this.subject;
    data['from'] = this.from;
    data['date'] = this.date;
    data['body'] = this.body;
    return data;
  }
}