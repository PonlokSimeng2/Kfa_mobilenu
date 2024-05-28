class Model_sale_image {
  int? idImage;
  int? propertyTypeId;
  String? imageNameSale;
  String? url;

  Model_sale_image(
      {this.idImage, this.propertyTypeId, this.imageNameSale, this.url,});

  Model_sale_image.fromJson(Map<String, dynamic> json) {
    idImage = json['id_image'];
    propertyTypeId = json['property_type_id'];
    imageNameSale = json['image_name_sale'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_image'] = idImage;
    data['property_type_id'] = propertyTypeId;
    data['image_name_sale'] = imageNameSale;
    data['url'] = url;
    return data;
  }
}
