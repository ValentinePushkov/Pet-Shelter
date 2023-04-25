class Key {
  int id;
  String username;
  String privateKey;

  Key({this.id = 0, this.username = '', this.privateKey = ''});

  factory Key.fromMap(Map<String, dynamic> json) => Key(
        id: json['id'] ?? 0,
        username: json['title'] ?? '',
        privateKey: json['description'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
        'privateKey': privateKey,
      };
}
