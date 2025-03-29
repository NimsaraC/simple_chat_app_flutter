class ChatModel {
  final String id;
  final String UserOneId;
  final String UserTwoId;
  List<String> messages = [];
  String lastMessage;

  ChatModel({
    required this.id,
    required this.UserOneId,
    required this.UserTwoId,
    this.messages = const [],
    this.lastMessage = '',
    });

    factory ChatModel.fromJson(Map<String, dynamic> json) {
      return  ChatModel(
        id: json['id'] ?? '',
        UserOneId: json['UserOneId'] ?? '',
        UserTwoId: json['UserTwoId'] ?? '',
        messages: List<String>.from(json['messages'] ?? []),
        lastMessage: json['lastMessage'] ?? '',

      );
    }

    Map<String, dynamic> toJson() {
      return {
        'id': id,
        'UserOneId': UserOneId,
        'UserTwoId': UserTwoId,
        'messages': messages,
        'lastMessage': lastMessage,
      };
    }
}
