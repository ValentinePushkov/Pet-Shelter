class ModerationPet {
  final String petID;
  final String name;
  final String category;
  final String sex;
  final String species;
  final double age;
  final String location;
  final String description;
  final String date;
  final String image;
  final String owner;
  final String status;
  final String petStatus;

  ModerationPet({
    this.petID,
    this.name,
    this.category,
    this.sex,
    this.species,
    this.age,
    this.location,
    this.description,
    this.date,
    this.image,
    this.owner,
    this.status,
    this.petStatus,
  });

  static ModerationPet fromJson(Map<String, dynamic> json) => ModerationPet(
        petID: json['petID'],
        name: json['name'],
        category: json['category'],
        sex: json['sex'],
        species: json['species'],
        age: double.parse(json['age'].toString()),
        location: json['location'],
        description: json['description'],
        date: json['date'],
        image: json['image'],
        owner: json['owner'],
        status: json['status'],
        petStatus: json['petStatus'],
      );
}
