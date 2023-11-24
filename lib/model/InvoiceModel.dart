class Invoice1 {
  String success;
  String Invoice;


  Invoice1(this.success, this.Invoice, );

  factory Invoice1.fromJson(dynamic json) {
    return Invoice1(json['success'] as String, json['Invoice'] as String);
  }

  @override
  String toString() {
    return '{ $success, $Invoice }';
  }

}

class ProductAdded1 {
  String success;
  String Product;
  String Invoice;
  String Added;

  @override
  String toString() {
    return 'ProductAdded1{success: $success, Product: $Product, Invoice: $Invoice, Added: $Added}';
  }


  ProductAdded1(this.success, this.Product,this.Invoice,this.Added );

  factory ProductAdded1.fromJson(dynamic json) {
    return ProductAdded1(json['success'] as String, json['Product'] as String, json['Invoice'] as String, json['Added'] as String);
  }


}
