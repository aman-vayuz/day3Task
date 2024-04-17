import 'package:isar/isar.dart';

part 'chat_model.g.dart';

@Collection()
class ChatMessage {
  Id id = Isar.autoIncrement;
  final String text;
  final DateTime timestamp;
  @enumerated
  final MessageType type;
  final bool isPaginationLoading;

  ChatMessage({
    required this.text,
    required this.timestamp,
    required this.type,
    this.isPaginationLoading = false,
  });
}

enum MessageType {
  sent,
  received,
}
