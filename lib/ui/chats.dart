import 'dart:async';

import 'package:firebase_chat/helper/firestore.dart';
import 'package:firebase_chat/models/chat.dart';
import 'package:firebase_chat/ui/messages.dart';
import 'package:firebase_chat/ui/users_list.dart';
import 'package:flutter/material.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  late List<Chat> model;
  late StreamSubscription<List<Chat>?> subs;
  late bool loading;

  @override
  void initState() {
    model = [];
    loading = true;

    // listenStream();
    super.initState();
  }

  void listenStream() {
    subs = Firestore().getChats("").listen((event) {
      model = [];
      model.addAll(event ?? []);
      model.sort((model1, model2) {
        return (model1.updatedAt?.millisecondsSinceEpoch ?? 0) -
            (model2.updatedAt?.millisecondsSinceEpoch ?? 0);
      });
      loading = false;
      setState(() {});
    });
  }

  @override
  void dispose() {
    subs.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firebase Chat")),
      body: SafeArea(
        child: loading
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : model.isEmpty
                ? Center(
                    child: Text(
                      "No Chats Found",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    itemCount: model.length,
                    itemBuilder: (context, index) => ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Messages(
                              chatId: model[index].id ?? "",
                              name: model[index].email ?? "",
                            ),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        child:
                            Text((model[index].email ?? "")[0].toUpperCase()),
                      ),
                      title: Text(model[index].email ?? ""),
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const UsersList(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
