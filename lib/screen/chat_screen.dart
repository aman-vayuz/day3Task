import 'package:chat_vayuz/custom_widgets/custom_widgets.dart';
import 'package:chat_vayuz/model/chat_model.dart';
import 'package:chat_vayuz/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatProvider? chatProvider;
  final msgTxtController = TextEditingController();
  final scrollController = ScrollController();
  DateTime time = DateTime.now();

  @override
  void initState() {
    super.initState();
    chatProvider = Provider.of(context, listen: false);
    initChat();
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection == ScrollDirection.forward &&
          scrollController.position.pixels > 0) {
        print('At the top of the list');
        fetchMoreData(chatProvider!.allChat.length, 10);
      }
    }); }


  int initialChatFetch = 20;

  Future<void> initChat() async {
    await chatProvider?.initialise();
    int? totalLength = await chatProvider?.getLength();
    totalLength = (totalLength! - initialChatFetch);
    chatProvider?.fetchChat(initialChatFetch, totalLength);
  }

  // Future<void>fetchDataRefresh ()async{
  //   int? totalLength = await chatProvider?.getLength();
  //   totalLength = (totalLength! - initialChatFetch);
  //   chatProvider?.fetchChat(initialChatFetch, 30);
  // }


  void fetchMoreData(int limit , int offSet) {
    chatProvider?.fetchChat(limit, offSet);
  }

  @override
  void dispose() {
    super.dispose();
    msgTxtController.dispose();
    // scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    chatProvider = context.watch<ChatProvider>();
    // final int? lgt = context.watch<ChatProvider>().getLength() as int?;
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // Center( child: ElevatedButton(onPressed: () {
            //   fetchMoreData(initialChatFetch, 15 ); }, child: Text('fetch'),),),
            Expanded(
                child: chatProvider!.allChat.isNotEmpty
                    ? ListView.builder(
                  // scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        controller: scrollController,
                        itemCount: chatProvider?.allChat.length,
                        itemBuilder: (context, index) {
                          final message = chatProvider?.allChat[index];
                          return Align(
                            alignment: message!.type.index == 1
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: message.type == MessageType.sent
                                    ? Colors.blue[100]
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(message.text),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text('no chats for now'),
                      )),
            CustomTextField(
              controller: msgTxtController,
              hintText: 'Type something....',
              toSendByMe: () {
                if (msgTxtController.text.isNotEmpty &&
                    msgTxtController.text != ' ') {
                  print(msgTxtController.text);
                  chatProvider?.sendMessage(
                      msgTxtController.text, time, MessageType.sent);
                  msgTxtController.clear();
                  _scrollToEnd();
                }
              },
              toSendByOther: () {
                if (msgTxtController.text.isNotEmpty &&
                    msgTxtController.text != ' ') {
                  print(msgTxtController.text);

                  chatProvider?.sendMessage(
                      msgTxtController.text, time, MessageType.received);
                  msgTxtController.clear();
                  _scrollToEnd();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void _scrollToEnd() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }
}

String checkType(MessageType category) {
  switch (category) {
    case MessageType.sent:
      return 'sent';
    case MessageType.received:
      return 'received';
    default:
      return '';
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          const CustomAppBarText(
            text: 'Myself',
          ),
          smallText('online')
        ],
      ),
      leading: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 10,
          child: Stack(children: [
            Text('M'),
            Positioned(
                top: 0,
                right: 0,
                child: Text(
                  '.',
                  style: TextStyle(fontSize: 40, color: Colors.red),
                ))
          ]),
        ),
      ),
      elevation: 1,
      bottomOpacity: 8,
      shadowColor: Colors.grey[200],
    );
  }

  Text smallText(String txt) {
    return Text(
      txt,
      style: TextStyle(
        color: Colors.grey[400],
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
