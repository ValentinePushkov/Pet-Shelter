class Store {
  final String name;
  final String url;
  final String description;
  final String image;

  Store({
    this.name = '',
    this.url = '',
    this.description = '',
    this.image = '',
  });

  static Store fromJson(Map<String, dynamic> json) => Store(
        name: json['name'],
        url: json['url'],
        description: json['description'],
        image: json['image'],
      );
}
