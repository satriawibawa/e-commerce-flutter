class KeranjangItemModel {
  String key;
  String nama;
  int quantity;
  int i;
  int harga;
  String picture;
  int berat;

  KeranjangItemModel({this.key, this.nama, this.quantity,this.i, this.harga, this.picture, this.berat});

  KeranjangItemModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    nama = json['nama'];
    quantity = json['quantity'];
    i = json['i'];
    harga = json['harga'];
    picture = json['picture'];
    berat = json['berat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['nama'] = this.nama;
    data['quantity'] = this.quantity;
    data['i'] = this.i;
    data['harga'] = this.harga;
    data['picture'] = this.picture;
    data['berat'] = this.berat;
    return data;
  }
}