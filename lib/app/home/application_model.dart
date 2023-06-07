class Application {
  String? id;
  String? amount;
  String? reason;
  String? status;

  Application({this.id, this.amount, this.reason, this.status});

  Application.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    reason = json['reason'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['reason'] = this.reason;
    data['status'] = this.status;
    return data;
  }
}
