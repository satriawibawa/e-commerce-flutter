class BuatUserModel {
  String name;
  String email;
  String password;
  int noTelp;
  String alamat;

  BuatUserModel({
    this.name,
    this.email,
    this.password,
    this.noTelp,
    this.alamat
  });

  BuatUserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    noTelp = json['noTelp'];
    alamat = json['alamat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['noTelp'] = this.noTelp;
    data['alamat'] = this.alamat;
    return data;
  }
}