// To parse this JSON data, do
//
//     final servicebyCategoryModel = servicebyCategoryModelFromJson(jsonString);

import 'dart:convert';

ServicebyCategoryModel servicebyCategoryModelFromJson(String str) =>
    ServicebyCategoryModel.fromJson(json.decode(str));

String servicebyCategoryModelToJson(ServicebyCategoryModel data) =>
    json.encode(data.toJson());

class ServicebyCategoryModel {
  ServicebyCategoryModel({
    required this.allServices,
    required this.serviceImage,
  });

  AllServices allServices;
  List<ServiceImage?> serviceImage;

  factory ServicebyCategoryModel.fromJson(Map<String, dynamic> json) =>
      ServicebyCategoryModel(
        allServices: AllServices.fromJson(json["all_services"]),
        serviceImage: List<ServiceImage?>.from(json["service_image"].map((x) {
          if (x is List) {
            return null;
          } else {
            return ServiceImage.fromJson(x);
          }
        })),
      );

  Map<String, dynamic> toJson() => {
        "all_services": allServices.toJson(),
        "service_image":
            List<dynamic>.from(serviceImage.map((x) => x?.toJson())),
      };
}

class AllServices {
  AllServices({
    this.currentPage,
    required this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int? currentPage;
  List<Datum> data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  factory AllServices.fromJson(Map<String, dynamic> json) => AllServices(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Datum {
  Datum({
    this.id,
    this.sellerId,
    this.title,
    this.price,
    this.image,
    this.isServiceOnline,
    this.serviceCityId,
    required this.sellerForMobile,
    required this.reviewsForMobile,
    required this.serviceCity,
  });

  dynamic id;
  dynamic sellerId;
  String? title;
  var price;
  String? image;
  int? isServiceOnline;
  dynamic serviceCityId;
  SellerForMobile sellerForMobile;
  List<ReviewsForMobile> reviewsForMobile;
  ServiceCity serviceCity;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        sellerId: json["seller_id"],
        title: json["title"],
        price: json["price"],
        image: json["image"],
        isServiceOnline: json["is_service_online"],
        serviceCityId: json["service_city_id"],
        sellerForMobile: SellerForMobile.fromJson(json["seller_for_mobile"]),
        reviewsForMobile: List<ReviewsForMobile>.from(json["reviews_for_mobile"]
            .map((x) => ReviewsForMobile.fromJson(x))),
        serviceCity: ServiceCity.fromJson(json["service_city"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "seller_id": sellerId,
        "title": title,
        "price": price,
        "image": image,
        "is_service_online": isServiceOnline,
        "service_city_id": serviceCityId,
        "seller_for_mobile": sellerForMobile.toJson(),
        "reviews_for_mobile":
            List<dynamic>.from(reviewsForMobile.map((x) => x.toJson())),
        "service_city": serviceCity.toJson(),
      };
}

class ReviewsForMobile {
  ReviewsForMobile({
    this.id,
    this.serviceId,
    this.rating,
    this.message,
    this.buyerId,
  });

  dynamic id;
  dynamic serviceId;
  int? rating;
  String? message;
  dynamic buyerId;

  factory ReviewsForMobile.fromJson(Map<String, dynamic> json) =>
      ReviewsForMobile(
        id: json["id"],
        serviceId: json["service_id"],
        rating: json["rating"],
        message: json["message"],
        buyerId: json["buyer_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_id": serviceId,
        "rating": rating,
        "message": message,
        "buyer_id": buyerId,
      };
}

class SellerForMobile {
  SellerForMobile({
    this.id,
    this.name,
    this.image,
    this.countryId,
  });

  dynamic id;
  String? name;
  String? image;
  dynamic countryId;

  factory SellerForMobile.fromJson(Map<String, dynamic> json) =>
      SellerForMobile(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        countryId: json["country_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "country_id": countryId,
      };
}

class ServiceCity {
  ServiceCity({
    this.id,
    this.serviceCity,
    this.countryId,
    this.status,
    required this.countryy,
  });

  dynamic id;
  String? serviceCity;
  dynamic countryId;
  dynamic status;

  Countryy countryy;

  factory ServiceCity.fromJson(Map<String, dynamic> json) => ServiceCity(
        id: json["id"],
        serviceCity: json["service_city"],
        countryId: json["country_id"],
        status: json["status"],
        countryy: Countryy.fromJson(json["countryy"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_city": serviceCity,
        "country_id": countryId,
        "status": status,
        "countryy": countryy.toJson(),
      };
}

class Countryy {
  Countryy({
    this.id,
    this.country,
    this.status,
  });

  dynamic id;
  String? country;
  dynamic status;

  factory Countryy.fromJson(Map<String, dynamic> json) => Countryy(
        id: json["id"],
        country: json["country"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country": country,
        "status": status,
      };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String? url;
  String? label;
  bool? active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}

class ServiceImage {
  ServiceImage({
    this.imageId,
    this.path,
    this.imgUrl,
    this.imgAlt,
  });

  dynamic imageId;
  String? path;
  String? imgUrl;
  dynamic imgAlt;

  factory ServiceImage.fromJson(Map<String, dynamic>? json) => ServiceImage(
        imageId: json?["image_id"],
        path: json?["path"],
        imgUrl: json?["img_url"],
        imgAlt: json?["img_alt"],
      );

  Map<String, dynamic> toJson() => {
        "image_id": imageId,
        "path": path,
        "img_url": imgUrl,
        "img_alt": imgAlt,
      };
}
