class ProdukListItemModel {
  String key;
  String nama;
  String kategori;
  int harga;
  String picture;
  int quantity;
  int berat;
  String description;

  ProdukListItemModel({this.key, this.nama, this.kategori, this.harga, this.picture, this.quantity, this.berat, this.description});

  factory ProdukListItemModel.fromJson(var json) {
    return ProdukListItemModel(
        key: json['key'],
        nama: json['nama'],
        kategori: json['kategori'],
        harga: json['harga'],
        picture: json['picture'],
        quantity: json['quantity'],
        berat: json['berat'],
        description: json['description']
    );
  }
}