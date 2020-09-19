class ProdukDetailModel {
  String key;
  String nama;
  String kategori;
  int harga;
  String description;
  String picture;
  int quantity;
  int berat;

  ProdukDetailModel(
      {this.key,
        this.nama,
        this.kategori,
        this.harga,
        this.description,
        this.picture,
        this.quantity,
        this.berat
      });

  factory ProdukDetailModel.fromJson(Map<dynamic, dynamic> json) {
    return ProdukDetailModel(
        key: json['key'],
        nama: json['nama'],
        kategori: json['kategori'],
        harga: json['harga'],
        description: json['description'],
        picture: json['picture'],
        quantity: json['quantity'],
        berat: json['berat']
    );
  }
}