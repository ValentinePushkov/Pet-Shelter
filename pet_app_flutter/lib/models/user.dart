class UserClass {
  final String username;
  final String email;
  final String name;
  final String avatar;
  final String role;
  final String publicKey;

  UserClass({
    this.username = '',
    this.email = '',
    this.name = '',
    this.avatar = '',
    String userID,
    this.role = '',
    this.publicKey = '',
  });

  static UserClass fromJson(Map<String, dynamic> json) => UserClass(
        username: json['username'],
        email: json['email'],
        name: json['name'],
        avatar: json['picUrl'],
        role: json['role'],
      );
}
