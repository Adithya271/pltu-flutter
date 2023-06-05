class RegisterRespon {
  ResponStatus? responStatus;
  Data? data;

  RegisterRespon({this.responStatus, this.data});

  RegisterRespon.fromJson(Map<String, dynamic> json) {
    responStatus = json['respon_status'] != null
        ? new ResponStatus.fromJson(json['respon_status'])
        : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.responStatus != null) {
      data['respon_status'] = this.responStatus!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ResponStatus {
  String? status;
  int? code;
  String? message;

  ResponStatus({this.status, this.code, this.message});

  ResponStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  Record? record;
  Token? token;

  Data({this.record, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    record = json['record'] != null ? Record.fromJson(json['record']) : null;
     token = json['token'] != null ? new Token.fromJson(json['token']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (record != null) {
      data['record'] = record!.toJson();
    }
     if (this.token != null) {
      data['token'] = this.token!.toJson();
    }
    return data;
  }
}

class Record {
  int? id;
  String? name;
  String? email;
  int? roleId;
  String? emailVerifiedAt;
  Null? createdAt;
  Null? updatedAt;
  

  Record(
      {this.id,
      this.name,
      this.email,
      this.roleId,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt,
      });

  Record.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    roleId = json['role_id'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['role_id'] = roleId;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    
    return data;
  }
}


class Token {
  String? accessToken;
  String? tokenType;
  String? expiresIn;

  Token({this.accessToken, this.tokenType, this.expiresIn});

  Token.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['expires_in'] = this.expiresIn;
    return data;
  }
}



