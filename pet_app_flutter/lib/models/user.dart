class UserClass {
  final String username;
  final String name;
  final String avatar;

  UserClass({
    this.username = '',
    this.name = '',
    this.avatar = '',
    String userID,
  });

  static UserClass fromJson(Map<String, dynamic> json) => UserClass(
        username: json['username'],
        name: json['name'],
        avatar: json['picUrl'],
      );
}
