class KategoriListItemModel {

  String id;
  String name;

  KategoriListItemModel({this.id, this.name});

  factory KategoriListItemModel.fromJson(Map<dynamic, dynamic> json) {
    return KategoriListItemModel(
        id: json['key'],
        name: json['nama']
    );
  }
}