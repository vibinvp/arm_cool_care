class AmenitiesModel {
  bool? status;
  String? message;
  Data? data;
  int? total;

  AmenitiesModel({this.status, this.message, this.data, this.total});

  AmenitiesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['data'] = this.data!.toJson();
    data['total'] = total;
    return data;
  }
}

class Data {
  List<CustomFieldsValue>? customFieldsValue;

  Data({this.customFieldsValue});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['custom_fields_value'] != null) {
      customFieldsValue = <CustomFieldsValue>[];
      json['custom_fields_value'].forEach((v) {
        customFieldsValue!.add(CustomFieldsValue.fromJson(v));
        print("customFieldsValue add--> ${customFieldsValue!.length}");
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['custom_fields_value'] =
        customFieldsValue!.map((v) => v.toJson()).toList();
    return data;
  }
}

class CustomFieldsValue {
  String? povId;
  String? catIds;
  String? productId;
  String? shopId;
  String? mcfId;
  String? fieldsType;
  String? fieldsName;
  String? fieldValue;
  String? createdAt;
  String? updatedAt;

  CustomFieldsValue(
      {this.povId,
      this.catIds,
      this.productId,
      this.shopId,
      this.mcfId,
      this.fieldsType,
      this.fieldsName,
      this.fieldValue,
      this.createdAt,
      this.updatedAt});

  CustomFieldsValue.fromJson(Map<String, dynamic> json) {
    povId = json['pov_id'];
    catIds = json['cat_ids'];
    productId = json['product_id'];
    shopId = json['shop_id'];
    mcfId = json['mcf_id'];
    fieldsType = json['fields_type'];
    fieldsName = json['fields_name'];
    fieldValue = json['field_value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pov_id'] = povId;
    data['cat_ids'] = catIds;
    data['product_id'] = productId;
    data['shop_id'] = shopId;
    data['mcf_id'] = mcfId;
    data['fields_type'] = fieldsType;
    data['fields_name'] = fieldsName;
    data['field_value'] = fieldValue;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
