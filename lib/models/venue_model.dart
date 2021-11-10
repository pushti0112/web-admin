class VenueModel {
  String? id, name, description, phone, city, state, address, lowerName,createdBy, timings,whatsapp,facebook,website,ownerName;
  List<String>? imageList, facilities, documentList, otherFacilites;
  Map<String, bool>? days;
  double? rating,latitude,longitude;
  bool? isEnabledByOwner,isEnabledByVenue;

  VenueModel(
    {
      this.name,
      this.lowerName,
      this.documentList,
      this.days,
      this.phone,
      this.createdBy,
      this.address,
      this.description,
      this.city,
      this.ownerName,
      this.state,
      this.latitude,
      this.longitude,
      this.facebook,
      this.whatsapp,
      this.website,
      this.imageList,
      this.id,
      this.facilities,
      this.otherFacilites,
      this.timings,
      this.rating,
      this.isEnabledByOwner,
      this.isEnabledByVenue
    }
  );

  static VenueModel fromMap(Map<String, dynamic> map) {
    String? name, description, city, address, state, id, phone, createdBy,lowerName, timings,whatsapp,facebook,website,ownerName;
    List<String>? imageList, facilities, documentList, otherFacilites;
    Map<String, bool>? days;
    bool? isEnabledByOwner,isEnabledByVenue;
    double? rating,latitude,longitude;

    name = map['title'] != null && map['title'].isNotEmpty ? map['title'].toString() : "";
    createdBy = map['createdBy'] != null && map['createdBy'].isNotEmpty ? map['createdBy'].toString() : "";
    isEnabledByOwner = map['isEnabledByOwner'] != null ? map['isEnabledByOwner'] : false;
    isEnabledByVenue = map['isEnabledByVenue'] != null ? map['isEnabledByVenue'] : false;
    timings = map['timings'] != null && map['timings'].isNotEmpty ? map['timings'].toString() : "";
    phone = map['phone'] != null && map['phone'].isNotEmpty ? map['phone'].toString() : "";
    description = map['description'] != null && map['description'].isNotEmpty ? map['description'].toString() : "";
    address = map['address'] != null && map['address'].isNotEmpty ? map['address'].toString() : "";
    lowerName = map['lowerName'] != null && map['lowerName'].isNotEmpty ? map['lowerName'].toString() : "";
    id = map['id'] != null && map['id'].isNotEmpty ? map['id'].toString() : "";
    city = map['city'] != null && map['city'].isNotEmpty ? map['city'].toString() : "";
    state = map['state'] != null && map['state'].isNotEmpty ? map['state'].toString() : "";
    whatsapp = map['whatsapp'] != null && map['whatsapp'].isNotEmpty ? map['whatsapp'].toString() : "";
    facebook = map['facebook'] != null && map['facebook'].isNotEmpty ? map['facebook'].toString() : "";
    website = map['website'] != null && map['website'].isNotEmpty ? map['website'].toString() : "";
    ownerName = map['ownerName'] != null && map['ownerName'].isNotEmpty ? map['ownerName'].toString() : "";
    rating = map['rating']?.toDouble() ?? 5;
    latitude = map['latitude']?.toDouble() ?? 0;
    longitude = map['longitude']?.toDouble() ?? 0;

    facilities = map['facilities'] != null ? List.castFrom(map['facilities']) : [];
    days = map['days'] != null ? Map.from(map["days"]) : {};
    otherFacilites = map['otherFacilites'] != null ? List.castFrom(map['otherFacilites']) : [];

    imageList = [];
    if (map["imageList"] != null) {
      map["imageList"].forEach((v) {
        imageList!.add(v);
      });
    }

    documentList = [];
    if (map["documentList"] != null) {
      map["documentList"].forEach((v) {
        documentList!.add(v);
      });
    }

    return VenueModel(
      name: name,
      description: description,
      city: city,
      state: state,
      createdBy:createdBy,
      phone:phone,
      address: address,
      lowerName: lowerName,
      id: id,
      isEnabledByVenue: isEnabledByVenue,
      isEnabledByOwner: isEnabledByOwner,
      facebook: facebook,
      ownerName: ownerName,
      website: website,
      whatsapp: whatsapp,
      latitude: latitude,      
      longitude: longitude,      
      days: days,
      documentList: documentList,
      timings: timings,
      facilities: facilities,
      otherFacilites: otherFacilites,
      imageList: imageList,
      rating: rating,
    );
  }

  void updateFromMap(Map<String, dynamic> map) {
    name = map['title'] != null && map['title'].isNotEmpty ? map['title'].toString() : "";
    timings = map['timings'] != null && map['timings'].isNotEmpty ? map['timings'].toString() : "";
    createdBy = map['createdBy'] != null && map['createdBy'].isNotEmpty ? map['createdBy'].toString() : "";
    isEnabledByOwner = map['isEnabledByOwner'] != null  ? map['isEnabledByOwner'] : false;
    isEnabledByVenue = map['isEnabledByVenue'] != null  ? map['isEnabledByVenue'] : false;
    phone = map['phone'] != null && map['phone'].isNotEmpty ? map['phone'].toString() : "";
    description = map['description'] != null && map['description'].isNotEmpty ? map['description'].toString() : "";
    address = map['address'] != null && map['address'].isNotEmpty ? map['address'].toString() : "";
    lowerName = map['lowerName'] != null && map['lowerName'].isNotEmpty ? map['lowerName'].toString() : "";
    id = map['id'] != null && map['id'].isNotEmpty ? map['id'].toString() : "";
    city = map['city'] != null && map['city'].isNotEmpty ? map['city'].toString() : "";
    state = map['state'] != null && map['state'].isNotEmpty ? map['state'].toString() : "";
    whatsapp = map['whatsapp'] != null && map['whatsapp'].isNotEmpty ? map['whatsapp'].toString() : "";
    facebook = map['facebook'] != null && map['facebook'].isNotEmpty ? map['facebook'].toString() : "";
    website = map['website'] != null && map['website'].isNotEmpty ? map['website'].toString() : "";
    ownerName = map['ownerName'] != null && map['ownerName'].isNotEmpty ? map['ownerName'].toString() : "";
    rating = map['rating']?.toDouble() ?? 5;
    longitude = map['longitude']?.toDouble() ?? 0;
    latitude= map['latitude']?.toDouble() ?? 0;

    facilities = map['facilities'] != null ? List.castFrom(map['facilities']) : [];
    days = map['days'] != null ? Map.from(map["days"]) : {};
    otherFacilites = map['otherFacilites'] != null ? List.castFrom(map['otherFacilites']) : [];

    imageList = [];
    if (map["imageList"] != null) {
      map["imageList"].forEach((v) {
        imageList!.add(v);
      });
    }

    documentList = [];
    if (map["documentList"] != null) {
      map["documentList"].forEach((v) {
        documentList!.add(v);
      });
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["title"] = name ?? "";
    data["description"] = description ?? "";
    data["isEnabledByOwner"] = isEnabledByOwner ?? false;
    data["isEnabledByVenue"] = isEnabledByVenue ?? false;
    data["createdBy"] = createdBy ?? "";
    data["city"] = city ?? "";
    data["lowerName"] = lowerName ?? "";
    data["address"] = address ?? "";
    data["state"] = state ?? "";
    data["id"] = id ?? "";
    data["phone"] = phone ?? "";
    data["ownerName"] = ownerName ?? "";
    data["whatsapp"] = whatsapp ?? "";
    data["facebook"] = facebook ?? "";
    data["website"] = website ?? "";
    data["longitude"] = longitude ?? 0;
    data["latitude"] = latitude ?? 0;
    data["timings"] = timings ?? "";
    data["imageList"] = imageList ?? [];
    data["facilities"] = facilities ?? [];
    data["documentList"] = documentList ?? [];
    data["otherFacilites"] = otherFacilites ?? [];
    data["days"] = days ?? {};
    data["rating"] = rating ?? 5.0;

    return data;
  }
}