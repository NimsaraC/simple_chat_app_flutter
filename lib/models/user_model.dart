
class UserModel {
  final String id;
  final String name;
  final String email;
  String imageUr;
  List<String> friends = [];
  List<String> groups = [];
  List<String> messages = [];

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.imageUr = '',
    this.friends = const [],
    this.groups = const [],
    this.messages = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      imageUr: json['imageUr'] ?? '',
      friends: List<String>.from(json['friends'] ?? []),
      groups: List<String>.from(json['groups'] ?? []),
      messages: List<String>.from(json['messages'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'imageUr': imageUr,
      'friends': friends,
      'groups': groups,
      'messages': messages,
    };
  }
}
