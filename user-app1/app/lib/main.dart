import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Map data;
  late List userData = [];

  Future<void> createUsers() async {
    final response =
        await http.get(Uri.parse('http://localhost:4000/api/users/create'));
    data = json.decode(response.body);

    setState(() {
      userData = data['users'];
    });
  }

  Future<void> getUsers() async {
    final response =
        await http.get(Uri.parse('http://localhost:4000/api/users'));
    data = json.decode(response.body);

    setState(() {
      userData = data['users'];
    });
  }

  Future<void> deleteUser(String id) async {
    final response =
        await http.delete(Uri.parse('http://localhost:4000/api/users/$id'));
    if (response.statusCode == 200) {
      setState(() {
        userData.removeWhere((user) => user['_id'] == id);
      });
    }
  }

  Future<void> updateUser(
      String id, String firstName, String lastName, String avatar) async {
    final response = await http.put(
      Uri.parse('http://localhost:4000/api/users/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'firstName': firstName,
        'lastName': lastName,
        'avatar': avatar,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        userData = userData.map((user) {
          if (user['_id'] == id) {
            return {
              '_id': id,
              'firstName': firstName,
              'lastName': lastName,
              'avatar': avatar,
            };
          }
          return user;
        }).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        backgroundColor: Colors.indigo[900],
        actions: [
          ElevatedButton(
            onPressed: () async {
              await createUsers();
            },
            child: Text('Create Users'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: userData.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "$index",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(userData[index]['avatar']),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "${userData[index]['firstName']} ${userData[index]['lastName']}",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      // Abre un diálogo para editar el usuario
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return EditUserDialog(
                            user: userData[index],
                            onSave: (firstName, lastName, avatar) {
                              updateUser(userData[index]['_id'], firstName,
                                  lastName, avatar);
                            },
                          );
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteUser(userData[index]['_id']);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class EditUserDialog extends StatefulWidget {
  final Map user;
  final Function(String, String, String) onSave;

  EditUserDialog({required this.user, required this.onSave});

  @override
  _EditUserDialogState createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController avatarController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.user['firstName']);
    lastNameController = TextEditingController(text: widget.user['lastName']);
    avatarController = TextEditingController(text: widget.user['avatar']);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit User'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: firstNameController,
            decoration: InputDecoration(labelText: 'First Name'),
          ),
          TextField(
            controller: lastNameController,
            decoration: InputDecoration(labelText: 'Last Name'),
          ),
          TextField(
            controller: avatarController,
            decoration: InputDecoration(labelText: 'Avatar URL'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onSave(
              firstNameController.text,
              lastNameController.text,
              avatarController.text,
            );
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
