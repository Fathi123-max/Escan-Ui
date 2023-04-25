import 'package:cloud_firestore/cloud_firestore.dart';

class House {
  String? id;
  int? amount;
  int? bedrooms;
  int? bathrooms;
  int? garages;
  int? kitchen;
  String? address;
  double? squarefoot;
  List<dynamic>? photos;
  bool? isFavorite;
  House(
      {this.id,
      this.amount,
      this.address,
      this.bedrooms,
      this.bathrooms,
      this.squarefoot,
      this.garages,
      this.kitchen,
      this.photos,
      this.isFavorite});

  // Convert the House object to a Map object that can be stored in Firestore.
  Map<String, dynamic> toFirebaseMap() {
    return {
      'id': id,
      'amount': amount,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'garages': garages,
      'kitchen': kitchen,
      'address': address,
      'squarefoot': squarefoot,
      'photos': photos,
      'isFavorite': isFavorite
    };
  }

  // Create a House object from a Firestore DocumentSnapshot.
  static House fromFirebaseSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return House(
        id: doc.id,
        amount: data['amount'],
        bedrooms: data['bedrooms'],
        bathrooms: data['bathrooms'],
        garages: data['garages'],
        kitchen: data['kitchen'],
        address: data['address'],
        squarefoot: data['squarefoot'],
        photos: List<String>.from(data['photos'] ?? []),
        isFavorite: data["isFavorite"]);
  }
}

class HouseMember {
  final String? name;
  final String? profileImage;

  HouseMember({
    this.name,
    this.profileImage,
  });

  factory HouseMember.fromMap(Map<String, dynamic> map) {
    return HouseMember(
      name: map['name'],
      profileImage: map['email'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': profileImage,
    };
  }
}
