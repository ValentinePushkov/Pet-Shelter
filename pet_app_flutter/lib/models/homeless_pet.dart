// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class HomelessPet {
  String petID;
  String name;
  String category;
  String sex;
  String species;
  double age;
  String location;
  String description;
  String image;
  String owner;
  String status;

  HomelessPet({
    this.petID,
    this.name,
    this.category,
    this.sex,
    this.species,
    this.age,
    this.location,
    this.description,
    this.image,
    this.owner,
    this.status,
  });

  static HomelessPet fromJson(Map<String, dynamic> json) => HomelessPet(
        petID: json['petID'],
        name: json['name'],
        category: json['category'],
        sex: json['sex'],
        species: json['species'],
        age: double.parse(json['age'].toString()),
        location: json['location'],
        description: json['description'],
        image: json['image'],
        owner: json['owner'],
        status: json['status'],
      );
}
