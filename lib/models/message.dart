// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Message {
  final String message;
  final DateTime dateTime;
  final bool isMe;
  Message({
    required this.message,
    required this.dateTime,
    required this.isMe,
  });

  Message copyWith({
    String? message,
    DateTime? dateTime,
    bool? isMe,
  }) {
    return Message(
      message: message ?? this.message,
      dateTime: dateTime ?? this.dateTime,
      isMe: isMe ?? this.isMe,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'isMe': isMe,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      message: map['message'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
      isMe: map['isMe'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) => Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Message(message: $message, dateTime: $dateTime, isMe: $isMe)';

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;
  
    return 
      other.message == message &&
      other.dateTime == dateTime &&
      other.isMe == isMe;
  }

  @override
  int get hashCode => message.hashCode ^ dateTime.hashCode ^ isMe.hashCode;
}
