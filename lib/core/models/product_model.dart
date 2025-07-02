// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:invoice_billing_app/core/entities/invoice.dart';

class ProductModel extends Product {
  ProductModel({
    required super.description,
    required super.quantity,
    required super.rate,
    required super.per,
    required super.totalPrice,
    required super.hsn,
    required super.rateWithTax,
  });

  ProductModel copyWith({
    String? description,
    String? hsn,
    int? quantity,
    double? rate,
    double? rateWithTax,
    String? per,
    double? totalPrice,
  }) {
    return ProductModel(
      description: description ?? this.description,
      hsn: hsn ?? this.hsn,
      quantity: quantity ?? this.quantity,
      rate: rate ?? this.rate,
      rateWithTax: rateWithTax ?? this.rateWithTax,
      per: per ?? this.per,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'hsn': hsn,
      'quantity': quantity,
      'rate': rate,
      'rateWithTax': rateWithTax,
      'per': per,
      'totalPrice': totalPrice,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      description: map['description'] as String,
      hsn: map['hsn'] as String,
      quantity: map['quantity'] as int,
      rate: map['rate'] as double,
      rateWithTax: map['rateWithTax'] as double,
      per: map['per'] as String,
      totalPrice: map['totalPrice'] as double,
    );
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      description: product.description,
      hsn: product.hsn,
      quantity: product.quantity,
      rate: product.rate,
      rateWithTax: product.rateWithTax,
      per: product.per,
      totalPrice: product.totalPrice,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(description: $description, hsn: $hsn, quantity: $quantity, rate: $rate, rateWithTax: $rateWithTax, per: $per, totalPrice: $totalPrice)';
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;

    return other.description == description &&
        other.hsn == hsn &&
        other.quantity == quantity &&
        other.rate == rate &&
        other.rateWithTax == rateWithTax &&
        other.per == per &&
        other.totalPrice == totalPrice;
  }

  @override
  int get hashCode {
    return description.hashCode ^
        hsn.hashCode ^
        quantity.hashCode ^
        rate.hashCode ^
        rateWithTax.hashCode ^
        per.hashCode ^
        totalPrice.hashCode;
  }
}
