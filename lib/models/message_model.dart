class MessageModel {
  final String id;
  final String userId;
  final String chatId;
  final String content;
  List<String>? imageUrls;
  final DateTime timestamp;

  MessageModel(
      {required this.id,
      required this.userId,
      required this.chatId,
      required this.content,
      this.imageUrls,
      required this.timestamp});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      chatId: json['chatId'] ?? '',
      content: json['content'] ?? '',
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      timestamp: DateTime.parse(
        json['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'chatId': chatId,
      'content': content,
      'imageUrls': imageUrls,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
