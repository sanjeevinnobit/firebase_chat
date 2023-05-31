import 'package:firebase_chat/helper/firestore.dart';
import 'package:firebase_chat/ui/messages.dart';
import 'package:flutter/material.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  late bool loading;

  @override
  void initState() {
    loading = false;
    super.initState();
  }

  void getUsers() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users List"),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          final data = snapshot.data;
          return ListView.builder(
            itemBuilder: (context, index) => ListTile(
              onTap: () async {
                loading = true;
                setState(() {});
                try {
                  final id = await Firestore()
                      .initiateChat("", data?.elementAt(index) ?? "");
                  if (mounted) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Messages(
                          chatId: id,
                          name: data?.elementAt(index) ?? "",
                        ),
                      ),
                    );
                  }
                } catch (err) {
                  // ignore
                }
                loading = false;
                if (mounted) {
                  setState(() {});
                }
              },
              title: Text(data?.elementAt(index) ?? ""),
            ),
            itemCount: data?.length,
          );
        },
        future: Firestore().getUsers(),
      ),
    );
  }
}
