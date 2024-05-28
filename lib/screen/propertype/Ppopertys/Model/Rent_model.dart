class model_rent {
  int? idImage;
  int? propertyTypeId;
  String? imageNameRent;
  String? url;

  model_rent({this.idImage, this.propertyTypeId, this.imageNameRent, this.url});

  model_rent.fromJson(Map<String, dynamic> json) {
    idImage = json['id_image'];
    propertyTypeId = json['property_type_id'];
    imageNameRent = json['image_name_rent'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_image'] = idImage;
    data['property_type_id'] = propertyTypeId;
    data['image_name_rent'] = imageNameRent;
    data['url'] = url;
    return data;
  }
}
