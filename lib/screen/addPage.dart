import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/uihelper/snackbar_todo.dart';

class addPage extends StatefulWidget {
  final Map? todo;
  const addPage({super.key, this.todo});

  @override
  State<addPage> createState() => _addPageState();
}

class _addPageState extends State<addPage> {
  TextEditingController titleCon = TextEditingController();
  TextEditingController descriptionCon = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleCon.text = title;
      descriptionCon.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            isEdit==true ? "Edit todo" : "Add Todo",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.black45),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 13, vertical: 5),
        children: [
          TextField(
            controller: titleCon,
            decoration: InputDecoration(hintText: "title"),
          ),
          TextField(
            controller: descriptionCon,
            decoration: InputDecoration(
              hintText: "Description",
            ),
            maxLines: 10,
            minLines: 5,
          ),
          SizedBox(
            height: 10,
            width: 7,
          ),
          ElevatedButton(
            onPressed: isEdit ? updatedata : submitData,

            child: Text(
              isEdit==true ? "Updtae" : "Submit ",
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.black45)),
          )
        ],
      ),
    );
  }

  Future<void> submitData() async {
    final title = titleCon.text;
    final description = descriptionCon.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    final url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      snackbar_todo.showScussefully(context,"Creation Succesfully");
    } else {
      snackbar_todo.showFailed(context,"Creation Failed");
    }
    titleCon.text = "";
    descriptionCon.text = "";
  }

  Future<void> updatedata() async {
    final todo = widget.todo;
    if(todo == null){
      print("you can't update withouttodo data");
      return;
    }
    final id = todo['_id'];
    final title = titleCon.text;
    final description = descriptionCon.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      snackbar_todo.showScussefully(context,"Update Succesfully");
    } else {
      snackbar_todo.showFailed(context,"Update Failed");
    }
    titleCon.text = "";
    descriptionCon.text = "";
  }
}
