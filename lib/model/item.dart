import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final String title;
  final int quantity;

  const Item({
    required this.title,
    required this.quantity,
  });

  @override
  List<Object> get props => [ title, quantity];

  Item copyWith({
    String? title,
    int? quantity,
  }) {
    return Item(
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'quantity': quantity,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      title: map['title'] as String,
      quantity: map['quantity'] as int,
    );
  }
}
