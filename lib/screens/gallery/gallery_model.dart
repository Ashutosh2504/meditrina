// To parse this JSON data, do
//
//     final galleryModel = galleryModelFromJson(jsonString);

import 'dart:convert';

GalleryModel galleryModelFromJson(String str) =>
    GalleryModel.fromJson(json.decode(str));

String galleryModelToJson(GalleryModel data) => json.encode(data.toJson());

class GalleryModel {
  bool status;
  List<Gallery> data;

  GalleryModel({
    required this.status,
    required this.data,
  });

  factory GalleryModel.fromJson(Map<String, dynamic> json) => GalleryModel(
        status: json["status"],
        data: List<Gallery>.from(json["data"].map((x) => Gallery.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Gallery {
  String id;
  String galleryUrl;

  Gallery({
    required this.id,
    required this.galleryUrl,
  });

  factory Gallery.fromJson(Map<String, dynamic> json) => Gallery(
        id: json["id"],
        galleryUrl: json["gallery_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "gallery_url": galleryUrl,
      };
}
