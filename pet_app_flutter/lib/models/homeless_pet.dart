// ignore_for_file: public_member_api_docs, sort_constructors_first

class HomelessPet {
  final String name;
  final String category;
  final String sex;
  final String species;
  final String location;
  final String description;
  final String date;
  final String image;
  final String owner;
  final String status;
  final String petStatus;
  final String nfcTag;

  HomelessPet({
    this.name,
    this.category,
    this.sex,
    this.species,
    this.location,
    this.description,
    this.date,
    this.image,
    this.owner,
    this.status,
    this.petStatus,
    this.nfcTag,
  });

  static HomelessPet fromJson(Map<String, dynamic> json) => HomelessPet(
        name: json['name'],
        category: json['category'],
        sex: json['sex'],
        species: json['species'],
        nfcTag: json['nfcTag'],
        location: json['location'],
        description: json['description'],
        date: json['date'],
        image: json['image'],
        owner: json['owner'],
        status: json['status'],
        petStatus: json['petStatus'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'category': category,
        'sex': sex,
        'species': species,
        'nfcTag': nfcTag,
        'location': location,
        'description': description,
        'date': date,
        'image': image,
        'owner': owner,
        'status': status,
        'petStatus': petStatus,
      };
}
