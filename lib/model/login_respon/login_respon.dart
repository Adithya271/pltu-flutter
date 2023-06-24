class LoginRespon {
  ResponStatus? responStatus;
  Data? data;

  LoginRespon({this.responStatus, this.data});

  LoginRespon.fromJson(Map<String, dynamic> json) {
    responStatus = json['respon_status'] != null
        ? ResponStatus.fromJson(json['respon_status'])
        : null;
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (responStatus != null) {
      data['respon_status'] = responStatus!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    return data;
  }
}

class Data {
  Record? record;
  Token? token;

  Data({this.record, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    record = json['record'] != null ? Record.fromJson(json['record']) : null;
    token = json['token'] != null ? Token.fromJson(json['token']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (record != null) {
      data['record'] = record!.toJson();
    }
    if (token != null) {
      data['token'] = token!.toJson();
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
  String? createdAt;
  String? updatedAt;
  Role? role;

  Record(
      {this.id,
      this.name,
      this.email,
      this.roleId,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt,
      this.role});

  Record.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    roleId = json['role_id'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    role = json['role'] != null ? Role.fromJson(json['role']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['role_id'] = roleId;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (role != null) {
      data['role'] = role!.toJson();
    }
    return data;
  }
}

class Role {
  int? id;
  String? name;
  String? description;
  String? createdAt;
  String? updatedAt;

  Role({this.id, this.name, this.description, this.createdAt, this.updatedAt});

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['expires_in'] = expiresIn;
    return data;
  }
}
