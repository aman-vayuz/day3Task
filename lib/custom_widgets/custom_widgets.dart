import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomAppBarText extends StatelessWidget {
  final String text;

  const CustomAppBarText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSentByMe;

  const ChatBubble(
      {super.key, required this.message, required this.isSentByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: isSentByMe ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final double borderRadius;
  final double elevation;
  final EdgeInsets padding;
  final VoidCallback  toSendByMe;
  final VoidCallback  toSendByOther;

  // final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.borderRadius = 12.0,
    this.elevation = 4.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
    required this.toSendByMe,
    required this.toSendByOther,
    // this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          IconButton(onPressed: toSendByOther, icon:   Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child:  Icon(Icons.send , color: Colors.purple[300] ,),
          ),),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical:  6),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                // onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  contentPadding: padding,
                ),
              ),
            ),
          ),
          // IconButton(onPressed: toSendByMe(), icon:  Icon(Icons.send , color: Colors.blue[300],))
          MaterialButton(
            onPressed: toSendByMe,
            shape: const CircleBorder(),
            color: Colors.blue[300],
            minWidth: 0,
            splashColor: Colors.green,
            child: const Icon(Icons.send),
          ),

        ],
      ),
    );
  }
}
