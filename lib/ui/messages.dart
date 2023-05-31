import 'package:firebase_chat/helper/firestore.dart';
import 'package:firebase_chat/models/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Messages extends StatefulWidget {
  const Messages({
    required this.chatId,
    required this.name,
    super.key,
  });

  final String name;
  final String chatId;

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  late TextEditingController controller;
  late List<Message> messages;
  late ScrollController scrollController;

  @override
  void initState() {
    controller = TextEditingController(text: "");
    scrollController = ScrollController();
    messages = [];
    // listen();
    super.initState();
  }

  void listen() {
    Firestore().getMessages(widget.chatId).listen((event) {
      messages = [];
      messages.addAll(event ?? []);
      messages.sort((m1, m2) {
        return (m2.time?.millisecondsSinceEpoch ?? 0) -
            (m1.time?.millisecondsSinceEpoch ?? 0);
      });
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        scrollController
            .animateTo(
              0.0,
              duration: Duration.zero,
              curve: Curves.linear,
            )
            .then((value) => setState(() {}));
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Text(
                      "No messages",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.black),
                    ),
                  )
                : ListView.builder(
                    reverse: true,
                    controller: scrollController,
                    shrinkWrap: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final right = messages[index].sender == "";
                      final time = DateFormat("dd MMM yyyy").format(
                        messages[index].time ?? DateTime.now(),
                      );
                      return Column(
                        crossAxisAlignment: right
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: <Widget>[
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.85,
                            ),
                            child: Column(
                              crossAxisAlignment: right
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.all(8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                    color: Colors.grey.shade300,
                                  ),
                                  child: Text(messages[index].message ?? ""),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 12,
                                      right: right ? 8 : 0,
                                      left: right ? 0 : 8),
                                  child: Text(
                                    time,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      hintText: "Enter message",
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    try {
                      await Firestore().sendMessage(
                        "",
                        widget.name,
                        widget.chatId,
                        controller.text,
                      );
                    } catch (err) {
                      // ignore
                    }
                    controller.clear();
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
