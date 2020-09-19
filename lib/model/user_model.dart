class UserModel {
  String id;
  String email;
  String password;
  int noTelp;
  String nama;
  String alamat;

  UserModel(
      {
        this.id,
        this.nama,
        this.email,
        this.password,
        this.noTelp,
        this.alamat
      });

  UserModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
    email = json['email'];
    password = json['password'];
    noTelp = json['no_telp'];
    alamat = json['alamat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama'] = this.nama;
    data['email'] = this.email;
    data['password'] = this.password;
    data['no_telp'] = this.noTelp;
    data['alamat'] = this.alamat;
    return data;
  }
}