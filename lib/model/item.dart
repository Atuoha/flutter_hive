import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final String id;
  final String title;
  final int quantity;

  const Item({
    required this.id,
    required this.title,
    required this.quantity,
  });

  @override
  List<Object> get props => [id, title, quantity];

  Item copyWith({
    String? id,
    String? title,
    int? quantity,
  }) {
    return Item(
      id: id ?? this.id,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
    );
  }
}
