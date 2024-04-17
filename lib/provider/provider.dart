import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../model/chat_model.dart';

class ChatProvider extends ChangeNotifier {
  static late Isar isar;
  var totalLength;
  Future<void> initialise() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ChatMessageSchema], directory: dir.path);
    getLength();
  }


  Future<int> getLength() async {
     totalLength = await isar.chatMessages.count();
    print(totalLength);
    return totalLength;
  }
  // late int length = getLen;

  final List<ChatMessage> allChat = [];


  // final Future<int> chatLength = isar.chatMessages.count();

  final List chatStream = [];

  Future<void> sendMessage(
      String msgTxt, DateTime time, MessageType msgType) async {
    final newChatMsg =
        ChatMessage(text: msgTxt, timestamp: time, type: msgType);

    await isar.writeTxn(() => isar.chatMessages.put(newChatMsg));
    notifyListeners();
    fetchAllChat();
  }

  // Future<void> fetchLastTenChat() async {
  //   final fetchedNote = await isar.chatMessages
  //       .where()
  //       .findAll();
  //
  //   if (fetchedNote != null && fetchedNote is Iterable<ChatMessage>) {
  //     // Sort the messages by timestamp in descending order
  //     final sortedMessages = fetchedNote.toList()
  //       ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  //
  //     // Get the last 10 messages
  //     final lastTenMessages = sortedMessages.take(10);
  //
  //     allChat.clear();
  //     allChat.addAll(lastTenMessages);
  //     notifyListeners();
  //   } else {
  //     // Handle error or return an empty list
  //   }
  // }



  Future<void> fetchAllChat() async {
    final fetchedNote = await isar.chatMessages.where().findAll();
    allChat.clear();
    allChat.addAll(fetchedNote);
    print("the current list should be ${allChat.length}");
    print(fetchedNote.length);
    log("${allChat[fetchedNote.length - 1].type}");
    notifyListeners();
  }

  Future<void> fetchChat(int limit, int  offSet) async {
    final fetchedNote = await isar.chatMessages.where().offset(offSet).limit(limit).findAll();
    allChat.clear();
    allChat.addAll(fetchedNote);
    notifyListeners();
  }

// Future<Stream<List<ChatMessage>>> streamChat() async {
//   final chatStream = await isar.chatMessages.where().limit(10).watch();
//   notifyListeners();
//   return chatStream;
// }
// Future<void> deleteNote(int id) async {
//   await isar.writeTxn(() => isar.chatMessages.delete(id));
//   fetchChat();
// }

// Future<void> updateNote(int id, String editedTxt ,  MessageType msgType) async {
//   final existingMsg = await isar.chatMessages.get(id);
//
//   if (existingMsg != null) {
//     existingMsg.text = editedTxt;
//     existingMsg.category = taskCategory;
//     await isar.writeTxn(() => isar.chatMessages.put(existingMsg));
//     await fetchChat();
//   }
// }
}
